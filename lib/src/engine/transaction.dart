import 'dart:io';

import 'package:aesdatabase/aesdatabase.dart';
import 'package:web3dart/web3dart.dart';

import '../core/core.dart';
import '../models.dart';
import 'provider.dart';

Stream<TransactionData> getAllTransactions(
  EthereumAddress walletAddress,
) async* {
  bool saveRequired = false;

  await for (final DBRow row in transactionsDB.select(
    items: {
      DBKeys.address: walletAddress.hexEip55,
      DBKeys.rpc: Provider.networkData.rpc,
    },
  )) {
    if (row.items[DBKeys.status] == TransactionData.pendingStatus) {
      try {
        await Provider.getTransactionReceipt(row.items[DBKeys.txHash])
            .then((tx) {
          if (tx == null) return;

          final Map<String, int> status = {
            DBKeys.status: tx.status!
                ? TransactionData.successStatus
                : TransactionData.failedStatus
          };

          transactionsDB.edit(rowIndex: row.index, items: status);
          row.items.addAll(status);
          saveRequired = true;
        });
      } on SocketException {
        // Nothing to do
      }
    }

    yield TransactionData.fromJson(row.items);
  }

  if (saveRequired) {
    await transactionsDB.dump();
  }
}

Future<void> addNewTransaction({
  required EthereumAddress walletAddress,
  required TransactionData transaction,
  int? autoRemoveOlderCount,
}) async {
  if (autoRemoveOlderCount != null) {
    final List<DBRow> transactions = await transactionsDB.select(
      items: {
        DBKeys.address: walletAddress.hexEip55,
        DBKeys.rpc: Provider.networkData.rpc,
      },
    ).toList();

    while (transactions.length >= autoRemoveOlderCount) {
      await for (final DBRow row in transactionsDB.select(
        items: transactions.removeAt(0).items,
      )) {
        transactionsDB.removeRow(row.index);
        break;
      }
    }
  }

  transactionsDB.addRow({
    DBKeys.address: walletAddress.hexEip55,
    DBKeys.rpc: Provider.networkData.rpc,
    ...transaction.toJson(),
  });

  await transactionsDB.dump();
}

Future<bool> removeTransaction(TransactionData transaction) async {
  bool result = false;

  await for (final DBRow row in transactionsDB.select(
    items: {
      DBKeys.address: transaction.fromAddress.hexEip55,
      DBKeys.rpc: Provider.networkData.rpc,
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
