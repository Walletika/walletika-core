import 'package:walletika_sdk/src/engine/stake.dart';

import 'core/core.dart';

Future<void> walletikaSDKInitialize() {
  return Future(() {
    // ABIs loading
    tokenABI;
    stakeABI;
    wnsABI;

    // Database loading
    walletsDB;
    addressesBookDB;
    networksDB;
    tokensDB;
    transactionsDB;
    stakeDB;

    // Stake contracts Fetching
    importStakeContracts(
      'https://raw.githubusercontent.com/Walletika/metadata/main/stake-contracts.json',
    );
  });
}
