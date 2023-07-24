import '../models.dart';
import 'constants.dart';
import 'db_loader.dart';

/// Build default networks data ( Always updating )
Future<void> networksDataBuilder(List<Map<String, dynamic>>? data) async {
  if (data == null) return;

  // Get the networks added by the user
  final List<Map<String, dynamic>> userNetworks = await networksDB
      .select(items: {DBKeys.isLocked: false})
      .map((row) => row.items)
      .toList();

  // Remove all current networks
  networksDB.clear();

  // Add the default networks, Default network will be locked
  for (final Map<String, dynamic> network in data) {
    final NetworkData networkData = NetworkData.fromJson({
      ...network,
      DBKeys.isLocked: true,
    });
    networksDB.addRow(networkData.toJson());
  }

  // Add the user networks again
  for (final Map<String, dynamic> network in userNetworks) {
    final NetworkData networkData = NetworkData.fromJson(network);
    networksDB.addRow(networkData.toJson());
  }

  // Dump new changes
  await networksDB.dump();
}

/// Build default token data ( One time update )
Future<void> tokensDataBuilder(List<Map<String, dynamic>>? data) async {
  // Ignore if updated later
  if (data == null || tokensDB.countRow() > 0) return;

  // Add tokens to database
  for (final Map<String, dynamic> token in data) {
    final TokenData tokenData = TokenData.fromJson(token);
    tokensDB.addRow({
      DBKeys.rpc: token[DBKeys.rpc],
      ...tokenData.toJson(),
    });
  }

  // Dump new changes
  await tokensDB.dump();
}

/// Build default stakes data ( Always updating )
Future<void> stakesDataBuilder(List<Map<String, dynamic>>? data) async {
  if (data == null) return;

  // Remove all current stakes
  stakeDB.clear();

  // Add stakes contracts to database
  for (final Map<String, dynamic> stake in data) {
    final StakeData stakeData = StakeData.fromJson(stake);
    stakeDB.addRow({
      DBKeys.rpc: stake[DBKeys.rpc],
      ...stakeData.toJson(),
    });
  }

  // Dump new changes
  await stakeDB.dump();
}
