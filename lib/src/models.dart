import 'dart:convert';
import 'dart:typed_data';

import 'package:web3dart/web3dart.dart';

import 'core/core.dart';

/// Wallet types to determine which wallet model works
enum WalletType { login, fingerprint, faceID, privateKey }

class WalletData {
  WalletData({
    required this.type,
    required this.username,
    required this.address,
    required this.securityPassword,
    required this.dateCreated,
    required this.isFavorite,
  });

  final WalletType type;
  final String username;
  final EthereumAddress address;
  final Uint8List securityPassword;
  final DateTime dateCreated;
  bool isFavorite;

  factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
        type: WalletType.values[json[DBKeys.type]],
        username: json[DBKeys.username],
        address: EthereumAddress.fromHex(json[DBKeys.address]),
        securityPassword: Uint8List.fromList(
          List.from(jsonDecode(json[DBKeys.securityPassword])),
        ),
        dateCreated: DateTime.parse(json[DBKeys.dateCreated]),
        isFavorite: json[DBKeys.isFavorite],
      );

  Map<String, dynamic> toJson() => {
        DBKeys.type: type.index,
        DBKeys.username: username,
        DBKeys.address: address.hexEip55,
        DBKeys.securityPassword: jsonEncode(securityPassword),
        DBKeys.dateCreated: dateCreated.toString(),
        DBKeys.isFavorite: isFavorite,
      };
}

class AddressBookData {
  AddressBookData({
    required this.username,
    required this.address,
    required this.dateCreated,
    required this.salt,
  });

  final String username;
  final EthereumAddress address;
  final DateTime dateCreated;
  final String salt;

  factory AddressBookData.fromJson(Map<String, dynamic> json) =>
      AddressBookData(
        username: json[DBKeys.username],
        address: EthereumAddress.fromHex(json[DBKeys.address]),
        dateCreated: DateTime.parse(json[DBKeys.dateCreated]),
        salt: json[DBKeys.salt],
      );

  Map<String, dynamic> toJson() => {
        DBKeys.username: username,
        DBKeys.address: address.hexEip55,
        DBKeys.dateCreated: dateCreated.toString(),
        DBKeys.salt: salt,
      };
}

class NetworkData {
  NetworkData({
    required this.rpc,
    required this.name,
    required this.chainID,
    required this.symbol,
    required this.explorer,
    required this.isLocked,
    this.image,
  });

  final String rpc;
  final String name;
  final int chainID;
  final String symbol;
  final String explorer;
  final bool isLocked;
  final String? image;

  factory NetworkData.fromJson(Map<String, dynamic> json) => NetworkData(
        rpc: json[DBKeys.rpc],
        name: json[DBKeys.name],
        chainID: json[DBKeys.chainID],
        symbol: json[DBKeys.symbol],
        explorer: json[DBKeys.explorer],
        isLocked: json[DBKeys.isLocked],
        image: (json[DBKeys.image] ?? '').isEmpty ? null : json[DBKeys.image],
      );

  Map<String, dynamic> toJson() => {
        DBKeys.rpc: rpc,
        DBKeys.name: name,
        DBKeys.chainID: chainID,
        DBKeys.symbol: symbol,
        DBKeys.explorer: explorer,
        DBKeys.isLocked: isLocked,
        DBKeys.image: image ?? '',
      };
}

class TransactionData {
  TransactionData({
    required this.txHash,
    required this.function,
    required this.fromAddress,
    required this.toAddress,
    required this.amount,
    required this.symbol,
    required this.decimals,
    required this.dateCreated,
    required this.status,
  });

  final String txHash;
  final String function;
  final EthereumAddress fromAddress;
  final EthereumAddress toAddress;
  final EtherAmount amount;
  final String symbol;
  final int decimals;
  final DateTime dateCreated;
  int status;

  static const int pendingStatus = -1;
  static const int failedStatus = 0;
  static const int successStatus = 1;

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      TransactionData(
        txHash: json[DBKeys.txHash],
        function: json[DBKeys.function],
        fromAddress: EthereumAddress.fromHex(json[DBKeys.fromAddress]),
        toAddress: EthereumAddress.fromHex(json[DBKeys.toAddress]),
        amount: EtherAmount.inWei(BigInt.parse(json[DBKeys.amount])),
        symbol: json[DBKeys.symbol],
        decimals: json[DBKeys.decimals],
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
        DBKeys.decimals: decimals,
        DBKeys.dateCreated: dateCreated.toString(),
        DBKeys.status: status,
      };
}

class TokenData {
  TokenData({
    required this.contract,
    required this.name,
    required this.symbol,
    required this.decimals,
    this.website,
  });

  final EthereumAddress contract;
  final String name;
  final String symbol;
  final int decimals;
  final String? website;

  factory TokenData.fromJson(Map<String, dynamic> json) => TokenData(
        contract: EthereumAddress.fromHex(json[DBKeys.contract]),
        name: json[DBKeys.name],
        symbol: json[DBKeys.symbol],
        decimals: json[DBKeys.decimals],
        website:
            (json[DBKeys.website] ?? '').isEmpty ? null : json[DBKeys.website],
      );

  Map<String, dynamic> toJson() => {
        DBKeys.contract: contract.hexEip55,
        DBKeys.name: name,
        DBKeys.symbol: symbol,
        DBKeys.decimals: decimals,
        DBKeys.website: website ?? '',
      };
}

class StakeData {
  StakeData({
    required this.contract,
    required this.stakeToken,
    required this.rewardToken,
    required this.startBlock,
    required this.endBlock,
    required this.isLocked,
  });

  final EthereumAddress contract;
  final TokenData stakeToken;
  final TokenData rewardToken;
  final int startBlock;
  final int endBlock;
  final bool isLocked;

  factory StakeData.fromJson(Map<String, dynamic> json) => StakeData(
        contract: EthereumAddress.fromHex(json[DBKeys.contract]),
        stakeToken: TokenData.fromJson(json[DBKeys.stakeToken]),
        rewardToken: TokenData.fromJson(json[DBKeys.rewardToken]),
        startBlock: json[DBKeys.startBlock],
        endBlock: json[DBKeys.endBlock],
        isLocked: json[DBKeys.isLocked],
      );

  Map<String, dynamic> toJson() => {
        DBKeys.contract: contract.hexEip55,
        DBKeys.stakeToken: stakeToken.toJson(),
        DBKeys.rewardToken: rewardToken.toJson(),
        DBKeys.startBlock: startBlock,
        DBKeys.endBlock: endBlock,
        DBKeys.isLocked: isLocked,
      };
}

class TxDetailsData {
  TxDetailsData({
    required this.tx,
    this.abi,
    this.args,
  });

  final Transaction tx;
  final Map<String, dynamic>? abi;
  final Map<String, dynamic>? args;
}

class TxGasDetailsData {
  TxGasDetailsData({
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
