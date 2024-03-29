import 'package:web3dart/web3dart.dart';

import 'utils/hex_convert.dart';

extension TransactionExtension on Transaction {
  // Transaction extension not support `factory` tag
  // Use `createTransactionFromJson` to create from json

  /// Convert from `Transaction` object to json format
  Map<String, dynamic> toJson() => {
        'from': from?.hexEip55,
        'to': to?.hexEip55,
        'maxGas': maxGas,
        'gasPrice': gasPrice?.getInWei.toString(),
        'value': value?.getInWei.toString(),
        'data': data == null ? null : fromBytesToHex(data!),
        'nonce': nonce,
        'maxFeePerGas': maxFeePerGas?.getInWei.toString(),
        'maxPriorityFeePerGas': maxPriorityFeePerGas?.getInWei.toString(),
      };
}

/// Convert from json format to `Transaction` object
Transaction createTransactionFromJson(Map<String, dynamic> json) {
  final String? from = json['from'];
  final String? to = json['to'];
  final int? maxGas = json['maxGas'];
  final String? gasPrice = json['gasPrice'];
  final String? value = json['value'];
  final String? data = json['data'];
  final int? nonce = json['nonce'];
  final String? maxFeePerGas = json['maxFeePerGas'];
  final String? maxPriorityFeePerGas = json['maxPriorityFeePerGas'];

  return Transaction(
    from: from == null ? null : EthereumAddress.fromHex(from),
    to: to == null ? null : EthereumAddress.fromHex(to),
    maxGas: maxGas,
    gasPrice:
        gasPrice == null ? null : EtherAmount.inWei(BigInt.parse(gasPrice)),
    value: value == null ? null : EtherAmount.inWei(BigInt.parse(value)),
    data: data == null ? null : fromHexToBytes(data),
    nonce: nonce,
    maxFeePerGas: maxFeePerGas == null
        ? null
        : EtherAmount.inWei(BigInt.parse(maxFeePerGas)),
    maxPriorityFeePerGas: maxPriorityFeePerGas == null
        ? null
        : EtherAmount.inWei(BigInt.parse(maxPriorityFeePerGas)),
  );
}
