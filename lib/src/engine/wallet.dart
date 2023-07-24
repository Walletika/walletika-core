import 'dart:convert';
import 'dart:typed_data';

import 'package:aescrypto/aescrypto.dart';
import 'package:aesdatabase/aesdatabase.dart';
import 'package:walletika_creator/walletika_creator.dart';
import 'package:web3dart/credentials.dart';

import '../core/core.dart';
import '../models.dart';
import '../utils/utils.dart';

final SecretStringStorage _secretStorage = SecretStringStorage();

/// Get all wallets from database
Stream<WalletData> getAllWallets() async* {
  await for (final DBRow row in walletsDB.select()) {
    yield WalletData.fromJson(row.items);
  }
}

/// Add a new wallet to database
Future<bool> addNewWallet({
  required String username,
  required String password,
  required String securityPassword,
}) async {
  bool isValid = false;

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
    isValid = true;
  }

  return isValid;
}

/// Remove a wallet from database
Future<bool> removeWallet(WalletData wallet) async {
  bool isValid = false;

  await for (final DBRow row in walletsDB.select(
    items: wallet.toJson(),
  )) {
    _secretStorage.remove(wallet.address.hex);
    walletsDB.removeRow(row.index);
    await walletsDB.dump();
    isValid = true;
    break;
  }

  return isValid;
}

/// Export all wallets to external file
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

/// Import all wallets from external file
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

    // Remove duplicate wallets
    final List<String> addresses = [];
    for (final DBRow row in await walletsDB.select().toList()) {
      final String address = row.items[DBKeys.address];

      if (addresses.contains(address)) {
        walletsDB.removeRow(row.index);
        continue;
      }

      addresses.add(address);
    }

    await walletsDB.dump();

    isValid = true;
  } on InvalidKeyError {
    // Nothing to do
  }

  return isValid;
}

/// Wallet engine to access the crypto wallet
class WalletEngine {
  final WalletData wallet;

  bool _isLogged = false;

  WalletEngine(this.wallet);

  /// Get wallet username
  String username() => wallet.username;

  /// Get wallet address
  EthereumAddress address() => wallet.address;

  /// Get wallet security password in encrypted
  Uint8List securityPassword() => wallet.securityPassword;

  /// Get wallet date created
  DateTime dateCreated() => wallet.dateCreated;

  /// Get wallet favorite status
  bool isFavorite() => wallet.isFavorite;

  /// Get wallet logging status
  bool isLogged() => _isLogged;

  /// Get wallet credentials, must be logged in
  Future<EthPrivateKey?> credentials(String otpCode) async {
    EthPrivateKey? result;

    if (_isLogged) {
      final WalletGeneratorInfo? walletInfo = await walletGenerator(
        username: wallet.username,
        password: _secretStorage.read(wallet.address.hex)!,
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

  /// Get wallet private key, must be logged in
  Future<String?> privateKey(String otpCode) async {
    final EthPrivateKey? credential = await credentials(otpCode);
    return credential != null ? fromBytesToHex(credential.privateKey) : null;
  }

  /// Mark the wallet as favorite
  Future<bool> setFavorite(bool status) async {
    bool isValid = false;

    await for (final DBRow row in walletsDB.select(
      items: wallet.toJson(),
    )) {
      wallet.isFavorite = status;
      walletsDB.edit(rowIndex: row.index, items: {DBKeys.isFavorite: status});
      await walletsDB.dump();
      isValid = true;
      break;
    }

    return isValid;
  }

  /// Login to the wallet
  Future<bool> login(String password) async {
    if (!_isLogged) {
      if (await passwordTestPlugin(
        address: wallet.address.hexEip55,
        username: wallet.username,
        password: password,
        securityPassword: wallet.securityPassword,
      )) {
        _secretStorage.write(key: wallet.address.hex, value: password);
        _isLogged = true;
      }
    }

    return _isLogged;
  }

  /// Log out from the wallet
  void logout() {
    _secretStorage.remove(wallet.address.hex);
    _isLogged = false;
  }
}
