//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AutoPayment {
    address public owner;

    struct PaymentVoucher{
        bytes32 paymentId;
        address fromAddress;
        address toAddress;
        uint256 valuation;
        bytes timestamp;
    }

    struct SplitPaymentVoucher{
        bytes32 paymentId;
        bytes32 splitedPaymentId;
        address fromAddress;
        address toAddress;
        uint256 valuation;
        bytes timestamp;
    }

    mapping(bytes32 => PaymentVoucher) public paymentVouchers;
    mapping(bytes32 => mapping(bytes32 => SplitPaymentVoucher)) public splitpaymentVouchers;

    function createPaymentVoucher(uint256 _amount) payable external {
        require(msg.sender != address(0), "Invalid sender address");
        require(_amount > 0, "Amount must be greater than zero");
        require(msg.value >= _amount, "Insufficient funds sent");
        bytes32 _paymentId = keccak256(abi.encodePacked(msg.sender, _amount, block.timestamp));
        paymentVouchers[_paymentId] = PaymentVoucher({
            paymentId: _paymentId,
            fromAddress: msg.sender,
            toAddress: address(0),
            valuation: _amount,
            timestamp: abi.encodePacked(block.timestamp)
        });
    }

    function getPaymentVouchers(bytes32 _paymentId) external view returns (PaymentVoucher memory) {
        return paymentVouchers[_paymentId];
    }

    function transferPaymentVoucher(bytes32 _paymentId, address _toAddress) payable external {
        require(paymentVouchers[_paymentId].fromAddress == msg.sender, "Only the sender can transfer the payment voucher");
        require(paymentVouchers[_paymentId].toAddress == address(0), "Payment voucher has already been transferred");
        paymentVouchers[_paymentId].toAddress = _toAddress;
    }

    function receivePaymentVoucher(bytes32 _paymentId) payable external {
        require(paymentVouchers[_paymentId].toAddress == msg.sender, "Only the recipient can receive the payment voucher");
    }

    function updatingVoucherAfterSplitting(bytes32 _paymentId, bytes32 _splitedPaymentId, uint256 _valuation) payable external {
        require(paymentVouchers[_paymentId].fromAddress == msg.sender, "Only the sender can update the payment voucher");
        require(paymentVouchers[_paymentId].toAddress == address(0), "Payment voucher has already been transferred");
        require(msg.value >= _valuation, "Insufficient balance to split the payment voucher");
        splitpaymentVouchers[_paymentId][_splitedPaymentId] = SplitPaymentVoucher({
            paymentId: _paymentId,
            splitedPaymentId: _splitedPaymentId,
            fromAddress: msg.sender,
            toAddress: address(0),
            valuation: _valuation,
            timestamp: abi.encodePacked(block.timestamp)
        });
    }

}