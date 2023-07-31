const int yearInSec = 86400 * 365;

double aprCalculator({
  required DateTime startTime,
  required DateTime endTime,
  required int currentBlock,
  required int startBlock,
  required int endBlock,
  required double rewardPerBlock,
  required double totalStaked,
  required double? rewardTokenPrice,
  required double? stakeTokenPrice,
}) {
  double result = 0;

  if (endBlock > currentBlock &&
      rewardPerBlock != 0 &&
      totalStaked != 0 &&
      rewardTokenPrice != null &&
      stakeTokenPrice != null) {
    final int stakePeriod = endTime.difference(startTime).inSeconds;
    final int blocks = endBlock - startBlock;
    final double reward = (rewardPerBlock * rewardTokenPrice) * blocks;
    final double interest = (reward / (totalStaked * stakeTokenPrice)) * 100;
    result = (yearInSec / stakePeriod) * interest;
  }

  return result;
}
