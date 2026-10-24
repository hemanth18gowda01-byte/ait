import os
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

class Encryption:
    def __init__(self, key: bytes):
        self.key = key

    def encrypt(self, plaintext: bytes) -> bytes:
        aesgcm = AESGCM(self.key)
        nonce = os.urandom(12)  # Generate a random nonce
        ciphertext = aesgcm.encrypt(nonce, plaintext, None)
        return nonce + ciphertext  # Prepend nonce to the ciphertext

    def decrypt(self, ciphertext: bytes) -> bytes:
        aesgcm = AESGCM(self.key)
        nonce = ciphertext[:12]  # Extract the nonce
        actual_ciphertext = ciphertext[12:]  # Extract the actual ciphertext
        return aesgcm.decrypt(nonce, actual_ciphertext, None)
