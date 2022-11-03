import 'package:otp/otp.dart';
import 'package:walletika_creator/walletika_creator.dart';
import 'package:walletika_sdk/src/models.dart';

String getOTPCode(
  String username,
  String password,
  String recoveryPassword,
) {
  String otpKey = otpKeyGenerator(
    username: username,
    password: password,
    recoveryPassword: recoveryPassword,
  );

  return OTP.generateTOTPCodeString(
    otpKey,
    DateTime.now().millisecondsSinceEpoch,
  );
}

Future<WalletModel> getWalletModel(
  String username,
  String password,
  String recoveryPassword,
) async {
  String otpCode = getOTPCode(username, password, recoveryPassword);

  WalletInfoModel walletInfo = await walletGenerator(
    username: username,
    password: password,
    recoveryPassword: recoveryPassword.codeUnits,
    otpCode: otpCode,
  );

  return WalletModel(
    username: username,
    address: walletInfo.address!,
    recoveryPassword: walletInfo.recoveryPassword!,
    dateCreated: DateTime.now(),
    isFavorite: false,
  );
}
