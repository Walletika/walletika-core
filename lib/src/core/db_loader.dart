import 'package:aesdatabase/aesdatabase.dart';

Future<DatabaseEngine> databaseLoader({
  required String filename,
  required List<String> columnTitles,
  bool hasBackup = false,
  String? key,
}) async {
  final DriveSetup drive = DriveSetup(hasBackup: hasBackup);
  drive.databaseUpdate(file: filename);

  if (hasBackup) drive.backupUpdate(file: 'Walletika');

  await drive.create();

  final DatabaseEngine db = DatabaseEngine(drive, key ?? 'NoKey');
  db.createTable(columnTitles);

  await db.load();

  return db;
}

late DatabaseEngine walletsDB;
late DatabaseEngine addressesBookDB;
late DatabaseEngine networksDB;
late DatabaseEngine tokensDB;
late DatabaseEngine transactionsDB;
late DatabaseEngine stakeDB;
