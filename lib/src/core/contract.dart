import 'dart:typed_data';

import 'package:web3dart/web3dart.dart';

import '../engine/provider.dart';
import '../models.dart';

/// Contract engine to call the smart contract APIs
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

  /// Call the smart contract API function to read the data
  Future<List<dynamic>> functionCall({
    EthereumAddress? sender,
    required String function,
    List<dynamic>? params,
    BlockNum? atBlock,
  }) async {
    ProviderEngine.instance.connectionValidator();

    // A function defined in the ABI of an compiled contract
    final ContractFunction func = _contract.function(function);

    // Call the function by ProviderEngine
    final String response = await ProviderEngine.instance.web3.callRaw(
      sender: sender,
      contract: _contract.address,
      data: func.encodeCall(params ?? []),
      atBlock: atBlock,
    );

    // Decode response data
    return func.decodeReturnValues(response);
  }

  /// Call the smart contract API function to build a transaction
  Future<TxDetailsData> buildTransaction({
    required String function,
    List<dynamic>? params,
  }) async {
    ProviderEngine.instance.connectionValidator();

    // A function defined in the ABI of an compiled contract
    final ContractFunction func = _contract.function(function);

    // Build the ABI
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

    // Build arguments
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
