import '../models.dart';
import 'constants.dart';
import 'db_loader.dart';

Future<void> networksDataBuilder(List<Map<String, dynamic>>? data) async {
  if (data == null) return;

  final List<Map<String, dynamic>> userNetworks = await networksDB
      .select(items: {DBKeys.isLocked: false})
      .map((row) => row.items)
      .toList();

  networksDB.clear();

  for (final Map<String, dynamic> network in data) {
    final NetworkData networkData = NetworkData.fromJson({
      ...network,
      DBKeys.isLocked: true,
    });
    networksDB.addRow(networkData.toJson());
  }

  for (final Map<String, dynamic> network in userNetworks) {
    final NetworkData networkData = NetworkData.fromJson(network);
    networksDB.addRow(networkData.toJson());
  }

  await networksDB.dump();
}

Future<void> tokensDataBuilder(List<Map<String, dynamic>>? data) async {
  if (data == null || tokensDB.countRow() > 0) return;

  for (final Map<String, dynamic> token in data) {
    final TokenData tokenData = TokenData.fromJson(token);
    tokensDB.addRow({
      DBKeys.rpc: token[DBKeys.rpc],
      ...tokenData.toJson(),
    });
  }

  await tokensDB.dump();
}

Future<void> stakeDataBuilder(List<Map<String, dynamic>>? data) async {
  if (data == null) return;

  stakeDB.clear();

  for (final Map<String, dynamic> stake in data) {
    final StakeData stakeData = StakeData.fromJson(stake);
    stakeDB.addRow({
      DBKeys.rpc: stake[DBKeys.rpc],
      ...stakeData.toJson(),
    });
  }

  await stakeDB.dump();
}
