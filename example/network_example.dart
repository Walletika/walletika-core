import 'package:walletika_sdk/walletika_sdk.dart';

void main() async {
  String rpc = 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161';
  String name = 'Ethereum Ropsten (Testnet)';
  int chainID = 3;
  String symbol = 'ETH';
  String explorer = 'https://ropsten.etherscan.io';

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
  List<NetworkModel> allNetworks = await getAllNetworks();

  // Remove a network
  bool isRemoved = await removeNetwork(allNetworks[0]);
}
