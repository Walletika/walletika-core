import 'package:aesdatabase/aesdatabase.dart';

import '../core/core.dart';
import '../models.dart';
import 'provider.dart';

Stream<NetworkData> getAllNetworks() async* {
  await for (final DBRow row in networksDB.select()) {
    yield NetworkData.fromJson(row.items);
  }
}

Future<bool> addNewNetwork(NetworkData networkData) async {
  bool isValid = false;

  final Provider provider = Provider();
  final bool isConnected = await provider.connect(networkData);

  if (isConnected) {
    if ((await provider.web3.getChainId()).toInt() == networkData.chainID) {
      isValid = true;
    }
  }

  if (isValid) {
    networksDB.addRow(networkData.toJson());
    await networksDB.dump();
  }

  return isValid;
}

Future<bool> removeNetwork(NetworkData network) async {
  bool result = false;

  if (!network.isLocked) {
    await for (final DBRow row in networksDB.select(
      items: network.toJson(),
    )) {
      networksDB.removeRow(row.index);
      await networksDB.dump();
      result = true;
      break;
    }
  }

  return result;
}
