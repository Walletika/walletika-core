import 'package:otp/otp.dart';
import 'package:walletika_creator/walletika_creator.dart';
import 'package:walletika_sdk/walletika_sdk.dart';

void main() async {
  String username = 'username';
  String password = 'password';
  String recoveryPassword = 'recoveryPassword';

  String otpKey = otpKeyGenerator(
    username: username,
    password: password,
    recoveryPassword: recoveryPassword,
  );

  String otpCode = OTP.generateTOTPCodeString(
    otpKey,
    DateTime.now().millisecondsSinceEpoch,
  );

  // initialize walletika SDK
  await walletikaSDKInitialize();

  // Add new wallet
  bool isAdded = await addNewWallet(
    username: username,
    password: password,
    recoveryPassword: recoveryPassword,
    otpCode: otpCode,
  );

  // Get all wallets
  List<WalletModel> allWallets = await getAllWallets();

  // Remove a wallet
  bool isRemoved = await removeWallet(allWallets[0]);

  // Wallet engine
  WalletEngine walletEngine = WalletEngine(allWallets[0]);

  // Login
  walletEngine.login(password: password, otpCode: otpCode);

  // Get privateKey (Must be login)
  walletEngine.privateKey(otpCode);

  // Logout
  walletEngine.logout();

  // Get all tokens
  List<TokenModel> allTokens = await walletEngine.tokens();

  // Add token
  await walletEngine.addToken(allTokens[0]);

  // Remove token
  await walletEngine.removeToken(allTokens[0]);

  // Get all transactions
  List<TransactionModel> allTransactions = await walletEngine.transactions();

  // Add transaction
  await walletEngine.addTransaction(allTransactions[0]);

  // Remove transaction
  await walletEngine.removeTransaction(allTransactions[0]);
}
