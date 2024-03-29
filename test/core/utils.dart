import 'dart:convert';

import 'package:walletika_creator/walletika_creator.dart';
import 'package:walletika_core/src/models.dart';

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

  return getOTPCodePlugin(otpKey);
}

Future<WalletData> getWalletData(
  String username,
  String password,
  String securityPassword,
) async {
  WalletGeneratorInfo? walletInfo = await walletGenerator(
    username: username,
    password: password,
    securityPassword: utf8.encoder.convert(securityPassword),
    createNew: true,
  );

  return WalletData(
    type: WalletType.login,
    username: username,
    address: walletInfo!.address,
    securityPassword: walletInfo.securityPassword,
    dateCreated: DateTime.now(),
    isFavorite: false,
  );
}
