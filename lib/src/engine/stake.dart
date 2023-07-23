import 'package:aesdatabase/aesdatabase.dart';
import 'package:web3dart/web3dart.dart';

import '../abi/stake.dart';
import '../core/core.dart';
import '../models.dart';
import 'provider.dart';

Stream<StakeData> getAllStakes() async* {
  await for (final DBRow row in stakeDB.select(
    items: {
      DBKeys.rpc: ProviderEngine.instance.networkData.rpc,
    },
  )) {
    yield StakeData.fromJson(row.items);
  }
}

class StakeEngine extends ContractEngine {
  final StakeData stakeData;

  StakeEngine({required this.stakeData, super.sender})
      : super(
          address: stakeData.contract,
          abi: stakeABI,
          name: 'stakeContract',
        );

  Future<EthereumAddress> owner({BlockNum? atBlock}) {
    return functionCall(
      function: 'owner',
      atBlock: atBlock,
    ).then<EthereumAddress>(
      (response) => response.first,
    );
  }

  Future<EthereumAddress> smartChefFactory({BlockNum? atBlock}) {
    return functionCall(
      function: 'SMART_CHEF_FACTORY',
      atBlock: atBlock,
    ).then<EthereumAddress>(
      (response) => response.first,
    );
  }

  Future<bool> hasUserLimit({BlockNum? atBlock}) {
    return functionCall(
      function: 'hasUserLimit',
      atBlock: atBlock,
    ).then<bool>(
      (response) => response.first,
    );
  }

  Future<bool> lockedToEnd({BlockNum? atBlock}) {
    return functionCall(
      function: 'lockedToEnd',
      atBlock: atBlock,
    ).then<bool>(
      (response) => response.first,
    );
  }

  Future<bool> isInitialized({BlockNum? atBlock}) {
    return functionCall(
      function: 'isInitialized',
      atBlock: atBlock,
    ).then<bool>(
      (response) => response.first,
    );
  }

  Future<bool> paused({BlockNum? atBlock}) {
    return functionCall(
      function: 'paused',
      atBlock: atBlock,
    ).then<bool>(
      (response) => response.first,
    );
  }

  Future<DateTime> lastPauseTime({BlockNum? atBlock}) {
    return functionCall(
      function: 'lastPauseTime',
      atBlock: atBlock,
    ).then<DateTime>(
      (response) => DateTime.fromMillisecondsSinceEpoch(
        (response.first as BigInt).toInt(),
      ),
    );
  }

  Future<EtherAmount> accTokenPerShare({BlockNum? atBlock}) {
    return functionCall(
      function: 'accTokenPerShare',
      atBlock: atBlock,
    ).then<EtherAmount>(
      (response) => EtherAmount.inWei(response.first),
    );
  }

  Future<int> startBlock({BlockNum? atBlock}) {
    return functionCall(
      function: 'startBlock',
      atBlock: atBlock,
    ).then<int>(
      (response) => (response.first as BigInt).toInt(),
    );
  }

  Future<int> bonusEndBlock({BlockNum? atBlock}) {
    return functionCall(
      function: 'bonusEndBlock',
      atBlock: atBlock,
    ).then<int>(
      (response) => (response.first as BigInt).toInt(),
    );
  }

  Future<int> lastRewardBlock({BlockNum? atBlock}) {
    return functionCall(
      function: 'lastRewardBlock',
      atBlock: atBlock,
    ).then<int>(
      (response) => (response.first as BigInt).toInt(),
    );
  }

  Future<EtherAmount> poolLimitPerUser({BlockNum? atBlock}) {
    return functionCall(
      function: 'poolLimitPerUser',
      atBlock: atBlock,
    ).then<EtherAmount>(
      (response) => EtherAmount.inWei(response.first),
    );
  }

  Future<EtherAmount> rewardPerBlock({BlockNum? atBlock}) {
    return functionCall(
      function: 'rewardPerBlock',
      atBlock: atBlock,
    ).then<EtherAmount>(
      (response) => EtherAmount.inWei(response.first),
    );
  }

  Future<EtherAmount> precisionFactor({BlockNum? atBlock}) {
    return functionCall(
      function: 'PRECISION_FACTOR',
      atBlock: atBlock,
    ).then<EtherAmount>(
      (response) => EtherAmount.inWei(response.first),
    );
  }

