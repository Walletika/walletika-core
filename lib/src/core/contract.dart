import 'dart:typed_data';

import 'package:web3dart/web3dart.dart';

import '../engine/provider.dart';
import '../models.dart';

class ContractEngine {
  final EthereumAddress? sender;
  late DeployedContract _contract;

  ContractEngine({
    required EthereumAddress address,
    required String abi,
    required String name,
    this.sender,
  }) {
    _contract = DeployedContract(ContractAbi.fromJson(abi, name), address);
  }

  Future<List<dynamic>> functionCall({
    EthereumAddress? sender,
    required String function,
    List<dynamic>? params,
    BlockNum? atBlock,
  }) async {
    ProviderEngine.instance.connectionValidator();

    final ContractFunction func = _contract.function(function);
    final String encodedResult = await ProviderEngine.instance.web3.callRaw(
      sender: sender,
      contract: _contract.address,
      data: func.encodeCall(params ?? []),
      atBlock: atBlock,
    );

    return func.decodeReturnValues(encodedResult);
  }

  Future<TxDetailsData> buildTransaction({
    required String function,
    List<dynamic>? params,
  }) async {
    ProviderEngine.instance.connectionValidator();

    // Function Caller
    final ContractFunction func = _contract.function(function);

    // Build ABI
    final Map<String, dynamic> abi = {
      "inputs": func.parameters.map((e) {
        return {
          "internalType": e.type.name,
          "name": e.name,
          "type": e.type.name,
        };
      }).toList(),
      "name": func.name,
      "outputs": func.outputs.map((e) {
        return {
          "internalType": e.type.name,
          "name": e.name,
          "type": e.type.name,
        };
      }).toList(),
      "stateMutability": func.mutability.name,
      "type": func.type.name,
    };

    // Build Arguments
    final Map<String, dynamic> args = {};
    for (int index = 0; index < func.parameters.length; index++) {
      final String name = func.parameters[index].name;
      final String type = func.parameters[index].type.name;
      final dynamic value = params![index];

      switch (type) {
        case 'address':
          args[name] = value.hexEip55;
          break;
        case 'uint256':
          args[name] = value.toString();
          break;
        case 'address[]':
          args[name] = value.map((e) => e.hexEip55).toList();
          break;
        case 'uint256[]':
          args[name] = value.map((e) => e.toString()).toList();
          break;
        default:
          args[name] = value;
      }
    }

    // Build Transaction
    final Uint8List data = func.encodeCall(params ?? []);
    final Transaction tx = Transaction(
      from: sender,
      to: _contract.address,
      value: EtherAmount.zero(),
      data: data,
      nonce: await ProviderEngine.instance.web3.getTransactionCount(sender!),
    );

    return TxDetailsData(
      tx: tx,
      abi: abi,
      args: args,
    );
  }
}
