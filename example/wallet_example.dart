import 'package:walletika_creator/walletika_creator.dart';
import 'package:walletika_sdk/walletika_sdk.dart';

void main() async {
  String username = 'username';
  String password = 'password';
  String securityPassword = 'securityPassword';

  String otpKey = otpKeyGenerator(
    username: username,
    password: password,
    securityPassword: securityPassword,
  );

  String otpCode = currentOTPCode(otpKey);

  // initialize walletika SDK
  await walletikaSDKInitialize();

  // Add new wallet
  bool isAdded = await addNewWallet(
    username: username,
    password: password,
    securityPassword: securityPassword,
  );

  // Get all wallets
  List<WalletData> allWallets = [
    await for (WalletData wallet in getAllWallets()) wallet
  ];

  // Remove a wallet
  bool isRemoved = await removeWallet(allWallets[0]);

  // Wallet engine
  WalletEngine walletEngine = WalletEngine(allWallets[0]);

  // Login
  await walletEngine.login(password: password, otpCode: otpCode);

  // Get privateKey (Must be login)
  await walletEngine.privateKey(otpCode);

  // Logout
  walletEngine.logout();

  // Get all tokens
  List<TokenData> allTokens = [
    await for (TokenData item in walletEngine.tokens()) item
  ];

  // Add token
  await walletEngine.addToken(allTokens[0]);

  // Remove token
  await walletEngine.removeToken(allTokens[0]);

  // Get all transactions
  List<TransactionData> allTransactions = [
    await for (TransactionData item in walletEngine.transactions()) item
  ];

  // Add transaction
  await walletEngine.addTransaction(allTransactions[0]);

  // Remove transaction
  await walletEngine.removeTransaction(allTransactions[0]);
}
