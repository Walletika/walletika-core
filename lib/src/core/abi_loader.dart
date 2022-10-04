import 'dart:io';

import 'package:path/path.dart' as pathlib;

final String _tokenABIPath = pathlib.join('lib', 'src', 'abi', 'token.json');
final String _stakeABIPath = pathlib.join('lib', 'src', 'abi', 'stake.json');
final String _wnsABIPath = pathlib.join('lib', 'src', 'abi', 'wns.json');

String tokenABI = File(_tokenABIPath).readAsStringSync();
String stakeABI = File(_stakeABIPath).readAsStringSync();
String wnsABI = File(_wnsABIPath).readAsStringSync();
