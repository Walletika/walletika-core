# Walletika Core
The Walletika core library that allows to storage and connect with web3.
- Designed by: Walletika Team

## Overview
- Check example folder to learn more.

### Walletika Core Initialization
```dart
import 'package:walletika_creator/walletika_creator.dart';

await walletikaCoreInitialize();
```

### ProviderEngine to connect with ethereum or any network of layer2
```dart
NetworkData networkData = NetworkData(
    rpc: 'https://mainnet.infura.io/v3/0bbf89ffa7794d2f9fd1ebd4cae51edd',
    name: 'Ethereum',
    chainID: 1,
    symbol: 'ETH',
    explorer: 'https://etherscan.io',
    isLocked: false,
);

// Connect with RPC
ProviderEngine.instance.connect(networkData);

// Check balance
EtherAmount balance = await ProviderEngine.instance.balanceOf(
    address: EthereumAddress.fromHex('0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3'),
);

// Transfer coin
TxDetailsData txDetails = await ProviderEngine.instance.transfer(
    sender: EthereumAddress.fromHex('0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3'),
    recipient: EthereumAddress.fromHex('0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3'),
    amount: EtherAmount.fromBase10String(EtherUnit.ether, '1.5'),
);
Transaction tx = txDetails.tx;
Map<String, dynamic>? abi = txDetails.abi;
Map<String, dynamic>? args = txDetails.args;

// Add gas fee
TxGasDetailsData txGasDetails = await ProviderEngine.instance.addGas(
    tx: tx,
    eip1559Enabled: true,
);
tx = txGasDetails.tx;
EtherAmount estimateGas = txGasDetails.estimateGas;
EtherAmount maxFee = txGasDetails.maxFee;
EtherAmount total = txGasDetails.total;
EtherAmount maxAmount = txGasDetails.maxAmount;

// Send transaction
String sendTransaction = await ProviderEngine.instance.sendTransaction(
    credentials: EthPrivateKey.fromHex('0xe394b45f...850bfd03f7'),
    tx: tx,
);
```

### Use `otpKeyGenerator` function to get the otp key of wallet to add it to Google Authenticator App
```dart
String otpKey_ = otpKeyGenerator(
    username: 'username',
    password: 'password',
    securityPassword: 'securityPassword',
);
```

### Use `walletGenerator` function to get wallet details
```dart
// Generate a wallet
WalletGeneratorInfo wallet = await walletGenerator(
    username: 'username',
    password: 'password',
    securityPassword: utf8.encoder.convert('securityPassword'),
    createNew: true,
)!;
// Wallet details
String username = wallet.username;
String address = wallet.address.hexEip55;
String privateKey = fromBytesToHex(wallet.credentials.privateKey);
Uint8List securityPasswordBytes = wallet.securityPassword;
```

### Wallet engine for wallet management
```dart
// Wallet engine
WalletEngine walletEngine = WalletEngine(walletData);

// Login
await walletEngine.login(password);

// Get privateKey (Must be login)
await walletEngine.privateKey(otpCode);
```
