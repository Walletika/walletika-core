import 'package:aesdatabase/aesdatabase.dart';
import 'package:web3dart/web3dart.dart';

import '../core/core.dart';
import '../models.dart';
import 'provider.dart';

Stream<TransactionData> getAllTransactions(
  EthereumAddress walletAddress,
) async* {
  await for (final DBRow row in transactionsDB.select(
    items: {
      DBKeys.address: walletAddress.hexEip55,
      DBKeys.rpc: Provider.networkData.rpc,
    },
  )) {
    yield TransactionData.fromJson(row.items);
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
