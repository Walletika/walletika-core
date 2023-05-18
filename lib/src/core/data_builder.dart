import '../models.dart';
import 'constants.dart';
import 'db_loader.dart';

Future<void> networksDataBuilder(List<Map<String, dynamic>>? data) async {
  if (data == null || networksDB.countRow() > 0) return;

  for (final Map<String, dynamic> network in data) {
    networksDB.addRow({
      DBKeys.rpc: network[DBKeys.rpc],
      DBKeys.name: network[DBKeys.name],
      DBKeys.chainID: network[DBKeys.chainID],
      DBKeys.symbol: network[DBKeys.symbol],
      DBKeys.explorer: network[DBKeys.explorer],
    });
  }

  await networksDB.dump();
}

Future<void> tokensDataBuilder(List<Map<String, dynamic>>? data) async {
  if (data == null || tokensDB.countRow() > 0) return;

  for (final Map<String, dynamic> token in data) {
    final TokenData tokenData = TokenData.fromJson(token);
    tokensDB.addRow(tokenData.toJson());
  }

  await tokensDB.dump();
}
