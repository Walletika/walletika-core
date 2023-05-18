import '../models.dart';
import 'constants.dart';
import 'db_loader.dart';

Future<void> networksDataBuilder(List<Map<String, dynamic>>? data) async {
  if (data == null || networksDB.countRow() > 0) return;

  for (final Map<String, dynamic> network in data) {
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
