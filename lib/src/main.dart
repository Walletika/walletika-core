import 'package:walletika_sdk/src/engine/stake.dart';

import 'core/core.dart';
import 'data/data.dart';

bool _isInitialized = false;

bool get walletikaSDKInitialized => _isInitialized;

Future<void> walletikaSDKInitialize({
  String? encryptionKey,
  String? stakeAPI,
  String? stakeKey,
  String directory = "assets",
}) async {
  if (_isInitialized) {
    throw Exception("Walletika API already initialized");
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
    filename: "networks",
    columnTitles: [
      DBKeys.rpc,
      DBKeys.name,
      DBKeys.chainID,
      DBKeys.symbol,
      DBKeys.explorer,
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

  await networkDataBuilder();

  await tokenDataBuilder();

  // Stake contracts Fetching
  if (stakeAPI != null) {
    await importStakeContracts(apiURL: stakeAPI, encryptionKey: stakeKey);
  }

  _isInitialized = true;
}

Future<void> walletikaSDKEncryptionKeyChanger(String key) async {
  walletsDB.setKey(key);
  if (walletsDB.countRow() > 0) {
    await walletsDB.dump();
  }

  addressesBookDB.setKey(key);
  if (addressesBookDB.countRow() > 0) {
    await addressesBookDB.dump();
  }

  networksDB.setKey(key);
  if (networksDB.countRow() > 0) {
    await networksDB.dump();
  }

  tokensDB.setKey(key);
  if (tokensDB.countRow() > 0) {
    await tokensDB.dump();
  }

  transactionsDB.setKey(key);
  if (transactionsDB.countRow() > 0) {
    await transactionsDB.dump();
  }

  stakeDB.setKey(key);
  if (stakeDB.countRow() > 0) {
    await stakeDB.dump();
  }
}
