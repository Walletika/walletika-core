import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

extension TransactionExtension on Transaction {
  Map<String, dynamic> toJson() {
    return {
      'from': from?.hexEip55,
      'to': to?.hexEip55,
      'maxGas': maxGas,
      'gasPrice': gasPrice?.getInWei,
      'value': value?.getInWei,
      'data': data == null ? null : bytesToHex(data!, include0x: true),
      'nonce': nonce,
      'maxFeePerGas': maxFeePerGas?.getInWei,
      'maxPriorityFeePerGas': maxPriorityFeePerGas?.getInWei,
    };
  }
}
