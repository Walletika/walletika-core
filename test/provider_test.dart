import 'package:walletika_sdk/walletika_sdk.dart';
import 'package:test/test.dart';
import 'package:web3dart/web3dart.dart';

import 'core/core.dart';

const debugging = true;
void printDebug(String message) {
  if (debugging) print(message);
}

void main() async {
  await walletikaSDKInitialize();

  final List<Map<String, dynamic>> wallets = walletsDataTest();
  final List<Map<String, dynamic>> networks = networksDataTest();
  const int networkIndex = 2; // BSC Testnet

  group("Provider View Group:", () {
    test("Test (connect)", () async {
      String rpc = networks[networkIndex]['rpc'];
      String name = networks[networkIndex]['name'];
      int chainID = networks[networkIndex]['chainID'];
      String symbol = networks[networkIndex]['symbol'];
      String explorer = networks[networkIndex]['explorer'];
      NetworkModel networkModel = NetworkModel(
        rpc: rpc,
        name: name,
        chainID: chainID,
        symbol: symbol,
        explorer: explorer,
      );

      bool isConnected = await Provider.connect(networkModel);

      printDebug("""
rpc: $rpc
name: $name
chainID: $chainID
symbol: $symbol
explorer: $explorer
isConnected: $isConnected
        """);

      expect(Provider.networkModel.rpc, equals(rpc));
      expect(Provider.networkModel.name, equals(name));
      expect(Provider.networkModel.chainID, equals(chainID));
      expect(Provider.networkModel.symbol, equals(symbol));
      expect(Provider.networkModel.explorer, equals(explorer));
      expect(isConnected, isTrue);
    });

    test("Test (balanceOf)", () async {
      for (Map<String, dynamic> wallet in wallets) {
        String address = wallet['address'];
        String username = wallet['username'];
        EtherAmount balance = await Provider.balanceOf(
          address: EthereumAddress.fromHex(address),
        );
        double amount = balance.getValueInUnit(EtherUnit.ether);

        printDebug("""
address: $address
username: $username
balance: $amount
        """);

        expect(amount, greaterThanOrEqualTo(0));
      }
    });

    test("Test (blockNumber)", () async {
      int blockNumber = await Provider.blockNumber();

      printDebug("""
blockNumber: $blockNumber
        """);

      expect(blockNumber, greaterThan(0));
    });

    test("Test (isEIP1559Supported)", () async {
      bool isEIP1559Supported = Provider.isEIP1559Supported();

      printDebug("""
isEIP1559Supported: $isEIP1559Supported
        """);

      expect(
        isEIP1559Supported,
        Provider.networkModel.symbol == 'ETH' ? isTrue : isFalse,
      );
    });

    test("Test (getExploreUrl)", () async {
      String address = '0x71471d05114c758eBfC3D3b952a722Ef2d53970b';
      String txHash =
          '0xea990434854a23753062bd01ebc87cf3ff452b68d3f0eabeb1fdb545cab537b6';

      String addressURL = Provider.getExploreUrl(address);
      String txURL = Provider.getExploreUrl(txHash);

      printDebug("""
address: $address
addressURL: $addressURL
txHash: $txHash
txURL: $txURL
        """);

      expect(
        addressURL,
        equals('${Provider.networkModel.explorer}/address/$address'),
      );
      expect(txURL, equals('${Provider.networkModel.explorer}/tx/$txHash'));
    });

    test("Test (getTransaction)", () async {
      String txHash =
          '0x0999608c57697ff7a6051bbbc76f8fe7d2c552d1df7e0f0553d91798f722ec3f';

      TransactionInformation? tx = await Provider.getTransaction(txHash);

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

      TransactionReceipt? tx = await Provider.getTransactionReceipt(txHash);

      printDebug("""
txHash: $txHash
hash: ${Provider.fromBytesToHex(tx!.transactionHash)}
from: ${tx.from}
to: ${tx.to}
        """);

      expect(txHash, equals(Provider.fromBytesToHex(tx.transactionHash)));
    });
  });

  group("Provider Transaction Group:", () {
    test("Test (transfer/addGas/sendTransaction)", () async {
      EtherAmount amount = EtherAmount.fromUnitAndValue(EtherUnit.ether, 0.01);
      EthereumAddress recipient = EthereumAddress.fromHex(
        '0x71471d05114c758eBfC3D3b952a722Ef2d53970b',
      );

      for (Map<String, dynamic> wallet in wallets) {
        // Wallet data
        String username = wallet['username'];
        String password = wallet['password'];
        String recoveryPassword = wallet['recoveryPass'];

        // Transaction details
        Transaction tx;
        Map<String, dynamic> abi;
        Map<String, dynamic> args;
        String data;
        EtherAmount estimateGas;
        EtherAmount maxFee;
        EtherAmount total;
        EtherAmount maxAmount;

        // Wallet engine
        WalletModel walletModel = getWalletModel(
          username,
          password,
          recoveryPassword,
        );
        WalletEngine walletEngine = WalletEngine(walletModel);

        // Check balance and skip if not enough
        EtherAmount balance = await Provider.balanceOf(
          address: walletModel.address,
        );
        if (balance.getInWei <= amount.getInWei) continue;

        // Get credentials
        String otpCode = getOTPCode(username, password, recoveryPassword);
        walletEngine.login(password: password, otpCode: otpCode);
        EthPrivateKey? credentials = await walletEngine.credentials(otpCode);

        // Build transaction
        TxDetailsModel txDetails = await Provider.transfer(
          sender: walletModel.address,
          recipient: recipient,
          amount: amount,
        );
        tx = txDetails.tx;
        abi = txDetails.abi;
        args = txDetails.args;
        data = txDetails.data;

        // Add gas fee
        TxGasDetailsModel txGasDetails = await Provider.addGas(tx: tx);
        tx = txGasDetails.tx;
        estimateGas = txGasDetails.estimateGas;
        maxFee = txGasDetails.maxFee;
        total = txGasDetails.total;
        maxAmount = txGasDetails.maxAmount;

        // Send transaction
        String sendTransaction = await Provider.sendTransaction(
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
data: $data
estimateGas: ${estimateGas.getValueInUnit(EtherUnit.ether)}
maxFee: ${maxFee.getValueInUnit(EtherUnit.ether)}
total: ${total.getValueInUnit(EtherUnit.ether)}
maxAmount: ${maxAmount.getValueInUnit(EtherUnit.ether)}
txURL: ${Provider.getExploreUrl(sendTransaction)}
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
        expect(abi, isEmpty);
        expect(args, isEmpty);
        expect(data, isEmpty);
        expect(estimateGas.getInWei, greaterThan(BigInt.zero));
        expect(maxFee.getInWei, greaterThanOrEqualTo(estimateGas.getInWei));
        expect(total.getInWei, greaterThan(amount.getInWei));
        expect(maxAmount.getInWei, greaterThanOrEqualTo(total.getInWei));
      }
    });
  });
}
