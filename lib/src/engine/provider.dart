import 'dart:io';

import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

import '../models.dart';

/// Provider engine to access the web3 blockchain network
/// It's able to connect to multiple networks
class ProviderEngine {
  final Map<String, int> _blockTimeRPCs = {};
  late NetworkData _networkData;
  late Web3Client _web3;
  late bool _isConnected;

  /// The provider singleton instance
  static ProviderEngine instance = ProviderEngine();

  /// Get the network model
  NetworkData get networkData => _networkData;

  /// Web3 instance
  Web3Client get web3 => _web3;

  /// Connect with a RPC of blockchain network
  void connect(NetworkData network) {
    final http.Client httpClient = http.Client();
    _web3 = Web3Client(network.rpc, httpClient);
    _networkData = network;
  }

  /// Check the blockchain network connection
  Future<bool> isConnected() async {
    try {
      await _web3.getClientVersion();
      _isConnected = true;
    } catch (_) {
      _isConnected = false;
    }

    return _isConnected;
  }

  /// Check wallet balance for current blockchain network coin
  Future<EtherAmount> balanceOf({
    required EthereumAddress address,
    BlockNum? atBlock,
  }) {
    connectionValidator();
    return _web3.getBalance(address, atBlock: atBlock);
  }

  /// Get current block number
  Future<int> blockNumber() {
    connectionValidator();
    return _web3.getBlockNumber();
  }

  /// Check EIP1559 support for the current blockchain
  Future<bool> isSupportEIP1559() {
    connectionValidator();
    return _web3.getBlockInformation().then<bool>((v) => v.isSupportEIP1559);
  }

  /// Build a transaction to transfer the amount to another address
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

  /// Add the gas fee to the transaction already built
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

    // Build tx details
    return TxGasDetailsData(
      tx: tx,
      estimateGas: EtherAmount.inWei(estimateGas),
      maxFee: EtherAmount.inWei(maxFee),
      total: EtherAmount.inWei(total),
      maxAmount: EtherAmount.inWei(maxAmount),
    );
  }

  /// Send a transaction to be valid and recorded on the blockchain
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

  /// Get a transaction by hash
  Future<TransactionInformation?> getTransaction(String txHash) async {
    connectionValidator();
    return _web3.getTransactionByHash(txHash);
  }

  /// Get an receipt of a transaction by hash
  Future<TransactionReceipt?> getTransactionReceipt(String txHash) async {
    connectionValidator();
    return _web3.getTransactionReceipt(txHash);
  }

  /// Get the block time in seconds for the current blockchain
  /// It's can use a block number to calculate based on it
  Future<double> blockTimeInSeconds([int? blockNumber]) async {
    connectionValidator();

    blockNumber ??= await _web3.getBlockNumber();
    final List<int> times = [];
    int timestamp = 0;

    // Get the time difference between the last 5 blocks
    for (int i = 0; i < 5; i++) {
      final BlockInformation info = await _web3.getBlockInformation(
        blockNumber: BlockNum.exact(blockNumber - i).toBlockParam(),
      );
      times.add(timestamp - info.timestamp.millisecondsSinceEpoch);
      timestamp = info.timestamp.millisecondsSinceEpoch;
    }

    // Remove the first value, because it is a subtraction of 0
    times.removeAt(0);

    // Calculate the average time
    return (times.reduce((a, b) => a + b) / times.length) / 1000;
  }

  /// Get the estimated block time by a block number
  /// It's can use a block number and block time to calculate based on it
  Future<Map<int, DateTime>> estimatedBlockTime({
    required List<int> blockNumbers,
    int? currentBlock,
    DateTime? currentBlockTime,
  }) async {
    connectionValidator();

    currentBlock ??= await _web3.getBlockNumber();
    currentBlockTime ??= DateTime.now();
    final Map<int, DateTime> result = {};

    // Cache blockTime to be faster next time
    _blockTimeRPCs[networkData.rpc] ??=
        (await blockTimeInSeconds(currentBlock) * 1000).toInt();
    final int blockTime = _blockTimeRPCs[networkData.rpc]!;

    // Calc the estimated time
    for (final int blockNumber in blockNumbers) {
      final int blockCount = blockNumber - currentBlock;
      result[blockNumber] = DateTime.fromMillisecondsSinceEpoch(
        currentBlockTime.millisecondsSinceEpoch + (blockCount * blockTime),
      );
    }

    return result;
  }

  /// Get the explorer url for the current blockchain
  String getExploreUrl(String address) {
    return [
      _networkData.explorer,
      address.length <= 42 ? 'address' : 'tx',
      address
    ].join('/');
  }

  /// Check connection based on last state by 'isConnected' method
  void connectionValidator() {
    if (_isConnected) return;

    throw SocketException(
      "Make sure you are connected to the internet and blockchain network.",
    );
  }
}
