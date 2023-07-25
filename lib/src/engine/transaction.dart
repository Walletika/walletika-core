import 'dart:io';

import 'package:aesdatabase/aesdatabase.dart';
import 'package:web3dart/web3dart.dart';

import '../core/core.dart';
import '../models.dart';
import 'provider.dart';

/// Get all transactions from database
Future<List<TransactionData>> getAllTransactions(
  EthereumAddress walletAddress,
) async {
  final List<TransactionData> result = [];

  await for (final DBRow row in transactionsDB.select(items: {
    DBKeys.address: walletAddress.hexEip55,
    DBKeys.rpc: ProviderEngine.instance.networkData.rpc,
  })) {
    if (row.items[DBKeys.status] == TransactionData.pendingStatus) {
      try {
        final TransactionReceipt? tx = await ProviderEngine.instance
            .getTransactionReceipt(row.items[DBKeys.txHash]);

        if (tx != null) {
          final Map<String, int> status = {
            DBKeys.status: tx.status == true
                ? TransactionData.successStatus
                : TransactionData.failedStatus
          };
          transactionsDB.edit(rowIndex: row.index, items: status);
          row.items.addAll(status);
          await transactionsDB.dump();
        }
      } on SocketException {
        // Nothing to do
      }
    }

    result.add(TransactionData.fromJson(row.items));
  }

  return result;
}

/// Add a new transaction to database
Future<void> addNewTransaction({
  required EthereumAddress walletAddress,
  required TransactionData transaction,
  int? autoRemoveOlderCount,
}) async {
  if (autoRemoveOlderCount != null) {
    final List<DBRow> transactions = await transactionsDB.select(
      items: {
        DBKeys.address: walletAddress.hexEip55,
        DBKeys.rpc: ProviderEngine.instance.networkData.rpc,
      },
    ).toList();

    while (transactions.length >= autoRemoveOlderCount) {
      transactionsDB.removeRow(
        await transactionsDB
            .select(items: transactions.removeAt(0).items)
            .first
            .then<int>((row) => row.index),
      );
    }
  }

  transactionsDB.addRow({
    DBKeys.address: walletAddress.hexEip55,
    DBKeys.rpc: ProviderEngine.instance.networkData.rpc,
    ...transaction.toJson(),
  });

  await transactionsDB.dump();
}

/// Remove a transaction from database
Future<bool> removeTransaction(TransactionData transaction) async {
  bool isValid = false;

  await for (final DBRow row in transactionsDB.select(
    items: {
      DBKeys.address: transaction.fromAddress.hexEip55,
      DBKeys.rpc: ProviderEngine.instance.networkData.rpc,
      ...transaction.toJson(),
    },
  )) {
    transactionsDB.removeRow(row.index);
    await transactionsDB.dump();
    isValid = true;
    break;
  }

  return isValid;
}
