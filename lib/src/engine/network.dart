import 'package:aesdatabase/aesdatabase.dart';

import '../core/core.dart';
import '../models.dart';
import 'provider.dart';

/// Get all networks from database
Stream<NetworkData> getAllNetworks() async* {
  await for (final DBRow row in networksDB.select()) {
    yield NetworkData.fromJson(row.items);
  }
}

/// Add a new network to database
Future<bool> addNewNetwork(NetworkData networkData) async {
  bool isValid = false;

  final ProviderEngine provider = ProviderEngine();
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

/// Remove a network from database
Future<bool> removeNetwork(NetworkData network) async {
  bool isValid = false;

  if (!network.isLocked) {
    await for (final DBRow row in networksDB.select(
      items: network.toJson(),
    )) {
      networksDB.removeRow(row.index);
      await networksDB.dump();
      isValid = true;
      break;
    }
  }

  return isValid;
}
