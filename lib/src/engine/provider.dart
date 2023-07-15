import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import '../models.dart';

class Provider {
  late NetworkData _networkData;
  late Web3Client _web3;
  late bool _isConnected;

  static Provider instance = Provider();

  NetworkData get networkData => _networkData;

  Web3Client get web3 => _web3;

  Future<bool> connect(NetworkData network) async {
    final http.Client httpClient = http.Client();
    _web3 = Web3Client(network.rpc, httpClient);
    _networkData = network;

    return isConnected();
  }

  Future<bool> isConnected() async {
    try {
      await _web3.getClientVersion();
      _isConnected = true;
    } catch (_) {
      _isConnected = false;
    }

    return _isConnected;
  }

  Future<EtherAmount> balanceOf({
    required EthereumAddress address,
    BlockNum? atBlock,
  }) {
    connectionValidator();
    return _web3.getBalance(address, atBlock: atBlock);
  }

  Future<int> blockNumber() {
    connectionValidator();
    return _web3.getBlockNumber();
  }

  bool isEIP1559Supported() {
    bool result = false;

    if (_networkData.rpc.contains('.infura.io/v3') &&
        _networkData.symbol == 'ETH') {
      result = true;
    }

    return result;
  }

  Future<TxDetailsData> transfer({
    required EthereumAddress sender,
    required EthereumAddress recipient,
    required EtherAmount amount,
  }) async {
    connectionValidator();

    final Transaction tx = Transaction(
      from: sender,
      to: recipient,
      value: amount,
      nonce: await _web3.getTransactionCount(sender),
    );

    return TxDetailsData(tx: tx);
  }

  Future<TxGasDetailsData> addGas({
    required Transaction tx,
    bool amountAdjustment = true,
    bool eip1559Enabled = false,
    String rate = 'medium',
  }) async {
    connectionValidator();

    // Gas reset
    tx = Transaction(
      from: tx.from,
      to: tx.to,
      value: tx.value,
      data: tx.data,
      nonce: tx.nonce,
    );

    // Gas limit
    final BigInt gasLimit = await _web3.estimateGas(
      sender: tx.from,
      to: tx.to,
      data: tx.data,
    );

    final BigInt estimateGas;
    final BigInt maxFee;

    // Add gas as legacy or EIP1559
    if (eip1559Enabled) {
      final Map<String, EIP1559Information> gasEIP =
          await _web3.getGasInEIP1559();
      tx = tx.copyWith(
        maxGas: gasLimit.toInt(),
        maxFeePerGas: gasEIP[rate]!.maxFeePerGas,
        maxPriorityFeePerGas: gasEIP[rate]!.maxPriorityFeePerGas,
      );
      estimateGas = gasLimit * gasEIP[rate]!.estimatedGas;
      maxFee = gasLimit * tx.maxFeePerGas!.getInWei;
    } else {
      final EtherAmount gasPrice = await _web3.getGasPrice();
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
      final EtherAmount balance = await _web3.getBalance(tx.from!);
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

    return TxGasDetailsData(
      tx: tx,
      estimateGas: EtherAmount.inWei(estimateGas),
      maxFee: EtherAmount.inWei(maxFee),
      total: EtherAmount.inWei(total),
      maxAmount: EtherAmount.inWei(maxAmount),
    );
  }

  Future<String> sendTransaction({
    required Transaction tx,
    required EthPrivateKey credentials,
  }) {
    connectionValidator();
    return _web3.sendTransaction(
      credentials,
      tx,
      chainId: _networkData.chainID,
    );
  }

  Future<TransactionInformation?> getTransaction(String txHash) async {
    connectionValidator();
    return _web3.getTransactionByHash(txHash);
  }

  Future<TransactionReceipt?> getTransactionReceipt(
    String txHash,
  ) async {
    connectionValidator();
    return _web3.getTransactionReceipt(txHash);
  }

  String getExploreUrl(String address) {
    return [
      _networkData.explorer,
      address.length <= 42 ? 'address' : 'tx',
      address
    ].join('/');
  }

  static String fromBytesToHex(List<int> bytes) {
    return bytesToHex(bytes, include0x: true);
  }

  static Uint8List fromHexToBytes(String hex) {
    return hexToBytes(hex);
  }

  static BigInt fromBytesToInt(List<int> bytes) {
    return bytesToInt(bytes);
  }

  void connectionValidator() {
    if (_isConnected) return;

    throw SocketException(
      "Make sure you are connected to the internet and blockchain network.",
    );
  }
}
