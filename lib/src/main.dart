import 'dart:io';

import 'package:walletika_sdk/src/engine/stake.dart';

import 'core/core.dart';

Future<void> walletikaSDKInitialize({String? encryptionKey}) async {
  // ABIs loading
  tokenABI = await File(tokenABIPath).readAsString();
  stakeABI = await File(stakeABIPath).readAsString();
  // wnsABI = await File(wnsABIPath).readAsString();

  // Database loading
  walletsDB = await databaseLoader(
    filename: "wallets",
    columnTitles: [
      "username",
      "address",
      "recoveryPassword",
      "dateCreated",
      "isFavorite",
    ],
    hasBackup: true,
    key: encryptionKey,
  );

  addressesBookDB = await databaseLoader(
    filename: "addressesbook",
    columnTitles: [
      "username",
      "address",
    ],
    key: encryptionKey,
  );

  networksDB = await databaseLoader(
    filename: "networks",
    columnTitles: [
      "rpc",
      "name",
      "chainID",
      "symbol",
      "explorer",
    ],
    key: encryptionKey,
  );

  tokensDB = await databaseLoader(
    filename: "tokens",
    columnTitles: [
      "address",
      "rpc",
      "contract",
      "symbol",
      "decimals",
      "website",
    ],
    key: encryptionKey,
  );

  transactionsDB = await databaseLoader(
    filename: "transactions",
    columnTitles: [
      "address",
      "rpc",
      "txHash",
      "function",
      "fromAddress",
      "toAddress",
      "amount",
      "symbol",
      "dateCreated",
      "status",
    ],
    key: encryptionKey,
  );

  stakeDB = await databaseLoader(
    filename: "stakecontracts",
    columnTitles: [
      "rpc",
      "contract",
      "stakeToken",
      "rewardToken",
      "startBlock",
      "endBlock",
      "startTime",
      "endTime",
    ],
    key: encryptionKey,
  );

  // Stake contracts Fetching
  await importStakeContracts(
    'https://raw.githubusercontent.com/Walletika/metadata/main/stake-contracts.json',
  );
}
