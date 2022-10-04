import 'core/core.dart';

Future<void> walletikaSDKInitialize() {
  return Future(() {
    tokenABI;
    stakeABI;
    wnsABI;

    walletsDB;
    addressesBookDB;
    networksDB;
    tokensDB;
    transactionsDB;
    stakeDB;
  });
}
