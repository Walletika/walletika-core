import 'package:aesdatabase/aesdatabase.dart';

/// Database initialization and loading
Future<DatabaseEngine> databaseInitialize({
  required String directory,
  required String filename,
  required List<String> columnTitles,
  bool hasBackup = false,
  String? key,
}) async {
  // Drive configuration and create
  final DriveSetup drive = DriveSetup(hasBackup: hasBackup);
  drive.tempUpdate(main: directory);
  drive.databaseUpdate(main: directory, file: filename);

  if (hasBackup) drive.backupUpdate(main: directory, file: 'Walletika');

  await drive.create();

  // Connect to database
  final DatabaseEngine db = DatabaseEngine(drive, key: key ?? 'NoKey');
  db.createTable(columnTitles);
  await db.load();

  return db;
}

/// Wallet database engine
late DatabaseEngine walletsDB;

/// Addresses book database engine
late DatabaseEngine addressesBookDB;

/// Networks database engine
late DatabaseEngine networksDB;

/// Tokens database engine
late DatabaseEngine tokensDB;

/// Transaction history database engine
late DatabaseEngine transactionsDB;

/// Stake database engine
late DatabaseEngine stakeDB;
