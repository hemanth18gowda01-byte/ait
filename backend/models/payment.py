import hashlib
import datetime

class PaymentVoucher:
    def __init__(self, paymentId: str, fromAddress: str, toAddress: str, valuation: int, timestamp: bytes, expirationTime: bytes):
        self.paymentId= paymentId
        self.valuation = valuation
        self.timestamp = timestamp
        self.expirationTime = expirationTime

    def generate_hash(self, *args):
        data = "".join(str(arg) for arg in args)
        return hashlib.sha256(data.encode("utf-8")).hexdigest()

    def create_voucher(self,_amount : int):
        self.valuation = _amount
        self.expirationTime = datetime.datetime.utcnow() + datetime.timedelta(days=7)
        self.timestamp = datetime.datetime.utcnow()
        self.paymentId = self.generate_hash(self.paymentId, _amount, self.timestamp, self.expirationTime)

    def transfer_voucher(self,_paymentId:str,_amountToSend:int,_toAddress:str):
        
