//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


contract AutoPayment{

    struct PaymentVoucher{
        bytes32 paymentId;
        bytes32 splitedPaymentId;
        address fromAddress;
        address toAddress;
        uint256 valuation;
        uint256 timestamp;
        uint256 expirationTime;
    }

    event PaymentVoucherCreated(
        bytes32 indexed paymentId,
        address indexed fromAddress,
        int256 valuation,
        uint256 timestamp,
        uint256 expirationTime
    );

    event PaymentVoucherTransferred(
        bytes32 indexed paymentId,
        address indexed fromAddress,
        address indexed toAddress,
        int256 valuation,
        uint256 timestamp,
        uint256 expirationTime
    );
    

    mapping(bytes32 => PaymentVoucher) public paymentVouchers;

    function createPaymentVoucher(uint256 _amount) payable external virtual {
        require(msg.sender != address(0), "Invalid sender address");
        require(_amount > 0, "Amount must be greater than zero");
        require(msg.value >= _amount, "Insufficient funds sent");
        bytes32 _paymentId = keccak256(abi.encodePacked(msg.sender, _amount, block.timestamp));
        paymentVouchers[_paymentId] = PaymentVoucher({
            paymentId: _paymentId,
            splitedPaymentId: bytes32(0),
            fromAddress: msg.sender,
            toAddress: address(0),
            valuation: _amount,
            timestamp: block.timestamp,
            expirationTime: block.timestamp + 7 days
        });
        emit PaymentVoucherCreated(_paymentId, msg.sender, int(_amount), block.timestamp, block.timestamp + 7 days);
    }

    function getPaymentVouchers(bytes32 _paymentId) external view virtual returns (PaymentVoucher memory) {
        return paymentVouchers[_paymentId];
    }

    function transferPaymentVoucher(bytes32 _paymentId, address _toAddress,uint256 _amount) payable external virtual {
        require(paymentVouchers[_paymentId].fromAddress == msg.sender, "Only the sender can transfer the payment voucher");
        require(paymentVouchers[_paymentId].toAddress == address(0), "Payment voucher has already been transferred");
        require(paymentVouchers[_paymentId].expirationTime > block.timestamp, "Payment voucher has expired");
        paymentVouchers[_paymentId].toAddress = _toAddress;
        if (_amount == paymentVouchers[_paymentId].valuation) {
            paymentVouchers[_paymentId].valuation = 0;
            (bool sent, ) = _toAddress.call{value: _amount}("");
            require(sent, "Failed to send Ether");
            emit PaymentVoucherTransferred(_paymentId, msg.sender, _toAddress,int(_amount), block.timestamp, paymentVouchers[_paymentId].expirationTime);

        } else if (_amount < paymentVouchers[_paymentId].valuation) {
            (bool sent, ) = _toAddress.call{value: _amount}("");
            require(sent, "Failed to send Ether");
            emit PaymentVoucherTransferred(_paymentId, msg.sender, _toAddress, int(_amount), block.timestamp, paymentVouchers[_paymentId].expirationTime);
            paymentVouchers[_paymentId].valuation = paymentVouchers[_paymentId].valuation - _amount;
            paymentVouchers[_paymentId].timestamp = block.timestamp;
            paymentVouchers[_paymentId].toAddress = address(0);
            paymentVouchers[_paymentId].splitedPaymentId = keccak256(abi.encodePacked(msg.sender, _amount, block.timestamp));
        } else {
            revert("Transfer amount exceeds the payment voucher valuation");

        }
    }

}