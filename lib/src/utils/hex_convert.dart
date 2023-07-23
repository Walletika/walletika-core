import 'dart:typed_data';

import 'package:web3dart/crypto.dart';

String fromBytesToHex(List<int> bytes) {
  return bytesToHex(bytes, include0x: true);
}

Uint8List fromHexToBytes(String hex) {
  return hexToBytes(hex);
}

BigInt fromBytesToInt(List<int> bytes) {
  return bytesToInt(bytes);
}
