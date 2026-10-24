from cryptography.hazmat.primitives.hashes import SHA256 

class SplitPaymentVoucher:
    def __init__(self, paymentId: str, fromAddress: str, toAddress: str, valuation: int, timestamp: bytes):
        self.paymentId= paymentId
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.valuation = valuation
        self.timestamp = timestamp


