import 'package:aesdatabase/aesdatabase.dart';
import 'package:walletika_sdk/src/core/core.dart';
import 'package:walletika_sdk/walletika_sdk.dart';
import 'package:test/test.dart';

import 'core/core.dart';

const debugging = true;
void printDebug(String message) {
  if (debugging) print(message);
}

void main() async {
  await walletikaSDKInitialize();
  printDebug("Is Initialized: $walletikaSDKInitialized");

  final List<Map<String, dynamic>> networks = networksDataTest();

  group("Network Storage Group:", () {
    test("Test (addNewNetwork)", () async {
      for (Map<String, dynamic> network in networks) {
        NetworkData networkData = NetworkData.fromJson(network);
        bool isAdded = await addNewNetwork(networkData);

        printDebug("""
name: ${networkData.name}
isAdded: $isAdded
        """);

        expect(isAdded, isTrue);
      }
    });

    test("Test (getAllNetworks)", () async {
      List<NetworkData> allNetworks = [
        await for (NetworkData item in getAllNetworks()) item
      ];

      for (int index = 0; index < allNetworks.length; index++) {
        NetworkData networkData = allNetworks[index];
        String rpc = networkData.rpc;
        String name = networkData.name;
        int chainID = networkData.chainID;
        String symbol = networkData.symbol;
        String explorer = networkData.explorer;
        String? image = networkData.image;

        printDebug("""
rpc: $rpc
name: $name
chainID: $chainID
symbol: $symbol
explorer: $explorer
image: $image
        """);

        expect(rpc, equals(networks[index][DBKeys.rpc]));
        expect(name, equals(networks[index][DBKeys.name]));
        expect(chainID, equals(networks[index][DBKeys.chainID]));
        expect(symbol, equals(networks[index][DBKeys.symbol]));
        expect(explorer, equals(networks[index][DBKeys.explorer]));
        expect(image, isNull);
      }

      expect(allNetworks.length, equals(networks.length));
    });

    test("Test (removeNetwork)", () async {
      List<NetworkData> allNetworks = [
        await for (NetworkData item in getAllNetworks()) item
      ];

      for (int index = 0; index < allNetworks.length; index++) {
        NetworkData networkData = allNetworks[index];
        String name = networkData.name;

        bool isRemoved = await removeNetwork(networkData);
        bool isExists = [
          await for (DBRow row in networksDB.select(
            items: networkData.toJson(),
          ))
            row
        ].isNotEmpty;

        printDebug("""
name: $name
isRemoved: $isRemoved
isExists: $isExists
        """);

        expect(isRemoved, isTrue);
        expect(isExists, isFalse);
      }
    });
  });
}
