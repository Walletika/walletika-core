import 'package:aesdatabase/aesdatabase.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

import '../core/core.dart';
import '../models.dart';

Stream<NetworkData> getAllNetworks() async* {
  await for (final DBRow row in networksDB.select()) {
    yield NetworkData.fromJson(row.items);
  }
}

Future<bool> addNewNetwork({
  required String rpc,
  required String name,
  required int chainID,
  required String symbol,
  required String explorer,
}) async {
  final bool isValid = await Web3Client(rpc, http.Client())
      .isListeningForNetwork()
      .catchError((_) => false);

  if (isValid) {
    networksDB.addRow({
      DBKeys.rpc: rpc,
      DBKeys.name: name,
      DBKeys.chainID: chainID,
      DBKeys.symbol: symbol,
      DBKeys.explorer: explorer,
    });
    await networksDB.dump();
  }

  return isValid;
}

Future<bool> removeNetwork(NetworkData network) async {
  bool result = false;

  await for (final DBRow row in networksDB.select(
    items: network.toJson(),
  )) {
    networksDB.removeRow(row.index);
    await networksDB.dump();
    result = true;
    break;
  }

  return result;
}
