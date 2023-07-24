import 'dart:typed_data';

import 'package:web3dart/crypto.dart';

/// Convert from bytes to hex format
String fromBytesToHex(List<int> bytes) {
  return bytesToHex(bytes, include0x: true);
}

/// Convert from hex to bytes format
Uint8List fromHexToBytes(String hex) {
  return hexToBytes(hex);
}

/// Convert from bytes to int format
BigInt fromBytesToInt(List<int> bytes) {
  return bytesToInt(bytes);
}
