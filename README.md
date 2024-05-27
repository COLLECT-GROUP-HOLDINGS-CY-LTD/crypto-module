## Project Description

A smart contract that allows you to implement a service on its basis for receiving and issuing funds to clients. A secure solution for storing and interacting with finances.

A smart contract is one of the components of the crypto module; an additional module has been implemented for notification of receipt of funds to smart contract wallets and a role system on the side of the admin panel for interaction with client accounts.

## Project goals

The smart contract provides the ability to generate wallets to provide to clients for making deposits. Work with **ERC-20**, **BSC-20**, **TRC-20** networks and coins on these networks.

## Implemented functions

- Function of installing and changing the owner of smart contacts.
- Function of adding, deleting and viewing authorized addresses for generating wallets.
- The function of adding, deleting and viewing authorized addresses to grant the right to transfer funds from the wallet issued to the client to the master wallet.
- Wallet generation function with the ability to store and view a list of created wallets.
- Function for viewing the balance on wallets issued to clients.
- The function of transferring the balance to the master wallet including tokens on their networks.
- The function of collecting funds from client wallets to the master wallet.
- Withdrawal function upon customer request.
- Function for creating a withdrawal transaction.
- Multi-signature transaction function for withdrawal to the client.
- Function to view transaction status.
- Transaction signature function.
- Function for unsigning a transaction.
- Transaction cancellation function.

## Deployment instructions

1.  Go to the Remix website. Depending on the desired network, for **ETH and BSC** https://remix.ethereum.org/ for **Tron** https://www.tronide.io/
2. Download files with smart contract source code. **File explorer -> Upload files**
3. On the Solidity Compiler tab, select version **8.22xxx** in the Compiler field
4. In the Advanced Options settings, enable the **Enable optimization** checkbox
5. Click the **Compile** button
6. In [Metamask](https://metamask.io/ "Metamask") or [Tronlink](https://www.tronlink.org/ "Tronlink"), select the desired network
7. On the **Deploy & run** tab select:
	- In the field environment - **Injected Provider**
	- Check the correct name and id of the network immediately below this field
	- Check. that the wallet address from **Metamask** or **Tronlink** was added to the Account field
	- In the **Contract** field select:
		- **MultisigWallet** - for a multisig contract
		- **MyWalletFactory** - for wallet contract
		- Expand the list next to the **Deploy** button. In this list indicate:
		- For **MultisigWallet** - the address of the contract owner
		- For **MyWalletFactory** - owner address, multisig contract address
8. Click the Transact button and then confirm the remix pop-ups and sign the transaction in **Metamask** or **Tronlink**
