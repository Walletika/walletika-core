import 'dart:convert';
import 'dart:typed_data';

import 'package:web3dart/web3dart.dart';

import 'core/core.dart';

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
        username: json[DBKeys.username],
        address: EthereumAddress.fromHex(json[DBKeys.address]),
        securityPassword: Uint8List.fromList(
          List.from(jsonDecode(json[DBKeys.securityPassword])),
        ),
        dateCreated: DateTime.parse(json[DBKeys.dateCreated]),
        isFavorite: json[DBKeys.isFavorite],
      );

  Map<String, dynamic> toJson() => {
        DBKeys.username: username,
        DBKeys.address: address.hexEip55,
        DBKeys.securityPassword: jsonEncode(securityPassword),
        DBKeys.dateCreated: dateCreated.toString(),
        DBKeys.isFavorite: isFavorite,
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
        username: json[DBKeys.username],
        address: EthereumAddress.fromHex(json[DBKeys.address]),
      );

  Map<String, dynamic> toJson() => {
        DBKeys.username: username,
        DBKeys.address: address.hexEip55,
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
        rpc: json[DBKeys.rpc],
        name: json[DBKeys.name],
        chainID: json[DBKeys.chainID],
        symbol: json[DBKeys.symbol],
        explorer: json[DBKeys.explorer],
      );

  Map<String, dynamic> toJson() => {
        DBKeys.rpc: rpc,
        DBKeys.name: name,
        DBKeys.chainID: chainID,
        DBKeys.symbol: symbol,
        DBKeys.explorer: explorer,
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
        txHash: json[DBKeys.txHash],
        function: json[DBKeys.function],
        fromAddress: EthereumAddress.fromHex(json[DBKeys.fromAddress]),
        toAddress: EthereumAddress.fromHex(json[DBKeys.toAddress]),
        amount: EtherAmount.inWei(BigInt.parse(json[DBKeys.amount])),
        symbol: json[DBKeys.symbol],
        dateCreated: DateTime.parse(json[DBKeys.dateCreated]),
        status: json[DBKeys.status],
      );

  Map<String, dynamic> toJson() => {
        DBKeys.txHash: txHash,
        DBKeys.function: function,
        DBKeys.fromAddress: fromAddress.hexEip55,
        DBKeys.toAddress: toAddress.hexEip55,
        DBKeys.amount: amount.getInWei.toString(),
        DBKeys.symbol: symbol,
        DBKeys.dateCreated: dateCreated.toString(),
        DBKeys.status: status,
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
        contract: EthereumAddress.fromHex(json[DBKeys.contract]),
        name: json[DBKeys.name],
        symbol: json[DBKeys.symbol],
        decimals: json[DBKeys.decimals],
        website: json[DBKeys.website],
      );

  Map<String, dynamic> toJson() => {
        DBKeys.contract: contract.hexEip55,
        DBKeys.name: name,
        DBKeys.symbol: symbol,
        DBKeys.decimals: decimals,
        DBKeys.website: website,
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
        rpc: json[DBKeys.rpc],
        contract: EthereumAddress.fromHex(json[DBKeys.contract]),
        stakeToken: TokenModel.fromJson(json[DBKeys.stakeToken]),
        rewardToken: TokenModel.fromJson(json[DBKeys.rewardToken]),
        startBlock: json[DBKeys.startBlock],
        endBlock: json[DBKeys.endBlock],
        startTime: DateTime.parse(json[DBKeys.startTime]),
        endTime: DateTime.parse(json[DBKeys.endTime]),
      );

  Map<String, dynamic> toJson() => {
        DBKeys.rpc: rpc,
        DBKeys.contract: contract.hexEip55,
        DBKeys.stakeToken: stakeToken.toJson(),
        DBKeys.rewardToken: rewardToken.toJson(),
        DBKeys.startBlock: startBlock,
        DBKeys.endBlock: endBlock,
        DBKeys.startTime: startTime.toString(),
        DBKeys.endTime: endTime.toString(),
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
