import 'package:walletika_core/walletika_core.dart';

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

  // initialize walletika Core
  await walletikaCoreInitialize();

  // Add new wallet
  await addNewWallet(
    type: WalletType.login,
    username: username,
    password: password,
    securityPassword: securityPassword,
  );

  // Get all wallets
  List<WalletData> allWallets = await getAllWallets();

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
