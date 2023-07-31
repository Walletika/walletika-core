import 'package:aesdatabase/aesdatabase.dart';

import '../core/core.dart';
import '../models.dart';
import 'provider.dart';

/// Get all networks from database
Future<List<NetworkData>> getAllNetworks() {
  return networksDB
      .select()
      .map((row) => NetworkData.fromJson(row.items))
      .toList();
}

/// Add a new network to database
Future<bool> addNewNetwork(NetworkData networkData) async {
  bool isValid = false;

  final ProviderEngine provider = ProviderEngine();
  provider.connect(networkData);
  final bool isConnected = await provider.isConnected();

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
