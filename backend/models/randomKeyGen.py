import os

def generate_random_key():
    key = os.urandom(32)  # Generate a 256-bit random key
    return key.hex()

print("Random Key:", generate_random_key())

