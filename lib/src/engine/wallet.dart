import 'dart:convert';
import 'dart:typed_data';

import 'package:aesdatabase/aesdatabase.dart';
import 'package:walletika_creator/walletika_creator.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';

import '../core/core.dart';
import '../models.dart';
import 'provider.dart';

Stream<WalletModel> getAllWallets() async* {
  await for (final DBRow row in walletsDB.select()) {
    yield WalletModel.fromJson(row.items);
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

Future<bool> removeWallet(WalletModel wallet) async {
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

Future<String> exportpWallets({
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

Future<void> importWallets({
  required String path,
  List<int>? walletIndexes,
  String? password,
  void Function(int value)? progressCallback,
}) async {
  await walletsDB.importBackup(
    path: path,
    rowIndexes: walletIndexes,
    key: password,
    progressCallback: progressCallback,
  );

  await walletsDB.dump();
}

class WalletEngine {
  final WalletModel wallet;

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

  Future<bool> login({
    required String password,
    required String otpCode,
  }) async {
    if (!_isLogged) {
      final WalletGeneratorInfo? walletInfo = await walletGenerator(
        username: wallet.username,
        password: password,
        securityPassword: wallet.securityPassword,
        otpCode: otpCode,
        createNew: false,
      );

      if (walletInfo != null) {
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

  Stream<TokenModel> tokens() async* {
    await for (final DBRow row in tokensDB.select(
      items: {
        DBKeys.address: wallet.address.hexEip55,
        DBKeys.rpc: Provider.networkModel.rpc,
      },
    )) {
      yield TokenModel.fromJson(row.items);
    }
  }

  Future<void> addToken(TokenModel token) async {
    tokensDB.addRow({
      DBKeys.address: wallet.address.hexEip55,
      DBKeys.rpc: Provider.networkModel.rpc,
      ...token.toJson(),
    });

    await tokensDB.dump();
  }

  Future<bool> removeToken(TokenModel token) async {
    bool result = false;

    await for (final DBRow row in tokensDB.select(
      items: {
        DBKeys.address: wallet.address.hexEip55,
        DBKeys.rpc: Provider.networkModel.rpc,
        ...token.toJson(),
      },
    )) {
      tokensDB.removeRow(row.index);
      await tokensDB.dump();
      result = true;
      break;
    }

    return result;
  }

  Stream<TransactionModel> transactions() async* {
    await for (final DBRow row in transactionsDB.select(
      items: {
        DBKeys.address: wallet.address.hexEip55,
        DBKeys.rpc: Provider.networkModel.rpc,
      },
    )) {
      yield TransactionModel.fromJson(row.items);
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    transactionsDB.addRow({
      DBKeys.address: wallet.address.hexEip55,
      DBKeys.rpc: Provider.networkModel.rpc,
      ...transaction.toJson(),
    });

    await transactionsDB.dump();
  }

  Future<bool> removeTransaction(TransactionModel transaction) async {
    bool result = false;

    await for (final DBRow row in transactionsDB.select(
      items: {
        DBKeys.address: wallet.address.hexEip55,
        DBKeys.rpc: Provider.networkModel.rpc,
        ...transaction.toJson(),
      },
    )) {
      transactionsDB.removeRow(row.index);
      await transactionsDB.dump();
      result = true;
      break;
    }

    return result;
  }
}
