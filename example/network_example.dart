import 'package:walletika_sdk/walletika_sdk.dart';

void main() async {
  String rpc = 'https://data-seed-prebsc-1-s1.binance.org:8545';
  String name = 'Binance Smart Chain (Testnet)';
  int chainID = 97;
  String symbol = 'BNB';
  String explorer = 'https://testnet.bscscan.com';

  // initialize walletika SDK
  await walletikaSDKInitialize();

  // Add new network
  bool isAdded = await addNewNetwork(
    rpc: rpc,
    name: name,
    chainID: chainID,
    symbol: symbol,
    explorer: explorer,
  );

  // Get all networks
  List<NetworkModel> allNetworks = [
    await for (NetworkModel item in getAllNetworks()) item
  ];

  // Remove a network
  bool isRemoved = await removeNetwork(allNetworks[0]);
}
