import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aescrypto/aescrypto.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetcher({
  required String apiURL,
  String? encryptionKey,
}) async {
  String result;

  try {
    final http.Response response = await http.get(Uri.parse(apiURL));
    result = response.body;
  } on SocketException {
    return [];
  }

  if (encryptionKey != null) {
    final AESCrypto cipher = AESCrypto(key: encryptionKey);
    result = await cipher.decryptText(
      bytes: Uint8List.fromList(jsonDecode(result).cast<int>()),
      hasKey: true,
    );
  }

  return jsonDecode(result);
}
