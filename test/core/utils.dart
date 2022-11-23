import 'package:walletika_creator/walletika_creator.dart';
import 'package:walletika_sdk/src/models.dart';

String getOTPCode(
  String username,
  String password,
  String securityPassword,
) {
  String otpKey = otpKeyGenerator(
    username: username,
    password: password,
    securityPassword: securityPassword,
  );

  return currentOTPCode(otpKey);
}

Future<WalletModel> getWalletModel(
  String username,
  String password,
  String securityPassword,
) async {
  String otpCode = getOTPCode(username, password, securityPassword);

  WalletInfoModel walletInfo = await walletGenerator(
    username: username,
    password: password,
    securityPassword: securityPassword.codeUnits,
    otpCode: otpCode,
  );

  return WalletModel(
    username: username,
    address: walletInfo.address!,
    securityPassword: walletInfo.securityPassword!,
    dateCreated: DateTime.now(),
    isFavorite: false,
  );
}
