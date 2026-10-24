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
        bytes32 splitedPaymentId;
        address fromAddress;
        address toAddress;
        uint256 valuation;
        bytes timestamp;
    }

    PaymentVoucher[] public vouchers;
    SplitPaymentVoucher[] public splitVouchers;
    
    bytes32 => mapping(PaymentVoucher[] => SplitPaymentVoucher[])) public paymentVouchers;

    function createPaymentVoucher(uint256 _amount,PaymentVoucher memory ) payable external {
        require(msg.sender != address(0), "Invalid sender address");
        require(_amount > 0, "Amount must be greater than zero");
        require(msg.value >= _amount, "Insufficient funds sent");
        bytes32 _paymentId = keccak256(abi.encodePacked(msg.sender, _amount, block.timestamp));
        paymentVouchers[_paymentId].push(PaymentVoucher({
            paymentId: _paymentId,
            fromAddress: msg.sender,
            toAddress: address(0),
            valuation: _amount,
            timestamp: abi.encodePacked(block.timestamp)
        }));
    }

    function getPaymentVouchers(bytes32 _paymentId) external view returns (PaymentVoucher[] memory) {
        return paymentVouchers[_paymentId];
    }

    function splitPaymentVoucher(bytes32 _paymentId, uint256 _splitAmount) payable external {
        SplitPaymentVoucher[] storage vouchers = paymentVouchers[_paymentId];
        paymentVouchers[_paymentId].push(SplitPaymentVoucher({
            paymentId: _paymentId,
            fromAddress: msg.sender,
            toAddress: address(0),
            amount: _splitAmount,
            timestamp: abi.encodePacked(block.timestamp)
        }));
    }

    function receivePaymentVoucher(bytes32 _paymentId) external {
        
    }

}