import hashlib
import datetime

class PaymentVoucherCreation:
    def __init__(self, paymentId: str,voucherId:str, fromAddress: str, toAddress: str, valuation: int, timestamp: bytes, expirationTime: bytes):
        self.paymentId= paymentId
        self.voucherId= ''
        self.valuation = valuation
        self.toAddress = ''
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

    def transferPaymentVoucher(self,_paymentId,_toAddress,_amountToSend,_timestamp):
        



    
        


