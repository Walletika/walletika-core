import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>> fetcher(String apiURL) async {
  try {
    http.Response response = await http.get(Uri.parse(apiURL));
    return jsonDecode(response.body);
  } catch (e) {
    return [];
  }
}
