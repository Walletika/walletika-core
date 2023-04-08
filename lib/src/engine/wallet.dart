import 'dart:convert';
import 'dart:typed_data';

import 'package:aescrypto/aescrypto.dart';
import 'package:aesdatabase/aesdatabase.dart';
import 'package:walletika_creator/walletika_creator.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';

import '../core/core.dart';
import '../models.dart';

Stream<WalletData> getAllWallets() async* {
  await for (final DBRow row in walletsDB.select()) {
    yield WalletData.fromJson(row.items);
  }
}

Future<bool> addNewWallet({
  required String username,
  required String password,
  required String securityPassword,
}) async {
  final WalletGeneratorInfo? wallet = await walletGenerator(
    username: username,
    password: password,
    securityPassword: utf8.encoder.convert(securityPassword),
    createNew: true,
  );

  if (wallet != null) {
    walletsDB.addRow({
      DBKeys.username: wallet.username,
      DBKeys.address: wallet.address.hexEip55,
      DBKeys.securityPassword: jsonEncode(wallet.securityPassword),
      DBKeys.dateCreated: DateTime.now().toString(),
      DBKeys.isFavorite: false,
    });

    await walletsDB.dump();
    return true;
  }

  return false;
}

Future<bool> removeWallet(WalletData wallet) async {
  bool result = false;

  await for (final DBRow row in walletsDB.select(
    items: wallet.toJson(),
  )) {
    walletsDB.removeRow(row.index);
    await walletsDB.dump();
    result = true;
    break;
  }

  return result;
}

Future<String> exportWallets({
  String? outputDir,
  List<int>? walletIndexes,
  String? password,
  void Function(int value)? progressCallback,
}) async {
  return walletsDB.exportBackup(
    outputDir: outputDir,
    rowIndexes: walletIndexes,
    key: password,
    progressCallback: progressCallback,
  );
}

Future<bool> importWallets({
  required String path,
  List<int>? walletIndexes,
  String? password,
  void Function(int value)? progressCallback,
}) async {
  bool isValid = false;

  try {
    await walletsDB.importBackup(
      path: path,
      rowIndexes: walletIndexes,
      key: password,
      progressCallback: progressCallback,
    );

    await walletsDB.dump();

    isValid = true;
  } on InvalidKeyError {
    // Nothing to do
  }

  return isValid;
}

class WalletEngine {
  final WalletData wallet;

  String? _password;
  bool _isLogged = false;

  WalletEngine(this.wallet);

  String username() => wallet.username;

  EthereumAddress address() => wallet.address;

  Uint8List securityPassword() => wallet.securityPassword;

  DateTime dateCreated() => wallet.dateCreated;

  bool isFavorite() => wallet.isFavorite;

  bool isLogged() => _isLogged;

  Future<EthPrivateKey?> credentials(String otpCode) async {
    EthPrivateKey? result;

    if (_isLogged) {
      final WalletGeneratorInfo? walletInfo = await walletGenerator(
        username: wallet.username,
        password: _password!,
        securityPassword: wallet.securityPassword,
        otpCode: otpCode,
        createNew: false,
      );

      if (walletInfo != null) {
        result = walletInfo.credentials;
      }
    }

    return result;
  }

  Future<String?> privateKey(String otpCode) async {
    final EthPrivateKey? credential = await credentials(otpCode);

    return credential != null
        ? bytesToHex(
            credential.privateKey,
            include0x: true,
          )
        : null;
  }

  Future<void> setFavorite(bool status) async {
    await for (final DBRow row in walletsDB.select(
      items: wallet.toJson(),
    )) {
      wallet.isFavorite = status;
      walletsDB.edit(rowIndex: row.index, items: {DBKeys.isFavorite: status});
      await walletsDB.dump();
      break;
    }
  }

  Future<bool> login(String password) async {
    if (!_isLogged) {
      if (await passwordTestPlugin(
        address: wallet.address.hexEip55,
        username: wallet.username,
        password: password,
        securityPassword: wallet.securityPassword,
      )) {
        _password = password;
        _isLogged = true;
      }
    }

    return _isLogged;
  }

  void logout() {
    _password = null;
    _isLogged = false;
  }
}
