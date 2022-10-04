import 'package:aesdatabase/aesdatabase.dart';

import '../core/core.dart';
import '../models.dart';

Future<List<NetworkModel>> getAllNetworks() async {
  List<NetworkModel> result = [];

  await for (RowModel row in networksDB.select()) {
    NetworkModel network = NetworkModel.fromJson(row.items);
    result.add(network);
  }

  return result;
}

Future<bool> addNewNetwork({
  required String rpc,
  required String name,
  required int chainID,
  required String symbol,
  required String explorer,
}) {
  return Future(() {
    networksDB.insertSync(
      rowIndex: networksDB.countRowSync(),
      items: {
        "rpc": rpc,
        "name": name,
        "chainID": chainID,
        "symbol": symbol,
        "explorer": explorer,
      },
    );

    networksDB.dumpSync();

    return true;
  });
}

Future<bool> removeNetwork(NetworkModel network) async {
  bool result = false;

  await for (RowModel row in networksDB.select(items: network.toJson())) {
    networksDB.removeRowSync(row.index);
    networksDB.dumpSync();
    result = true;
    break;
  }

  return result;
}
