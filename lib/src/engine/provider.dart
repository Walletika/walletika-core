import 'package:http/http.dart' as http;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import '../models.dart';

class Provider {
  static late NetworkModel networkModel;
  static late Web3Client web3;

  static Future<bool> connect(NetworkModel network) async {
    networkModel = network;
    final http.Client httpClient = http.Client();
    web3 = Web3Client(network.rpc, httpClient);

    return isConnected();
  }

  static Future<bool> isConnected() async {
    try {
      return await web3.isListeningForNetwork();
    } catch (e) {
      return false;
    }
  }

  static Future<EtherAmount> balanceOf({
    required EthereumAddress address,
    BlockNum? atBlock,
  }) {
    return web3.getBalance(address, atBlock: atBlock);
  }

  static Future<int> blockNumber() {
    return web3.getBlockNumber();
  }

  static bool isEIP1559Supported() {
    bool result = false;

    if (networkModel.rpc.contains('.infura.io/v3') &&
        networkModel.symbol == 'ETH') {
      result = true;
    }

    return result;
  }

  static Future<TxDetailsModel> transfer({
    required EthereumAddress sender,
    required EthereumAddress recipient,
    required EtherAmount amount,
  }) async {
    final Transaction tx = Transaction(
      from: sender,
      to: recipient,
      value: amount,
      nonce: await web3.getTransactionCount(sender),
    );

    return TxDetailsModel(tx: tx, abi: {}, args: {}, data: '');
  }

  static Future<TxGasDetailsModel> addGas({
    required Transaction tx,
    bool amountAdjustment = true,
    bool eip1559Enabled = false,
    String rate = 'medium',
  }) async {
    // Gas reset
    tx = tx.copyWith(
      gasPrice: null,
      maxGas: null,
      maxFeePerGas: null,
      maxPriorityFeePerGas: null,
    );

    // Gas limit
    final BigInt gasLimit = await web3.estimateGas(
      sender: tx.from,
      to: tx.to,
      value: tx.value,
      data: tx.data,
    );

    final BigInt estimateGas;
    final BigInt maxFee;

    // Add gas as legacy or EIP1559
    if (eip1559Enabled) {
      final Map<String, EIP1559Information> gasEIP =
          await web3.getGasInEIP1559();
      tx = tx.copyWith(
        maxGas: gasLimit.toInt(),
        maxFeePerGas: gasEIP[rate]!.maxFeePerGas,
        maxPriorityFeePerGas: gasEIP[rate]!.maxPriorityFeePerGas,
      );
      estimateGas = gasLimit * gasEIP[rate]!.estimatedGas;
      maxFee = gasLimit * tx.maxFeePerGas!.getInWei;
    } else {
      final EtherAmount gasPrice = await web3.getGasPrice();
      tx = tx.copyWith(
        maxGas: gasLimit.toInt(),
        gasPrice: gasPrice,
      );
      estimateGas = gasLimit * gasPrice.getInWei;
      maxFee = estimateGas;
    }

    BigInt total = estimateGas + tx.value!.getInWei;
    BigInt maxAmount = maxFee + tx.value!.getInWei;

    // Adjust the amount if it exceeds the balance
    if (amountAdjustment && tx.value!.getInWei > BigInt.zero) {
      final EtherAmount balance = await web3.getBalance(tx.from!);
      if (maxAmount > balance.getInWei) {
        final BigInt amountLeft = balance.getInWei - maxFee;
        if (amountLeft <= BigInt.zero) {
          throw Exception(
            "Insufficient funds for transfer, maybe it needs gas fee.",
          );
        }

        tx = tx.copyWith(value: EtherAmount.inWei(amountLeft));
        total = estimateGas + tx.value!.getInWei;
        maxAmount = maxFee + tx.value!.getInWei;
      }
    }

    return TxGasDetailsModel(
      tx: tx,
      estimateGas: EtherAmount.inWei(estimateGas),
      maxFee: EtherAmount.inWei(maxFee),
      total: EtherAmount.inWei(total),
      maxAmount: EtherAmount.inWei(maxAmount),
    );
  }

  static Future<String> sendTransaction({
    required Transaction tx,
    required EthPrivateKey credentials,
  }) {
    return web3.sendTransaction(
      credentials,
      tx,
      chainId: networkModel.chainID,
    );
  }

  static Future<TransactionInformation?> getTransaction(String txHash) async {
    try {
      return await web3.getTransactionByHash(txHash);
    } catch (e) {
      return null;
    }
  }

  static Future<TransactionReceipt?> getTransactionReceipt(
    String txHash,
  ) async {
    try {
      return await web3.getTransactionReceipt(txHash);
    } catch (e) {
      return null;
    }
  }

  static String getExploreUrl(String address) {
    return [
      networkModel.explorer,
      address.length <= 42 ? 'address' : 'tx',
      address
    ].join('/');
  }

  static String fromBytesToHex(List<int> bytes) {
    return bytesToHex(bytes, include0x: true);
  }

  static BigInt fromBytesToInt(List<int> bytes) {
    return bytesToInt(bytes);
  }
}