  Future<EthereumAddress> rewardToken({BlockNum? atBlock}) {
    return functionCall(
      function: 'rewardToken',
      atBlock: atBlock,
    ).then<EthereumAddress>(
      (response) => response.first,
    );
  }

  Future<EthereumAddress> stakedToken({BlockNum? atBlock}) {
    return functionCall(
      function: 'stakedToken',
      atBlock: atBlock,
    ).then<EthereumAddress>(
      (response) => response.first,
    );
  }

  Future<EtherAmount> totalSupply({BlockNum? atBlock}) {
    return functionCall(
      function: 'totalSupply',
      atBlock: atBlock,
    ).then<EtherAmount>(
      (response) => EtherAmount.inWei(response.first),
    );
  }

  Future<EtherAmount> rewardSupply({BlockNum? atBlock}) {
    return functionCall(
      function: 'rewardSupply',
      atBlock: atBlock,
    ).then<EtherAmount>(
      (response) => EtherAmount.inWei(response.first),
    );
  }

  Future<EtherAmount> balanceOf({
    required EthereumAddress address,
    BlockNum? atBlock,
  }) {
    return functionCall(
      function: 'balanceOf',
      params: [address],
      atBlock: atBlock,
    ).then<EtherAmount>(
      (response) => EtherAmount.inWei(response.first),
    );
  }

  Future<EtherAmount> pendingReward({
    required EthereumAddress address,
    BlockNum? atBlock,
  }) {
    return functionCall(
      function: 'pendingReward',
      params: [address],
      atBlock: atBlock,
    ).then<EtherAmount>(
      (response) => EtherAmount.inWei(response.first),
    );
  }

  Future<TxDetailsData> initialize({
    required EthereumAddress stakedToken,
    required EthereumAddress rewardToken,
    required EtherAmount rewardPerBlock,
    required int startBlock,
    required int bonusEndBlock,
    required EtherAmount poolLimitPerUser,
    required bool lockedToEnd,
    required EthereumAddress admin,
  }) {
    return buildTransaction(
      function: 'initialize',
      params: [
        stakedToken,
        rewardToken,
        rewardPerBlock.getInWei,
        startBlock,
        bonusEndBlock,
        poolLimitPerUser.getInEther,
        lockedToEnd,
        admin,
      ],
    );
  }

  Future<TxDetailsData> deposit({required EtherAmount amount}) {
    return buildTransaction(
      function: 'deposit',
      params: [amount.getInWei],
    );
  }

  Future<TxDetailsData> withdraw({required EtherAmount amount}) {
    return buildTransaction(
      function: 'withdraw',
      params: [amount.getInWei],
    );
  }

  Future<TxDetailsData> getReward() {
    return buildTransaction(
      function: 'getReward',
    );
  }

  Future<TxDetailsData> emergencyRewardWithdraw({
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'emergencyRewardWithdraw',
      params: [amount.getInWei],
    );
  }

  Future<TxDetailsData> recoverWrongTokens({
    required EthereumAddress token,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'recoverWrongTokens',
      params: [token, amount.getInWei],
    );
  }

  Future<TxDetailsData> stopReward() {
    return buildTransaction(
      function: 'stopReward',
    );
  }

  Future<TxDetailsData> setPaused({required bool paused}) {
    return buildTransaction(
      function: 'setPaused',
      params: [paused],
    );
  }

  Future<TxDetailsData> updatePoolLimitPerUser({
    required bool hasUserLimit,
    required EtherAmount poolLimitPerUser,
  }) {
    return buildTransaction(
      function: 'updatePoolLimitPerUser',
      params: [hasUserLimit, poolLimitPerUser.getInWei],
    );
  }

  Future<TxDetailsData> updateRewardPerBlock({required EtherAmount amount}) {
    return buildTransaction(
      function: 'updateRewardPerBlock',
      params: [amount.getInWei],
    );
  }

  Future<TxDetailsData> updateStartAndEndBlocks({
    required int startBlock,
    required int bonusEndBlock,
  }) {
    return buildTransaction(
      function: 'updateStartAndEndBlocks',
      params: [startBlock, bonusEndBlock],
    );
  }

  Future<TxDetailsData> renounceOwnership() {
    return buildTransaction(
      function: 'renounceOwnership',
    );
  }

  Future<TxDetailsData> transferOwnership({
    required EthereumAddress newOwner,
  }) {
    return buildTransaction(
      function: 'transferOwnership',
      params: [newOwner],
    );
  }
}
