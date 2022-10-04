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

  final List<Map<String, dynamic>> networks = networksDataTest();

  group("Network Storage Group:", () {
    test("Test (addNewNetwork)", () async {
      for (Map<String, dynamic> network in networks) {
        String rpc = network['rpc'];
        String name = network['name'];
        int chainID = network['chainID'];
        String symbol = network['symbol'];
        String explorer = network['explorer'];

        bool isAdded = await addNewNetwork(
          rpc: rpc,
          name: name,
          chainID: chainID,
          symbol: symbol,
          explorer: explorer,
        );

        printDebug("""
name: $name
isAdded: $isAdded
        """);

        expect(isAdded, isTrue);
      }
    });

    test("Test (getAllNetworks)", () async {
      List<NetworkModel> allNetworks = await getAllNetworks();

      for (int index = 0; index < allNetworks.length; index++) {
        NetworkModel networkModel = allNetworks[index];
        String rpc = networkModel.rpc;
        String name = networkModel.name;
        int chainID = networkModel.chainID;
        String symbol = networkModel.symbol;
        String explorer = networkModel.explorer;

        printDebug("""
rpc: $rpc
name: $name
chainID: $chainID
symbol: $symbol
explorer: $explorer
        """);

        expect(rpc, equals(networks[index]['rpc']));
        expect(name, equals(networks[index]['name']));
        expect(chainID, equals(networks[index]['chainID']));
        expect(symbol, equals(networks[index]['symbol']));
        expect(explorer, equals(networks[index]['explorer']));
      }

      expect(allNetworks.length, equals(networks.length));
    });

    test("Test (removeNetwork)", () async {
      List<NetworkModel> allNetworks = await getAllNetworks();

      for (int index = 0; index < allNetworks.length; index++) {
        NetworkModel networkModel = allNetworks[index];
        String name = networkModel.name;

        bool isRemoved = await removeNetwork(networkModel);
        bool isExists = [
          await for (RowModel row in networksDB.select(
            items: networkModel.toJson(),
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
