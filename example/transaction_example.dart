import 'package:walletika_core/src/core/core.dart';
import 'package:walletika_core/walletika_core.dart';

void main() async {
  TransactionData transaction = TransactionData.fromJson({
    DBKeys.txHash:
        '0x0999608c57697ff7a6051bbbc76f8fe7d2c552d1df7e0f0553d91798f722ec3f',
    DBKeys.function: 'transfer',
    DBKeys.fromAddress: '0x5c8CE2AaDA53a7c909e5e1ddf26Da19c32083E6D',
    DBKeys.toAddress: '0xD99D1c33F9fC3444f8101754aBC46c52416550D1',
    DBKeys.amount: '0',
    DBKeys.symbol: 'BNB',
    DBKeys.dateCreated: '2022-10-04 14:10:16.648948',
    DBKeys.status: 1,
  });

  // initialize walletika Core
  await walletikaCoreInitialize();

  // Add transaction
  await addNewTransaction(
    walletAddress: transaction.fromAddress,
    transaction: transaction,
  );

  // Get all transactions

  await getAllTransactions(transaction.fromAddress);

  // Remove transaction
  await removeTransaction(transaction);
}
