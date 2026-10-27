//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {AutoPayment} from "./simpleAutoPayment.sol";

contract StorageFactory is AutoPayment {
    AutoPayment public autoPaymentContract;

    constructor() {
        autoPaymentContract = new AutoPayment();
    }

    function createPaymentVoucher(uint256 _amount) external payable override {
        autoPaymentContract.createPaymentVoucher{value: msg.value}(_amount);
    }

    function getPaymentVouchers(bytes32 _paymentId) external view override returns (AutoPayment.PaymentVoucher memory) {
        return autoPaymentContract.getPaymentVouchers(_paymentId);
    }

    function transferPaymentVoucher(bytes32 _paymentId, address _toAddress, uint256 _amount) external payable override{
        autoPaymentContract.transferPaymentVoucher{value: msg.value}(_paymentId, _toAddress, _amount);
    }
}