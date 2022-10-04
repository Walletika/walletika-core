import 'dart:typed_data';

import 'package:aesdatabase/aesdatabase.dart';
import 'package:walletika_sdk/src/core/core.dart';
import 'package:walletika_sdk/walletika_sdk.dart';
import 'package:test/test.dart';

import 'core/core.dart';

const debugging = true;
void printDebug(String message) {
  if (debugging) print(message);
}

void main() async {
  await walletikaSDKInitialize();

  final List<Map<String, dynamic>> wallets = walletsDataTest();
  final List<Map<String, dynamic>> tokens = tokensETHRopstenDataTest();
  final List<Map<String, dynamic>> transactions =
      transactionsETHRopstenDataTest();
  final List<Map<String, dynamic>> networks = networksDataTest();
  const int networkIndex = 1;

  Provider.connect(NetworkModel.fromJson(networks[networkIndex]));

  group("Wallet Storage Group:", () {
    test("Test (addNewWallet)", () async {
      for (Map<String, dynamic> wallet in wallets) {
        String address = wallet['address'];
        String username = wallet['username'];
        String password = wallet['password'];
        String recoveryPassword = wallet['recoveryPass'];

        String otpCode = getOTPCode(username, password, recoveryPassword);

        bool isAdded = await addNewWallet(
          username: username,
          password: password,
          recoveryPassword: recoveryPassword,
          otpCode: otpCode,
        );

        printDebug("""
address: $address
username: $username
password: $password
recoveryPassword: $recoveryPassword
otpCode: $otpCode
isAdded: $isAdded
        """);

        expect(isAdded, isTrue);
      }
    });

    test("Test (getAllWallets)", () async {
      List<WalletModel> allWallets = await getAllWallets();

      for (int index = 0; index < allWallets.length; index++) {
        WalletModel walletModel = allWallets[index];
        String address = walletModel.address.hexEip55;
        String username = walletModel.username;
        Uint8List recoveryPassword = walletModel.recoveryPassword;
        DateTime dateCreated = walletModel.dateCreated;
        bool isFavorite = walletModel.isFavorite;

        printDebug("""
address: $address
username: $username
recoveryPassword: $recoveryPassword
dateCreated: ${dateCreated.toString()}
isFavorite: $isFavorite
        """);

        expect(address, equals(wallets[index]['address']));
        expect(username, equals(wallets[index]['username']));
        expect(isFavorite, isFalse);
      }

      expect(allWallets.length, equals(wallets.length));
    });

    test("Test (removeWallet)", () async {
      List<WalletModel> allWallets = await getAllWallets();

      // Keep wallet 0 for testing with walletEngine
      for (int index = 1; index < allWallets.length; index++) {
        WalletModel walletModel = allWallets[index];
        String username = walletModel.username;

        bool isRemoved = await removeWallet(walletModel);
        bool isExists = [
          await for (RowModel row in walletsDB.select(
            items: walletModel.toJson(),
          ))
            row
        ].isNotEmpty;

        printDebug("""
username: $username
isRemoved: $isRemoved
isExists: $isExists
        """);

        expect(isRemoved, isTrue);
        expect(isExists, isFalse);
      }
    });
  });

  group("Wallet Engine Group:", () {
    const int walletIndex = 0;
    final String walletUsername = wallets[walletIndex]['username'];
    final String walletPassword = wallets[walletIndex]['password'];
    final String walletRecoveryPassword = wallets[walletIndex]['recoveryPass'];
    final String otpCode = getOTPCode(
      walletUsername,
      walletPassword,
      walletRecoveryPassword,
    );

    late WalletModel walletModel;
    late WalletEngine walletEngine;

    setUpAll(() async {
      List<WalletModel> allWallets = await getAllWallets();
      walletModel = allWallets[walletIndex];
      walletEngine = WalletEngine(walletModel);
    });

    tearDownAll(() async {
      // Remove current wallet to clean database
      bool isRemoved = await removeWallet(walletModel);
      expect(isRemoved, isTrue);
    });

    test("Test getter methods", () async {
      String address = walletEngine.address().hexEip55;
      String username = walletEngine.username();
      Uint8List recoveryPassword = walletEngine.recoveryPassword();
      DateTime dateCreated = walletEngine.dateCreated();
      bool isFavorite = walletEngine.isFavorite();
      bool isLogged = walletEngine.isLogged();
      List<TokenModel> tokens = await walletEngine.tokens();
      List<TransactionModel> transactions = await walletEngine.transactions();

      printDebug("""
address: $address
username: $username
recoveryPassword: $recoveryPassword
dateCreated: ${dateCreated.toString()}
isFavorite: $isFavorite
isLogged: $isLogged
tokens: $tokens
transactions: $transactions
        """);

      expect(address, equals(walletModel.address.hexEip55));
      expect(username, equals(walletModel.username));
      expect(recoveryPassword, equals(walletModel.recoveryPassword));
      expect(dateCreated, equals(walletModel.dateCreated));
      expect(isFavorite, equals(walletModel.isFavorite));
      expect(isLogged, isFalse);
      expect(tokens, isEmpty);
      expect(transactions, isEmpty);
    });

    test("Test (setFavorite)", () async {
      bool isFavoriteBefore = walletEngine.isFavorite();
      await walletEngine.setFavorite(true);
      bool isFavoriteAfter = walletEngine.isFavorite();

      printDebug("""
isFavoriteBefore: $isFavoriteBefore
isFavoriteAfter: $isFavoriteAfter
        """);

      expect(isFavoriteBefore, isFalse);
      expect(isFavoriteAfter, isTrue);
    });

    test("Test (login) with wrong password", () async {
      bool isLogin = await walletEngine.login(
        password: 'wrongPassword',
        otpCode: otpCode,
      );
      bool isLogged = walletEngine.isLogged();

      printDebug("""
otpCode: $otpCode
isLogin: $isLogin
isLogged: $isLogged
        """);

      expect(isLogin, isFalse);
      expect(isLogged, isFalse);
    });

    test("Test (login) with wrong OTP code", () async {
      String otpCode = '111111';
      bool isLogin = await walletEngine.login(
        password: walletPassword,
        otpCode: otpCode,
      );
      bool isLogged = walletEngine.isLogged();

      printDebug("""
otpCode: $otpCode
isLogin: $isLogin
isLogged: $isLogged
        """);

      expect(isLogin, isFalse);
      expect(isLogged, isFalse);
    });

    test("Test (login) with the correct data", () async {
      bool isLogin = await walletEngine.login(
        password: walletPassword,
        otpCode: otpCode,
      );
      bool isLogged = walletEngine.isLogged();

      printDebug("""
otpCode: $otpCode
isLogin: $isLogin
isLogged: $isLogged
        """);

      expect(isLogin, isTrue);
      expect(isLogged, isTrue);
    });

    test("Test (privateKey) with wrong OTP code", () async {
      String otpCode = '111111';
      String? privateKey = await walletEngine.privateKey(otpCode);

      printDebug("""
otpCode: $otpCode
privateKey: $privateKey
        """);

      expect(privateKey, isNull);
    });

    test("Test (privateKey) with correct OTP code", () async {
      String? privateKey = await walletEngine.privateKey(otpCode);

      printDebug("""
otpCode: $otpCode
privateKey: $privateKey
        """);

      expect(
        privateKey,
        '0xe394b45f8ab120fbf238e356de30c14fdfa6ddf87b2c19253e161a850bfd03f7',
      );
    });

    test("Test (logout)", () async {
      bool isLoggedBefore = walletEngine.isLogged();
      walletEngine.logout();
      bool isLoggedAfter = walletEngine.isLogged();

      printDebug("""
isLoggedBefore: $isLoggedBefore
isLoggedAfter: $isLoggedAfter
        """);

      expect(isLoggedBefore, isTrue);
      expect(isLoggedAfter, isFalse);
    });

    test("Test (privateKey) without login", () async {
      String? privateKey = await walletEngine.privateKey(otpCode);

      printDebug("""
otpCode: $otpCode
privateKey: $privateKey
        """);

      expect(privateKey, isNull);
    });

    test("Test (addToken)", () async {
      for (Map<String, dynamic> token in tokens) {
        String contract = token['contract'];
        String symbol = token['symbol'];
        int decimals = token['decimals'];

        TokenModel tokenModel = TokenModel.fromJson(token);
        await walletEngine.addToken(tokenModel);

        printDebug("""
contract: $contract
symbol: $symbol
decimals: $decimals
        """);
      }

      expect(tokensDB.countRowSync(), tokens.length);
    });

    test("Test (tokens)", () async {
      List<TokenModel> allTokens = await walletEngine.tokens();

      for (int index = 0; index < allTokens.length; index++) {
        TokenModel tokenModel = allTokens[index];
        String contract = tokenModel.contract.hexEip55;
        String symbol = tokenModel.symbol;
        int decimals = tokenModel.decimals;
        String website = tokenModel.website;

        printDebug("""
contract: $contract
symbol: $symbol
decimals: $decimals
website: $website
        """);

        expect(contract, equals(tokens[index]['contract']));
        expect(symbol, equals(tokens[index]['symbol']));
        expect(decimals, equals(tokens[index]['decimals']));
        expect(website, isEmpty);
      }

      expect(allTokens.length, equals(tokens.length));
    });

    test("Test (removeToken)", () async {
      List<TokenModel> allTokens = await walletEngine.tokens();

      for (int index = 0; index < allTokens.length; index++) {
        TokenModel tokenModel = allTokens[index];
        String contract = tokenModel.contract.hexEip55;
        String symbol = tokenModel.symbol;

        bool isRemoved = await walletEngine.removeToken(tokenModel);
        bool isExists = [
          await for (RowModel row in tokensDB.select(
            items: tokenModel.toJson(),
          ))
            row
        ].isNotEmpty;

        printDebug("""
contract: $contract
symbol: $symbol
isRemoved: $isRemoved
isExists: $isExists
        """);

        expect(isRemoved, isTrue);
        expect(isExists, isFalse);
      }
    });

    test("Test (addTransaction)", () async {
      for (Map<String, dynamic> transaction in transactions) {
        String txHash = transaction['txHash'];

        TransactionModel transactionModel =
            TransactionModel.fromJson(transaction);
        await walletEngine.addTransaction(transactionModel);

        printDebug("""
txHash: $txHash
        """);
      }

      expect(transactionsDB.countRowSync(), transactions.length);
    });

    test("Test (transactions)", () async {
      List<TransactionModel> allTransactions =
          await walletEngine.transactions();
      List<Map<String, dynamic>> olderTransactions =
          transactions.reversed.toList();

      for (int index = 0; index < allTransactions.length; index++) {
        TransactionModel transactionModel = allTransactions[index];
        String txHash = transactionModel.txHash;
        String function = transactionModel.function;
        String fromAddress = transactionModel.fromAddress.hexEip55;
        String toAddress = transactionModel.toAddress.hexEip55;
        String amount = transactionModel.amount.getInWei.toString();
        String symbol = transactionModel.symbol;
        String dateCreated = transactionModel.dateCreated.toString();
        int status = transactionModel.status;

        printDebug("""
txHash: $txHash
function: $function
fromAddress: $fromAddress
toAddress: $toAddress
amount: $amount
symbol: $symbol
dateCreated: $dateCreated
status: $status
        """);

        expect(txHash, equals(olderTransactions[index]['txHash']));
        expect(function, equals(olderTransactions[index]['function']));
        expect(fromAddress, equals(olderTransactions[index]['fromAddress']));
        expect(toAddress, equals(olderTransactions[index]['toAddress']));
        expect(amount, equals(olderTransactions[index]['amount']));
        expect(symbol, equals(olderTransactions[index]['symbol']));
        expect(dateCreated, equals(olderTransactions[index]['dateCreated']));
        expect(status, equals(olderTransactions[index]['status']));
      }

      expect(allTransactions.length, equals(transactions.length));
    });

    test("Test (removeTransaction)", () async {
      List<TransactionModel> allTransactions =
          await walletEngine.transactions();

      for (int index = 0; index < allTransactions.length; index++) {
        TransactionModel transactionModel = allTransactions[index];
        String txHash = transactionModel.txHash;

        bool isRemoved = await walletEngine.removeTransaction(transactionModel);
        bool isExists = [
          await for (RowModel row in transactionsDB.select(
            items: transactionModel.toJson(),
          ))
            row
        ].isNotEmpty;

        printDebug("""
txHash: $txHash
isRemoved: $isRemoved
isExists: $isExists
        """);

        expect(isRemoved, isTrue);
        expect(isExists, isFalse);
      }
    });
  });
}
