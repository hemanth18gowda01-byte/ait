from web3 import Web3

# Connect to Ethereum node (Infura, Alchemy, or local Ganache)
# Example: Infura mainnet endpoint
infura_url = "https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID"
w3 = Web3(Web3.HTTPProvider(infura_url))

# Check connection
if not w3.is_connected():
    raise ConnectionError("Failed to connect to Ethereum node")

# Example: Get balance of an address
address = "0x742d35Cc6634C0532925a3b844Bc454eDf8aD8e"
balance_wei = w3.eth.get_balance(address)
balance_eth = w3.from_wei(balance_wei, 'ether')
print(f"Balance: {balance_eth} ETH")

# Example: Send a transaction (requires private key)
private_key = "YOUR_PRIVATE_KEY"
sender_address = w3.eth.account.from_key(private_key).address
receiver_address = "0xRecipientAddressHere"

# Build transaction
tx = {
    'nonce': w3.eth.get_transaction_count(sender_address),
    'to': receiver_address,
    'value': w3.to_wei(0.01, 'ether'),
    'gas': 21000,
    'gasPrice': w3.to_wei('50', 'gwei')
}

# Sign transaction
signed_tx = w3.eth.account.sign_transaction(tx, private_key)

# Send transaction
tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
print(f"Transaction sent: {w3.to_hex(tx_hash)}")
