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
  final List<Map<String, dynamic>> tokens = tokensBSCTestnetDataTest();
  final List<Map<String, dynamic>> transactions =
      transactionsBSCTestnetDataTest();
  final List<Map<String, dynamic>> networks = networksDataTest();
  const int networkIndex = 1;

  setUpAll(() async {
    bool isConnected = await Provider.connect(
      NetworkData.fromJson(networks[networkIndex]),
    );
    printDebug("${Provider.networkData.name} connection status: $isConnected");
  });

  group("Wallet Storage Group:", () {
    test("Test (addNewWallet)", () async {
      for (Map<String, dynamic> wallet in wallets) {
        String address = wallet[DBKeys.address];
        String username = wallet[DBKeys.username];
        String password = wallet[DBKeys.password];
        String securityPassword = wallet[DBKeys.securityPassword];

        String otpCode = getOTPCode(username, password, securityPassword);

        bool isAdded = await addNewWallet(
          username: username,
          password: password,
          securityPassword: securityPassword,
        );

        printDebug("""
address: $address
username: $username
password: $password
securityPassword: $securityPassword
otpCode: $otpCode
isAdded: $isAdded
        """);

        expect(isAdded, isTrue);
      }
    });

    test("Test (getAllWallets)", () async {
      List<WalletData> allWallets = [
        await for (WalletData item in getAllWallets()) item
      ];

      for (int index = 0; index < allWallets.length; index++) {
        WalletData walletData = allWallets[index];
        String address = walletData.address.hexEip55;
        String username = walletData.username;
        Uint8List securityPassword = walletData.securityPassword;
        DateTime dateCreated = walletData.dateCreated;
        bool isFavorite = walletData.isFavorite;

        printDebug("""
address: $address
username: $username
securityPassword: $securityPassword
dateCreated: ${dateCreated.toString()}
isFavorite: $isFavorite
        """);

        expect(address, equals(wallets[index][DBKeys.address]));
        expect(username, equals(wallets[index][DBKeys.username]));
        expect(isFavorite, isFalse);
      }

      expect(allWallets.length, equals(wallets.length));
    });

    test("Test (removeWallet)", () async {
      List<WalletData> allWallets = [
        await for (WalletData item in getAllWallets()) item
      ];

      // Keep wallet 0 for testing with walletEngine
      for (int index = 1; index < allWallets.length; index++) {
        WalletData walletData = allWallets[index];
        String username = walletData.username;

        bool isRemoved = await removeWallet(walletData);
        bool isExists = [
          await for (DBRow row in walletsDB.select(
            items: walletData.toJson(),
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
    final String walletUsername = wallets[walletIndex][DBKeys.username];
    final String walletPassword = wallets[walletIndex][DBKeys.password];
    final String walletSecurityPassword =
        wallets[walletIndex][DBKeys.securityPassword];
    final String otpCode = getOTPCode(
      walletUsername,
      walletPassword,
      walletSecurityPassword,
    );

    late WalletData walletData;
    late WalletEngine walletEngine;

    setUpAll(() async {
      List<WalletData> allWallets = [
        await for (WalletData item in getAllWallets()) item
      ];
      walletData = allWallets[walletIndex];
      walletEngine = WalletEngine(walletData);
    });

    tearDownAll(() async {
      // Remove current wallet to clean database
      bool isRemoved = await removeWallet(walletData);
      expect(isRemoved, isTrue);
    });

    test("Test getter methods", () async {
      String address = walletEngine.address().hexEip55;
      String username = walletEngine.username();
      Uint8List securityPassword = walletEngine.securityPassword();
      DateTime dateCreated = walletEngine.dateCreated();
      bool isFavorite = walletEngine.isFavorite();
      bool isLogged = walletEngine.isLogged();
      List<TokenData> tokens = [
        await for (TokenData item in walletEngine.tokens()) item
      ];
      List<TransactionData> transactions = [
        await for (TransactionData item in walletEngine.transactions()) item
      ];

      printDebug("""
address: $address
username: $username
securityPassword: $securityPassword
dateCreated: ${dateCreated.toString()}
isFavorite: $isFavorite
isLogged: $isLogged
tokens: $tokens
transactions: $transactions
        """);

      expect(address, equals(walletData.address.hexEip55));
      expect(username, equals(walletData.username));
      expect(securityPassword, equals(walletData.securityPassword));
      expect(dateCreated, equals(walletData.dateCreated));
      expect(isFavorite, equals(walletData.isFavorite));
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
        String contract = token[DBKeys.contract];
        String name = token[DBKeys.name];
        String symbol = token[DBKeys.symbol];
        int decimals = token[DBKeys.decimals];

        TokenData tokenData = TokenData.fromJson(token);
        await walletEngine.addToken(tokenData);

        printDebug("""
contract: $contract
name: $name
symbol: $symbol
decimals: $decimals
        """);
      }

      expect(tokensDB.countRow(), tokens.length);
    });

    test("Test (tokens)", () async {
      List<TokenData> allTokens = [
        await for (TokenData item in walletEngine.tokens()) item
      ];

      for (int index = 0; index < allTokens.length; index++) {
        TokenData tokenData = allTokens[index];
        String contract = tokenData.contract.hexEip55;
        String name = tokenData.name;
        String symbol = tokenData.symbol;
        int decimals = tokenData.decimals;
        String website = tokenData.website;

        printDebug("""
contract: $contract
name: $name
symbol: $symbol
decimals: $decimals
website: $website
        """);

        expect(contract, equals(tokens[index][DBKeys.contract]));
        expect(symbol, equals(tokens[index][DBKeys.symbol]));
        expect(decimals, equals(tokens[index][DBKeys.decimals]));
        expect(website, isEmpty);
      }

      expect(allTokens.length, equals(tokens.length));
    });

    test("Test (removeToken)", () async {
      List<TokenData> allTokens = [
        await for (TokenData item in walletEngine.tokens()) item
      ];

      for (int index = 0; index < allTokens.length; index++) {
        TokenData tokenData = allTokens[index];
        String contract = tokenData.contract.hexEip55;
        String symbol = tokenData.symbol;

        bool isRemoved = await walletEngine.removeToken(tokenData);
        bool isExists = [
          await for (DBRow row in tokensDB.select(
            items: tokenData.toJson(),
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
        String txHash = transaction[DBKeys.txHash];

        TransactionData transactionData = TransactionData.fromJson(transaction);
        await walletEngine.addTransaction(transactionData);

        printDebug("""
txHash: $txHash
        """);
      }

      expect(transactionsDB.countRow(), transactions.length);
    });

    test("Test (transactions)", () async {
      List<TransactionData> allTransactions = [
        await for (TransactionData item in walletEngine.transactions()) item
      ];

      for (int index = 0; index < allTransactions.length; index++) {
        TransactionData transactionData = allTransactions[index];
        String txHash = transactionData.txHash;
        String function = transactionData.function;
        String fromAddress = transactionData.fromAddress.hexEip55;
        String toAddress = transactionData.toAddress.hexEip55;
        String amount = transactionData.amount.getInWei.toString();
        String symbol = transactionData.symbol;
        String dateCreated = transactionData.dateCreated.toString();
        int status = transactionData.status;

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

        expect(txHash, equals(transactions[index][DBKeys.txHash]));
        expect(function, equals(transactions[index][DBKeys.function]));
        expect(
          fromAddress,
          equals(transactions[index][DBKeys.fromAddress]),
        );
        expect(toAddress, equals(transactions[index][DBKeys.toAddress]));
        expect(amount, equals(transactions[index][DBKeys.amount]));
        expect(symbol, equals(transactions[index][DBKeys.symbol]));
        expect(
          dateCreated,
          equals(transactions[index][DBKeys.dateCreated]),
        );
        expect(status, equals(transactions[index][DBKeys.status]));
      }

      expect(allTransactions.length, equals(transactions.length));
    });

    test("Test (removeTransaction)", () async {
      List<TransactionData> allTransactions = [
        await for (TransactionData item in walletEngine.transactions()) item
      ];

      for (int index = 0; index < allTransactions.length; index++) {
        TransactionData transactionData = allTransactions[index];
        String txHash = transactionData.txHash;

        bool isRemoved = await walletEngine.removeTransaction(transactionData);
        bool isExists = [
          await for (DBRow row in transactionsDB.select(
            items: transactionData.toJson(),
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
