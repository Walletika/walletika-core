import 'core/core.dart';

bool _isInitialized = false;

/// Get initialization status
bool get walletikaSDKInitialized => _isInitialized;

/// WalletikaSDK requires to initialize before use
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
  walletsDB = await databaseInitialize(
    directory: directory,
    filename: "wallets",
    columnTitles: [
      DBKeys.type,
      DBKeys.username,
      DBKeys.address,
      DBKeys.securityPassword,
      DBKeys.dateCreated,
      DBKeys.isFavorite,
    ],
    hasBackup: true,
    key: encryptionKey,
  );
  addressesBookDB = await databaseInitialize(
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
  networksDB = await databaseInitialize(
    directory: directory,
    filename: "networks",
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
  tokensDB = await databaseInitialize(
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
  transactionsDB = await databaseInitialize(
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
  stakeDB = await databaseInitialize(
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

  // Add initial networks
  await networksDataBuilder(initialNetworks);

  // Add initial tokens
  await tokensDataBuilder(initialTokens);

  // Add initial stake contracts
  await stakesDataBuilder(initialStakeContracts);

  _isInitialized = true;
}

/// Change encryption key for all database
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
