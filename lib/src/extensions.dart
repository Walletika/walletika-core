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
