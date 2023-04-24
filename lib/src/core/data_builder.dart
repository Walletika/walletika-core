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
    tokensDB.addRow({
      DBKeys.rpc: token[DBKeys.rpc],
      DBKeys.contract: token[DBKeys.contract],
      DBKeys.name: token[DBKeys.name],
      DBKeys.symbol: token[DBKeys.symbol],
      DBKeys.decimals: token[DBKeys.decimals],
      DBKeys.website: token[DBKeys.website],
    });
  }

  await tokensDB.dump();
}
