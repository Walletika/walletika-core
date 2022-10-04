import 'dart:typed_data';

import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import '../engine/provider.dart';
import '../models.dart';

class ContractEngine {
  final EthereumAddress? sender;
  late DeployedContract contract;

  ContractEngine({
    required EthereumAddress address,
    required String abi,
    required String name,
    this.sender,
  }) {
    contract = DeployedContract(ContractAbi.fromJson(abi, name), address);
  }

  Future<List<dynamic>> functionCall({
    EthereumAddress? sender,
    required String function,
    List<dynamic>? params,
    BlockNum? atBlock,
  }) {
    return Future(() async {
      ContractFunction func = contract.function(function);
      String encodedResult = await Provider.web3.callRaw(
        sender: sender,
        contract: contract.address,
        data: func.encodeCall(params ?? []),
        atBlock: atBlock,
      );

      return func.decodeReturnValues(encodedResult);
    });
  }

  Future<TxDetailsModel> buildTransaction({
    required String function,
    List<dynamic>? params,
  }) {
    return Future(() async {
      // Function Caller
      ContractFunction func = contract.function(function);

      // Build ABI
      Map<String, dynamic> abi = {
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
      Map<String, dynamic> args = {};
      for (int index = 0; index < func.parameters.length; index++) {
        String name = func.parameters[index].name;
        String type = func.parameters[index].type.name;
        dynamic value = params![index];

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
      Uint8List data = func.encodeCall(params ?? []);
      Transaction tx = Transaction(
        from: sender,
        to: contract.address,
        value: EtherAmount.zero(),
        data: data,
        nonce: await Provider.web3.getTransactionCount(sender!),
      );

      return TxDetailsModel(
        tx: tx,
        abi: abi,
        args: args,
        data: bytesToHex(data, include0x: true),
      );
    });
  }
}
