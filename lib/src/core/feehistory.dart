// Add this method into >> web3dart-2.4.1\lib\src\core\client.dart

  // Future<Map<String, dynamic>> getFeeHistory(
  //   int blockCount, {
  //   BlockNum? atBlock,
  //   List<double>? rewardPercentiles,
  // }) {
  //   final blockParam = _getBlockParam(atBlock);

  //   return _makeRPCCall<Map<String, dynamic>>(
  //     'eth_feeHistory',
  //     [blockCount, blockParam, rewardPercentiles],
  //   ).then((history) {
  //     return history.map((key, value) {
  //       if (key == 'baseFeePerGas') {
  //         value = value.map((e) => hexToInt(e)).toList();
  //       } else if (key == 'reward') {
  //         value = value
  //             .map(
  //               (eList) => eList.map((e) => hexToInt(e)).toList(),
  //             )
  //             .toList();
  //       } else if (key == 'oldestBlock') {
  //         value = hexToInt(value);
  //       }
  //       return MapEntry(key, value);
  //     });
  //   });
  // }


// Add this into >> lib/src/engine/provider.dart
  // static Future<List<Map<String, dynamic>>> _feeHistory() {
  //   return Future(() async {
  //     List<Map<String, dynamic>> result = [];
  //     int historicalBlocks = 10;

  //     Map<String, dynamic> feeHistory = await web3.getFeeHistory(
  //       historicalBlocks,
  //       atBlock: BlockNum.pending(),
  //       rewardPercentiles: [25, 50, 75],
  //     );

  //     for (int i = 0; i < historicalBlocks; i++) {
  //       result.add({
  //         "blockNumber": feeHistory["oldestBlock"] + BigInt.from(i),
  //         "baseFeePerGas": feeHistory["baseFeePerGas"][i],
  //         "gasUsedRatio": feeHistory["gasUsedRatio"][i],
  //         "priorityFeePerGas": feeHistory["reward"][i],
  //       });
  //     }

  //     return result;
  //   });
  // }

  // static Future<Map<String, Map<String, BigInt>>> _estimateGasEIP1559() {
  //   return Future(() async {
  //     Map<String, Map<String, BigInt>> result = {
  //       "slow": {},
  //       "medium": {},
  //       "fast": {},
  //     };

  //     List<Map<String, dynamic>> history = await _feeHistory();
  //     BlockInformation latestBlock = await web3.getBlockInformation(
  //       blockNumber: BlockNum.pending().toString(),
  //     );
  //     BigInt baseFee = latestBlock.baseFeePerGas!.getInWei;

  //     for (int index = 0; index < result.length; index++) {
  //       List<BigInt> allPriorityFee = history.map<BigInt>((e) {
  //         return e["priorityFeePerGas"][index];
  //       }).toList();
  //       BigInt priorityFee = allPriorityFee.max;
  //       BigInt estimatedGas = BigInt.from(
  //         0.9 * baseFee.toDouble() + priorityFee.toDouble(),
  //       );
  //       BigInt maxFee = BigInt.from(1.5 * estimatedGas.toDouble());

  //       if (priorityFee >= maxFee || priorityFee <= BigInt.zero) {
  //         throw Exception("Max fee must exceed the priority fee");
  //       }

  //       result.update(
  //         result.keys.toList()[index],
  //         (value) => {
  //           "maxPriorityFeePerGas": priorityFee,
  //           "estimatedGas": estimatedGas,
  //           "maxFeePerGas": maxFee,
  //         },
  //       );
  //     }

  //     return result;
  //   });
  // }