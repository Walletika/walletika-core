import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

extension TransactionExtension on Transaction {
  Map<String, dynamic> toJson() {
    return {
      'from': from?.hexEip55,
      'to': to?.hexEip55,
      'maxGas': maxGas,
      'gasPrice': gasPrice?.getInWei.toString(),
      'value': value?.getInWei.toString(),
      'data': data == null ? null : bytesToHex(data!, include0x: true),
      'nonce': nonce,
      'maxFeePerGas': maxFeePerGas?.getInWei.toString(),
      'maxPriorityFeePerGas': maxPriorityFeePerGas?.getInWei.toString(),
    };
  }
}

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
    data: data == null ? null : hexToBytes(data),
    nonce: nonce,
    maxFeePerGas: maxFeePerGas == null
        ? null
        : EtherAmount.inWei(BigInt.parse(maxFeePerGas)),
    maxPriorityFeePerGas: maxPriorityFeePerGas == null
        ? null
        : EtherAmount.inWei(BigInt.parse(maxPriorityFeePerGas)),
  );
}
