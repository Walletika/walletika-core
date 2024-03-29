import 'package:walletika_core/src/core/core.dart';
import 'package:walletika_core/walletika_core.dart';
import 'package:test/test.dart';

import 'core/core.dart';

const debugging = true;
void printDebug(String message) {
  if (debugging) print(message);
}

void main() async {
  await walletikaCoreInitialize();
  printDebug("Is Initialized: $walletikaCoreInitialized");

  final List<Map<String, dynamic>> wallets = walletsDataTest();
  final List<Map<String, dynamic>> networks = networksDataTest();
  const int networkIndex = 2; // BSC Testnet

  group("ProviderEngine View Group:", () {
    test("Test (connect)", () async {
      String rpc = networks[networkIndex][DBKeys.rpc];
      String name = networks[networkIndex][DBKeys.name];
      int chainID = networks[networkIndex][DBKeys.chainID];
      String symbol = networks[networkIndex][DBKeys.symbol];
      String explorer = networks[networkIndex][DBKeys.explorer];
      NetworkData networkData = NetworkData(
        rpc: rpc,
        name: name,
        chainID: chainID,
        symbol: symbol,
        explorer: explorer,
        isLocked: false,
      );

      ProviderEngine.instance.connect(networkData);
      bool isConnected = await ProviderEngine.instance.isConnected();

      printDebug("""
rpc: $rpc
name: $name
chainID: $chainID
symbol: $symbol
explorer: $explorer
isConnected: $isConnected
        """);

      expect(ProviderEngine.instance.networkData.rpc, equals(rpc));
      expect(ProviderEngine.instance.networkData.name, equals(name));
      expect(ProviderEngine.instance.networkData.chainID, equals(chainID));
      expect(ProviderEngine.instance.networkData.symbol, equals(symbol));
      expect(ProviderEngine.instance.networkData.explorer, equals(explorer));
      expect(isConnected, isTrue);
    });

    test("Test (balanceOf)", () async {
      for (Map<String, dynamic> wallet in wallets) {
        String address = wallet[DBKeys.address];
        String username = wallet[DBKeys.username];
        EtherAmount balance = await ProviderEngine.instance.balanceOf(
          address: EthereumAddress.fromHex(address),
        );
        double amount = balance.getValueInUnit(EtherUnit.ether).toDouble();

        printDebug("""
address: $address
username: $username
balance: $amount
        """);

        expect(amount, greaterThanOrEqualTo(0));
      }
    });

    test("Test (blockNumber)", () async {
      int blockNumber = await ProviderEngine.instance.blockNumber();

      printDebug("""
blockNumber: $blockNumber
        """);

      expect(blockNumber, greaterThan(0));
    });

    test("Test (isSupportEIP1559)", () async {
      bool isSupportEIP1559 = await ProviderEngine.instance.isSupportEIP1559();

      printDebug("""
isSupportEIP1559: $isSupportEIP1559
        """);

      expect(isSupportEIP1559, isFalse);
    });

    test("Test (getExploreUrl)", () async {
      String address = '0x71471d05114c758eBfC3D3b952a722Ef2d53970b';
      String txHash =
          '0xea990434854a23753062bd01ebc87cf3ff452b68d3f0eabeb1fdb545cab537b6';

      String addressURL = ProviderEngine.instance.getExploreUrl(address);
      String txURL = ProviderEngine.instance.getExploreUrl(txHash);

      printDebug("""
address: $address
addressURL: $addressURL
txHash: $txHash
txURL: $txURL
        """);

      expect(
        addressURL,
        equals(
          '${ProviderEngine.instance.networkData.explorer}/address/$address',
        ),
      );
      expect(
        txURL,
        equals('${ProviderEngine.instance.networkData.explorer}/tx/$txHash'),
      );
    });

    test("Test (getTransaction)", () async {
      String txHash =
          '0x0999608c57697ff7a6051bbbc76f8fe7d2c552d1df7e0f0553d91798f722ec3f';

      TransactionInformation? tx = await ProviderEngine.instance.getTransaction(
        txHash,
      );

      printDebug("""
txHash: $txHash
hash: ${tx!.hash}
from: ${tx.from}
to: ${tx.to}
value: ${tx.value}
        """);

      expect(txHash, equals(tx.hash));
    });

    test("Test (getTransactionReceipt)", () async {
      String txHash =
          '0x0999608c57697ff7a6051bbbc76f8fe7d2c552d1df7e0f0553d91798f722ec3f';

      TransactionReceipt? tx =
          await ProviderEngine.instance.getTransactionReceipt(txHash);

      printDebug("""
txHash: $txHash
hash: ${fromBytesToHex(tx!.transactionHash)}
from: ${tx.from}
to: ${tx.to}
        """);

      expect(txHash, equals(fromBytesToHex(tx.transactionHash)));
    });

    test("Test (blockTimeInSeconds)", () async {
      double blockTimeInSeconds =
          await ProviderEngine.instance.blockTimeInSeconds();

      printDebug("""
blockTimeInSeconds: $blockTimeInSeconds
        """);

      expect(blockTimeInSeconds, equals(3.0));
    });

    test("Test (estimatedBlockTime)", () async {
      List<int> blocks = [30186682, 30193882, 30197482];

      DateTime expectedDate = DateTime(2023, 5, 28);
      Map<int, DateTime> result = await ProviderEngine.instance
          .estimatedBlockTime(blockNumbers: blocks);

      for (MapEntry<int, DateTime> item in result.entries) {
        int blockNumber = item.key;
        DateTime time = item.value;

        printDebug("""
blockNumber: $blockNumber
time: $time
        """);

        expect(blocks, contains(blockNumber));
        expect(time.day, equals(expectedDate.day));
        expect(time.month, equals(expectedDate.month));
        expect(time.year, equals(expectedDate.year));
      }
    });
  });

  group("ProviderEngine Transaction Group:", () {
    test("Test (transfer/addGas/sendTransaction)", () async {
      EtherAmount amount =
          EtherAmount.fromBase10String(EtherUnit.ether, '0.01');
      EthereumAddress recipient = EthereumAddress.fromHex(
        '0x71471d05114c758eBfC3D3b952a722Ef2d53970b',
      );

      for (Map<String, dynamic> wallet in wallets) {
        // Wallet data
        String username = wallet[DBKeys.username];
        String password = wallet[DBKeys.password];
        String securityPassword = wallet[DBKeys.securityPassword];

        // Transaction details
        Transaction tx;
        Map<String, dynamic> txJson;
        Map<String, dynamic>? abi;
        Map<String, dynamic>? args;
        EtherAmount estimateGas;
        EtherAmount maxFee;
        EtherAmount total;
        EtherAmount maxAmount;

        // Wallet engine
        WalletData walletData = await getWalletData(
          username,
          password,
          securityPassword,
        );
        WalletEngine walletEngine = WalletEngine(walletData);

        // Check balance and skip if not enough
        EtherAmount balance = await ProviderEngine.instance.balanceOf(
          address: walletData.address,
        );
        if (balance.getInWei <= amount.getInWei) continue;

        // Get credentials
        String otpCode = getOTPCode(username, password, securityPassword);
        await walletEngine.login(password);
        EthPrivateKey? credentials = await walletEngine.credentials(otpCode);

        // Build transaction
        TxDetailsData txDetails = await ProviderEngine.instance.transfer(
          sender: walletData.address,
          recipient: recipient,
          amount: amount,
        );
        tx = txDetails.tx;
        abi = txDetails.abi;
        args = txDetails.args;

        // Add gas fee
        TxGasDetailsData txGasDetails =
            await ProviderEngine.instance.addGas(tx: tx);
        tx = txGasDetails.tx;
        txJson = txGasDetails.tx.toJson();
        estimateGas = txGasDetails.estimateGas;
        maxFee = txGasDetails.maxFee;
        total = txGasDetails.total;
        maxAmount = txGasDetails.maxAmount;

        // Send transaction
        String sendTransaction = await ProviderEngine.instance.sendTransaction(
          credentials: credentials!,
          tx: tx,
        );

        printDebug("""
username: ${walletEngine.username()}
address: ${walletEngine.address()}
recipient: ${recipient.hexEip55}
amount: ${amount.getValueInUnit(EtherUnit.ether)}
abi: $abi
args: $args
txJson: $txJson
estimateGas: ${estimateGas.getValueInUnit(EtherUnit.ether)}
maxFee: ${maxFee.getValueInUnit(EtherUnit.ether)}
total: ${total.getValueInUnit(EtherUnit.ether)}
maxAmount: ${maxAmount.getValueInUnit(EtherUnit.ether)}
txURL: ${ProviderEngine.instance.getExploreUrl(sendTransaction)}
        """);

        expect(tx.from, equals(walletEngine.address()));
        expect(tx.to, equals(recipient));
        expect(tx.value, equals(amount));
        expect(tx.data, isNull);
        expect(tx.nonce, greaterThanOrEqualTo(0));
        expect(tx.maxGas, greaterThanOrEqualTo(21000));
        if (tx.isEIP1559) {
          expect(tx.maxPriorityFeePerGas!.getInWei, greaterThan(BigInt.zero));
          expect(tx.maxFeePerGas!.getInWei, greaterThan(BigInt.zero));
        } else {
          expect(tx.gasPrice!.getInWei, greaterThan(BigInt.zero));
        }
        expect(abi, isNull);
        expect(args, isNull);
        expect(txJson.length, equals(9));
        expect(estimateGas.getInWei, greaterThan(BigInt.zero));
        expect(maxFee.getInWei, greaterThanOrEqualTo(estimateGas.getInWei));
        expect(total.getInWei, greaterThan(amount.getInWei));
        expect(maxAmount.getInWei, greaterThanOrEqualTo(total.getInWei));
      }
    });
  });
}
