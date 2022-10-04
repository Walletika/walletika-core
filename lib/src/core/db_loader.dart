import 'package:aesdatabase/aesdatabase.dart';

DatabaseEngine _databaseLoader({
  required String filename,
  required List<String> columnTitles,
  bool hasBackup = false,
}) {
  DriveSetup drive = DriveSetup(hasBackup: hasBackup);
  drive.databaseUpdate(file: filename);

  hasBackup ? drive.backupUpdate(file: 'Walletika') : null;

  drive.create();

  DatabaseEngine db = DatabaseEngine(drive, 'password');
  db.loadSync();

  if (db.countColumnSync() == 0) {
    db.createTableSync(columnTitles);
  }

  return db;
}

DatabaseEngine walletsDB = _databaseLoader(
  filename: "walletika",
  columnTitles: [
    "username",
    "address",
    "recoveryPassword",
    "dateCreated",
    "isFavorite",
  ],
  hasBackup: true,
);

final DatabaseEngine addressesBookDB = _databaseLoader(
  filename: "addressesbook",
  columnTitles: [
    "username",
    "address",
  ],
);

final DatabaseEngine networksDB = _databaseLoader(
  filename: "networks",
  columnTitles: [
    "rpc",
    "name",
    "chainID",
    "symbol",
    "explorer",
  ],
);

final DatabaseEngine tokensDB = _databaseLoader(
  filename: "tokens",
  columnTitles: [
    "address",
    "rpc",
    "contract",
    "symbol",
    "decimals",
    "website",
  ],
);

final DatabaseEngine transactionsDB = _databaseLoader(
  filename: "transactions",
  columnTitles: [
    "address",
    "rpc",
    "txHash",
    "function",
    "fromAddress",
    "toAddress",
    "amount",
    "symbol",
    "dateCreated",
    "status",
  ],
);

final DatabaseEngine stakeDB = _databaseLoader(
  filename: "stakecontracts",
  columnTitles: [
    "rpc",
    "contract",
    "stakeToken",
    "rewardToken",
    "startBlock",
    "endBlock",
    "startTime",
    "endTime",
  ],
);
