//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AutoPayment {
    address public owner;

    struct PaymentVoucher{
        bytes32 paymentId;
        address fromAddress;
        address toAddress;
        uint256 amount;
        bytes timestamp;
    }

    PaymentVoucher[] public vouchers;
    mapping(address => PaymentVoucher[]) public paymentVouchers;

    function createPaymentVoucher(uint256 _amount,PaymentVoucher memory ) payable external {
        require(msg.sender != address(0), "Invalid sender address");
        require(_amount > 0, "Amount must be greater than zero");
        require(msg.value >= _amount, "Insufficient funds sent");
        paymentVouchers[msg.sender].push(PaymentVoucher({
            paymentId: keccak256(abi.encodePacked(msg.sender, _amount, block.timestamp)),
            fromAddress: msg.sender,
            toAddress: address(0),
            amount: _amount,
            timestamp: abi.encodePacked(block.timestamp)
        }));
    }

    function getPaymentVouchers(address _user) external view returns (PaymentVoucher[] memory) {
        return paymentVouchers[_user];
    }

    function splitPaymentVoucher(bytes32 _paymentId, uint256 _splitAmount) external {
        PaymentVoucher[] storage userVouchers = paymentVouchers[msg.sender];
        for (uint256 i = 0; i < userVouchers.length; i++) {
            if (userVouchers[i].paymentId == _paymentId) {
                require(userVouchers[i].amount >= _splitAmount, "Insufficient funds");
                userVouchers[i].amount -= _splitAmount;
                paymentVouchers[msg.sender].push(PaymentVoucher({
                    paymentId: keccak256(abi.encodePacked(msg.sender, _splitAmount, block.timestamp)),
                    fromAddress: msg.sender,
                    toAddress: address(0),
                    amount: _splitAmount,
                    timestamp: abi.encodePacked(block.timestamp)
                }));
                return;
            }
        }
        revert("Payment voucher not found");
    }

    function receivePaymentVoucher(bytes32 _paymentId) external {
        
    }

}