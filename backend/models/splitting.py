import hashlib

class SplitPaymentVoucher:
    def __init__(self, paymentId: str, fromAddress: str, toAddress: str, valuation: int, timestamp: bytes, expirationTime: bytes):
        self.paymentId= paymentId
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.valuation = valuation
        self.timestamp = timestamp
        self.expirationTime = expirationTime

    def generate_hash(self, *args):
        data = "".join(str(arg) for arg in args)
        return hashlib.sha256(data.encode("utf-8")).hexdigest()

    def createVoucher(self, _valuation, _fromAddress, _toAddress, _timestamp, _expirationTime):
        self.valuation = _valuation
        self.fromAddress = _fromAddress
        self.toAddress = _toAddress
        self.timestamp = _timestamp
        self.expirationTime = _expirationTime
        hashCodeOfPaymentId = self.generate_hash(_fromAddress, _toAddress, _valuation, _timestamp)
        self.paymentId = hashCodeOfPaymentId

    def getVoucherDetails(self):
        return {
            "paymentId": self.paymentId,
            "fromAddress": self.fromAddress,
            "toAddress": self.toAddress,
            "valuation": self.valuation,
            "timestamp": self.timestamp,
            "expirationTime": self.expirationTime
        }

    def updateVoucher(self, _valuation, _toAddress, _timestamp,_sendingAmount):
        if _sendingAmount > self.valuation:
            raise ValueError("Sending amount exceeds the voucher valuation.")
        