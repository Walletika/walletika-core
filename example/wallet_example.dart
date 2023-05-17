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

  String otpCode = getOTPCodePlugin(otpKey);

  // initialize walletika SDK
  await walletikaSDKInitialize();

  // Add new wallet
  await addNewWallet(
    username: username,
    password: password,
    securityPassword: securityPassword,
  );

  // Get all wallets
  List<WalletData> allWallets = [
    await for (WalletData wallet in getAllWallets()) wallet
  ];

  // Remove a wallet
  await removeWallet(allWallets[0]);

  // Wallet engine
  WalletEngine walletEngine = WalletEngine(allWallets[0]);

  // Login
  await walletEngine.login(password);

  // Get privateKey (Must be login)
  await walletEngine.privateKey(otpCode);

  // Logout
  walletEngine.logout();
}
