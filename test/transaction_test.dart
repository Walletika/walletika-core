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
  printDebug("Is Initialized: $walletikaSDKInitialized");

  final List<Map<String, dynamic>> wallets = walletsDataTest();
  final List<Map<String, dynamic>> transactions =
      transactionsBSCTestnetDataTest();
  final List<Map<String, dynamic>> networks = networksDataTest();
  const int networkIndex = 1;
  const int maximumCount = 3;

  setUpAll(() async {
    bool isConnected = await Provider.connect(
      NetworkData.fromJson(networks[networkIndex]),
    );
    printDebug("${Provider.networkData.name} connection status: $isConnected");
  });

  group("Transactions Storage Group:", () {
    const int walletIndex = 0;
    final EthereumAddress walletAddress = EthereumAddress.fromHex(
      wallets[walletIndex][DBKeys.address],
    );

    test("Test (addNewTransaction)", () async {
      for (Map<String, dynamic> transaction in transactions) {
        String txHash = transaction[DBKeys.txHash];

        TransactionData transactionData = TransactionData.fromJson(transaction);
        await addNewTransaction(
          walletAddress: walletAddress,
          transaction: transactionData,
          autoRemoveOlderCount: maximumCount,
        );

        printDebug("""
txHash: $txHash
        """);
      }

      expect(transactionsDB.countRow(), equals(maximumCount));
    });

    test("Test (getAllTransactions)", () async {
      List<TransactionData> allTransactions = [
        await for (TransactionData item in getAllTransactions(walletAddress))
          item
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

        final Map<String, dynamic> originalTx =
            transactions[transactions.length - maximumCount + index];
        expect(txHash, equals(originalTx[DBKeys.txHash]));
        expect(function, equals(originalTx[DBKeys.function]));
        expect(fromAddress, equals(originalTx[DBKeys.fromAddress]));
        expect(toAddress, equals(originalTx[DBKeys.toAddress]));
        expect(amount, equals(originalTx[DBKeys.amount]));
        expect(symbol, equals(originalTx[DBKeys.symbol]));
        expect(dateCreated, equals(originalTx[DBKeys.dateCreated]));
        expect(status, equals(originalTx[DBKeys.status]));
      }

      expect(allTransactions.length, equals(maximumCount));
    });

    test("Test (removeTransaction)", () async {
      List<TransactionData> allTransactions = [
        await for (TransactionData item in getAllTransactions(
          walletAddress,
        ))
          item
      ];

      for (int index = 0; index < allTransactions.length; index++) {
        TransactionData transactionData = allTransactions[index];
        String txHash = transactionData.txHash;

        bool isRemoved = await removeTransaction(transactionData);
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
