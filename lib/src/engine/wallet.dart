import 'dart:convert';
import 'dart:typed_data';

import 'package:aesdatabase/aesdatabase.dart';
import 'package:walletika_creator/walletika_creator.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';

import '../core/core.dart';
import '../models.dart';
import 'provider.dart';

Future<List<WalletModel>> getAllWallets() async {
  List<WalletModel> result = [];

  await for (RowModel row in walletsDB.select()) {
    WalletModel wallet = WalletModel.fromJson(row.items);
    int index = wallet.isFavorite ? 0 : result.length;
    result.insert(index, wallet);
  }

  return result;
}

Future<bool> addNewWallet({
  required String username,
  required String password,
  required String recoveryPassword,
  required String otpCode,
}) {
  return Future(() {
    WalletInfoModel wallet = walletGenerator(
      username: username,
      password: password,
      recoveryPassword: recoveryPassword.codeUnits,
      otpCode: otpCode,
    );

    if (wallet.isValid) {
      walletsDB.insertSync(
        rowIndex: walletsDB.countRowSync(),
        items: {
          "username": username,
          "address": wallet.address!.hexEip55,
          "recoveryPassword": jsonEncode(wallet.recoveryPassword!),
          "dateCreated": DateTime.now().toString(),
          "isFavorite": false,
        },
      );

      walletsDB.dumpSync();
    }

    return wallet.isValid;
  });
}

Future<bool> removeWallet(WalletModel wallet) async {
  bool result = false;

  await for (RowModel row in walletsDB.select(items: wallet.toJson())) {
    walletsDB.removeRowSync(row.index);
    walletsDB.dumpSync();
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
}) {
  return Future(() {
    return walletsDB.exportBackupSync(
      outputDir: outputDir,
      rowIndexes: walletIndexes,
      key: password,
      progressCallback: progressCallback,
    );
  });
}

Future<void> importWallets({
  required String path,
  List<int>? walletIndexes,
  String? password,
  void Function(int value)? progressCallback,
}) {
  return Future(() {
    walletsDB.importBackupSync(
      path: path,
      rowIndexes: walletIndexes,
      key: password,
      progressCallback: progressCallback,
    );
    walletsDB.dumpSync();
  });
}

class WalletEngine {
  final WalletModel wallet;

  String? _password;
  bool _isLogged = false;

  WalletEngine(this.wallet);

  String username() => wallet.username;

  EthereumAddress address() => wallet.address;

  Uint8List recoveryPassword() => wallet.recoveryPassword;

  DateTime dateCreated() => wallet.dateCreated;

  bool isFavorite() => wallet.isFavorite;

  bool isLogged() => _isLogged;

  Future<EthPrivateKey?> credentials(String otpCode) {
    return Future(() {
      EthPrivateKey? result;

      if (_isLogged) {
        WalletInfoModel walletInfo = walletGenerator(
          username: wallet.username,
          password: _password!,
          recoveryPassword: wallet.recoveryPassword,
          otpCode: otpCode,
        );

        if (walletInfo.isValid) {
          result = walletInfo.credentials;
        }
      }

      return result;
    });
  }

  Future<String?> privateKey(String otpCode) {
    return Future(() async {
      EthPrivateKey? credential = await credentials(otpCode);

      return credential != null
          ? bytesToHex(
              credential.privateKey,
              include0x: true,
            )
          : null;
    });
  }

  Future<void> setFavorite(bool status) {
    return Future(() async {
      await for (RowModel row in walletsDB.select(items: wallet.toJson())) {
        wallet.isFavorite = status;
        walletsDB.editSync(rowIndex: row.index, items: {'isFavorite': status});
        walletsDB.dumpSync();
        break;
      }
    });
  }

  Future<bool> login({
    required String password,
    required String otpCode,
  }) {
    return Future(() async {
      if (!_isLogged) {
        WalletInfoModel walletInfo = walletGenerator(
          username: wallet.username,
          password: password,
          recoveryPassword: wallet.recoveryPassword,
          otpCode: otpCode,
        );

        if (walletInfo.isValid) {
          _password = password;
          _isLogged = true;
        }
      }

      return _isLogged;
    });
  }

  void logout() {
    _password = null;
    _isLogged = false;
  }

  Future<List<TokenModel>> tokens() {
    return Future(() async {
      List<TokenModel> result = [];

      await for (RowModel row in tokensDB.select(
        items: {
          "address": wallet.address.hexEip55,
          "rpc": Provider.networkModel.rpc,
        },
      )) {
        TokenModel token = TokenModel.fromJson(row.items);
        result.add(token);
      }

      return result;
    });
  }

  Future<void> addToken(TokenModel token) {
    return Future(() {
      tokensDB.insertSync(
        rowIndex: tokensDB.countRowSync(),
        items: {
          "address": wallet.address.hexEip55,
          "rpc": Provider.networkModel.rpc,
          ...token.toJson(),
        },
      );

      tokensDB.dumpSync();
    });
  }

  Future<bool> removeToken(TokenModel token) async {
    bool result = false;

    await for (RowModel row in tokensDB.select(
      items: {
        "address": wallet.address.hexEip55,
        "rpc": Provider.networkModel.rpc,
        ...token.toJson(),
      },
    )) {
      tokensDB.removeRowSync(row.index);
      tokensDB.dumpSync();
      result = true;
      break;
    }

    return result;
  }

  Future<List<TransactionModel>> transactions() {
    return Future(() async {
      List<TransactionModel> result = [];

      await for (RowModel row in transactionsDB.select(
        items: {
          "address": wallet.address.hexEip55,
          "rpc": Provider.networkModel.rpc,
        },
      )) {
        TransactionModel transaction = TransactionModel.fromJson(row.items);
        result.add(transaction);
      }

      return result;
    });
  }

  Future<void> addTransaction(TransactionModel transaction) {
    return Future(() {
      transactionsDB.insertSync(
        items: {
          "address": wallet.address.hexEip55,
          "rpc": Provider.networkModel.rpc,
          ...transaction.toJson(),
        },
      );

      transactionsDB.dumpSync();
    });
  }

  Future<bool> removeTransaction(TransactionModel transaction) async {
    bool result = false;

    await for (RowModel row in transactionsDB.select(
      items: {
        "address": wallet.address.hexEip55,
        "rpc": Provider.networkModel.rpc,
        ...transaction.toJson(),
      },
    )) {
      transactionsDB.removeRowSync(row.index);
      transactionsDB.dumpSync();
      result = true;
      break;
    }

    return result;
  }
}
