import 'package:aesdatabase/aesdatabase.dart';
import 'package:web3dart/web3dart.dart';

import '../abi/token.dart';
import '../core/core.dart';
import '../models.dart';
import 'provider.dart';

/// Get all tokens from database
Future<List<TokenData>> getAllTokens() {
  return tokensDB
      .select(items: {
        DBKeys.rpc: ProviderEngine.instance.networkData.rpc,
      })
      .map((row) => TokenData.fromJson(row.items))
      .toList();
}

/// Add a new token to database
Future<void> addNewToken(TokenData token) async {
  tokensDB.addRow({
    DBKeys.rpc: ProviderEngine.instance.networkData.rpc,
    ...token.toJson(),
  });

  await tokensDB.dump();
}

/// Remove a token from database
Future<bool> removeToken(TokenData token) async {
  bool isValid = false;

  await for (final DBRow row in tokensDB.select(
    items: {
      DBKeys.rpc: ProviderEngine.instance.networkData.rpc,
      ...token.toJson(),
    },
  )) {
    tokensDB.removeRow(row.index);
    await tokensDB.dump();
    isValid = true;
    break;
  }

  return isValid;
}

/// Token engine to access the token smart contract
class TokenEngine extends ContractEngine {
  final TokenData tokenData;

  TokenEngine({required this.tokenData, super.sender})
      : super(
          address: tokenData.contract,
          abi: tokenABI,
          name: 'tokenERC20',
        );

  Future<String> name({BlockNum? atBlock}) {
    return functionCall(
      function: 'name',
      atBlock: atBlock,
    ).then<String>(
      (response) => response.first,
    );
  }

  Future<String> symbol({BlockNum? atBlock}) {
    return functionCall(
      function: 'symbol',
      atBlock: atBlock,
    ).then<String>(
      (response) => response.first,
    );
  }

  Future<int> decimals({BlockNum? atBlock}) {
    return functionCall(
      function: 'decimals',
      atBlock: atBlock,
    ).then<int>(
      (response) => (response.first as BigInt).toInt(),
    );
  }

  Future<EtherAmount> totalSupply({BlockNum? atBlock}) {
    return functionCall(
      function: 'totalSupply',
      atBlock: atBlock,
    ).then<EtherAmount>(
      (response) => EtherAmount.inWei(response.first),
    );
  }

  Future<EtherAmount> balanceOf({
    required EthereumAddress address,
    BlockNum? atBlock,
  }) {
    return functionCall(
      function: 'balanceOf',
      params: [address],
      atBlock: atBlock,
    ).then<EtherAmount>(
      (response) => EtherAmount.inWei(response.first),
    );
  }

  Future<EtherAmount> allowance({
    required EthereumAddress owner,
    required EthereumAddress spender,
    BlockNum? atBlock,
  }) {
    return functionCall(
      function: 'allowance',
      params: [owner, spender],
      atBlock: atBlock,
    ).then<EtherAmount>(
      (response) => EtherAmount.inWei(response.first),
    );
  }

  Future<TxDetailsData> approve({
    required EthereumAddress spender,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'approve',
      params: [spender, amount.getInWei],
    );
  }

  Future<TxDetailsData> transfer({
    required EthereumAddress recipient,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'transfer',
      params: [recipient, amount.getInWei],
    );
  }

  Future<TxDetailsData> transferFrom({
    required EthereumAddress sender,
    required EthereumAddress recipient,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'transferFrom',
      params: [sender, recipient, amount.getInWei],
    );
  }

  Future<TxDetailsData> increaseAllowance({
    required EthereumAddress spender,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'increaseAllowance',
      params: [spender, amount.getInWei],
    );
  }

  Future<TxDetailsData> decreaseAllowance({
    required EthereumAddress spender,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'decreaseAllowance',
      params: [spender, amount.getInWei],
    );
  }
}
