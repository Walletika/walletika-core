import 'core/core.dart';
import 'engine/stake.dart';

bool _isInitialized = false;

bool get walletikaSDKInitialized => _isInitialized;

Future<void> walletikaSDKInitialize({
  String? encryptionKey,
  List<Map<String, dynamic>>? initialNetworks,
  List<Map<String, dynamic>>? initialTokens,
  List<Map<String, dynamic>>? initialStakeContracts,
  String directory = "storage",
}) async {
  if (_isInitialized) {
    throw Exception("Walletika SDK already initialized");
  }

  // Database loading
  walletsDB = await databaseLoader(
    directory: directory,
    filename: "wallets",
    columnTitles: [
      DBKeys.username,
      DBKeys.address,
      DBKeys.securityPassword,
      DBKeys.dateCreated,
      DBKeys.isFavorite,
    ],
    hasBackup: true,
    key: encryptionKey,
  );

  addressesBookDB = await databaseLoader(
    directory: directory,
    filename: "addresses",
    columnTitles: [
      DBKeys.username,
      DBKeys.address,
      DBKeys.dateCreated,
      DBKeys.salt,
    ],
    key: encryptionKey,
  );

  networksDB = await databaseLoader(
    directory: directory,
    filename: "networks_v2",
    columnTitles: [
      DBKeys.rpc,
      DBKeys.name,
      DBKeys.chainID,
      DBKeys.symbol,
      DBKeys.explorer,
      DBKeys.isLocked,
      DBKeys.image,
    ],
    key: encryptionKey,
  );

  tokensDB = await databaseLoader(
    directory: directory,
    filename: "tokens",
    columnTitles: [
      DBKeys.rpc,
      DBKeys.contract,
      DBKeys.name,
      DBKeys.symbol,
      DBKeys.decimals,
      DBKeys.website,
    ],
    key: encryptionKey,
  );

  transactionsDB = await databaseLoader(
    directory: directory,
    filename: "transactions",
    columnTitles: [
      DBKeys.address,
      DBKeys.rpc,
      DBKeys.txHash,
      DBKeys.function,
      DBKeys.fromAddress,
      DBKeys.toAddress,
      DBKeys.amount,
      DBKeys.symbol,
      DBKeys.decimals,
      DBKeys.dateCreated,
      DBKeys.status,
    ],
    key: encryptionKey,
  );

  stakeDB = await databaseLoader(
    directory: directory,
    filename: "stakes",
    columnTitles: [
      DBKeys.rpc,
      DBKeys.contract,
      DBKeys.stakeToken,
      DBKeys.rewardToken,
      DBKeys.startBlock,
      DBKeys.endBlock,
      DBKeys.startTime,
      DBKeys.endTime,
      DBKeys.isLocked,
    ],
    key: encryptionKey,
  );

  await networksDataBuilder(initialNetworks);

  await tokensDataBuilder(initialTokens);

  if (initialStakeContracts != null) {
    await stakeContractsUpdate(initialStakeContracts);
  }

  _isInitialized = true;
}

Future<void> walletikaSDKEncryptionKeyChanger(String key) async {
  walletsDB.setKey(key);
  await walletsDB.dump();

  addressesBookDB.setKey(key);
  await addressesBookDB.dump();

  networksDB.setKey(key);
  await networksDB.dump();

  tokensDB.setKey(key);
  await tokensDB.dump();

  transactionsDB.setKey(key);
  await transactionsDB.dump();

  stakeDB.setKey(key);
  await stakeDB.dump();
}
