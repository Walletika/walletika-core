import 'dart:convert';
import 'dart:typed_data';

import 'package:web3dart/web3dart.dart';

class WalletModel {
  WalletModel({
    required this.username,
    required this.address,
    required this.securityPassword,
    required this.dateCreated,
    required this.isFavorite,
  });

  final String username;
  final EthereumAddress address;
  final Uint8List securityPassword;
  final DateTime dateCreated;
  bool isFavorite;

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        username: json["username"],
        address: EthereumAddress.fromHex(json["address"]),
        securityPassword: Uint8List.fromList(
          List.from(jsonDecode(json["securityPassword"])),
        ),
        dateCreated: DateTime.parse(json["dateCreated"]),
        isFavorite: json["isFavorite"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "address": address.hexEip55,
        "securityPassword": jsonEncode(securityPassword),
        "dateCreated": dateCreated.toString(),
        "isFavorite": isFavorite,
      };
}

class AddressBookModel {
  AddressBookModel({
    required this.username,
    required this.address,
  });

  final String username;
  final EthereumAddress address;

  factory AddressBookModel.fromJson(Map<String, dynamic> json) =>
      AddressBookModel(
        username: json["username"],
        address: EthereumAddress.fromHex(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "address": address.hexEip55,
      };
}

class NetworkModel {
  NetworkModel({
    required this.rpc,
    required this.name,
    required this.chainID,
    required this.symbol,
    required this.explorer,
  });

  final String rpc;
  final String name;
  final int chainID;
  final String symbol;
  final String explorer;

  factory NetworkModel.fromJson(Map<String, dynamic> json) => NetworkModel(
        rpc: json["rpc"],
        name: json["name"],
        chainID: json["chainID"],
        symbol: json["symbol"],
        explorer: json["explorer"],
      );

  Map<String, dynamic> toJson() => {
        "rpc": rpc,
        "name": name,
        "chainID": chainID,
        "symbol": symbol,
        "explorer": explorer,
      };
}

class TransactionModel {
  TransactionModel({
    required this.txHash,
    required this.function,
    required this.fromAddress,
    required this.toAddress,
    required this.amount,
    required this.symbol,
    required this.dateCreated,
    required this.status,
  });

  final String txHash;
  final String function;
  final EthereumAddress fromAddress;
  final EthereumAddress toAddress;
  final EtherAmount amount;
  final String symbol;
  final DateTime dateCreated;
  int status;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        txHash: json["txHash"],
        function: json["function"],
        fromAddress: EthereumAddress.fromHex(json["fromAddress"]),
        toAddress: EthereumAddress.fromHex(json["toAddress"]),
        amount: EtherAmount.inWei(BigInt.parse(json["amount"])),
        symbol: json["symbol"],
        dateCreated: DateTime.parse(json["dateCreated"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "txHash": txHash,
        "function": function,
        "fromAddress": fromAddress.hexEip55,
        "toAddress": toAddress.hexEip55,
        "amount": amount.getInWei.toString(),
        "symbol": symbol,
        "dateCreated": dateCreated.toString(),
        "status": status,
      };
}

class TokenModel {
  TokenModel({
    required this.contract,
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.website,
  });

  final EthereumAddress contract;
  final String name;
  final String symbol;
  final int decimals;
  final String website;

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        contract: EthereumAddress.fromHex(json["contract"]),
        name: json["name"],
        symbol: json["symbol"],
        decimals: json["decimals"],
        website: json["website"],
      );

  Map<String, dynamic> toJson() => {
        "contract": contract.hexEip55,
        "name": name,
        "symbol": symbol,
        "decimals": decimals,
        "website": website,
      };
}

class StakeModel {
  StakeModel({
    required this.rpc,
    required this.contract,
    required this.stakeToken,
    required this.rewardToken,
    required this.startBlock,
    required this.endBlock,
    required this.startTime,
    required this.endTime,
  });

  final String rpc;
  final EthereumAddress contract;
  final TokenModel stakeToken;
  final TokenModel rewardToken;
  final int startBlock;
  final int endBlock;
  final DateTime startTime;
  final DateTime endTime;

  factory StakeModel.fromJson(Map<String, dynamic> json) => StakeModel(
        rpc: json["rpc"],
        contract: EthereumAddress.fromHex(json["contract"]),
        stakeToken: TokenModel.fromJson(json["stakeToken"]),
        rewardToken: TokenModel.fromJson(json["rewardToken"]),
        startBlock: json["startBlock"],
        endBlock: json["endBlock"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
      );

  Map<String, dynamic> toJson() => {
        "rpc": rpc,
        "contract": contract.hexEip55,
        "stakeToken": stakeToken.toJson(),
        "rewardToken": rewardToken.toJson(),
        "startBlock": startBlock,
        "endBlock": endBlock,
        "startTime": startTime.toString(),
        "endTime": endTime.toString(),
      };
}

class TxDetailsModel {
  TxDetailsModel({
    required this.tx,
    required this.abi,
    required this.args,
    required this.data,
  });

  final Transaction tx;
  final Map<String, dynamic> abi;
  final Map<String, dynamic> args;
  final String data;
}

class TxGasDetailsModel {
  TxGasDetailsModel({
    required this.tx,
    required this.estimateGas,
    required this.maxFee,
    required this.total,
    required this.maxAmount,
  });

  final Transaction tx;
  final EtherAmount estimateGas;
  final EtherAmount maxFee;
  final EtherAmount total;
  final EtherAmount maxAmount;
}
