import 'package:web3dart/web3dart.dart';

import '../core/core.dart';
import '../models.dart';

class TokenEngine extends ContractEngine {
  final TokenModel tokenModel;

  TokenEngine({required this.tokenModel, super.sender})
      : super(
          address: tokenModel.contract,
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

  Future<TxDetailsModel> approve({
    required EthereumAddress spender,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'approve',
      params: [spender, amount.getInWei],
    );
  }

  Future<TxDetailsModel> transfer({
    required EthereumAddress recipient,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'transfer',
      params: [recipient, amount.getInWei],
    );
  }

  Future<TxDetailsModel> transferFrom({
    required EthereumAddress sender,
    required EthereumAddress recipient,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'transferFrom',
      params: [sender, recipient, amount.getInWei],
    );
  }

  Future<TxDetailsModel> increaseAllowance({
    required EthereumAddress spender,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'increaseAllowance',
      params: [spender, amount.getInWei],
    );
  }

  Future<TxDetailsModel> decreaseAllowance({
    required EthereumAddress spender,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'decreaseAllowance',
      params: [spender, amount.getInWei],
    );
  }
}

class WalletikaTokenEngine extends TokenEngine {
  WalletikaTokenEngine({required super.tokenModel, super.sender});

  Future<EthereumAddress> owner({BlockNum? atBlock}) {
    return functionCall(
      function: 'owner',
      atBlock: atBlock,
    ).then<EthereumAddress>(
      (response) => response.first,
    );
  }

  Future<int> inflationRateAnnually({BlockNum? atBlock}) {
    return functionCall(
      function: 'inflationRateAnnually',
      atBlock: atBlock,
    ).then<int>(
      (response) => (response.first as BigInt).toInt(),
    );
  }

  Future<DateTime> inflationDurationEndDate({BlockNum? atBlock}) {
    return functionCall(
      function: 'inflationDurationEndDate',
      atBlock: atBlock,
    ).then<DateTime>(
      (response) => DateTime.fromMillisecondsSinceEpoch(
        (response.first as BigInt).toInt(),
      ),
    );
  }

  Future<EtherAmount> availableToMintCurrentYear({BlockNum? atBlock}) {
    return functionCall(
      function: 'availableToMintCurrentYear',
      atBlock: atBlock,
    ).then<EtherAmount>(
      (response) => EtherAmount.inWei(response.first),
    );
  }

  Future<TxDetailsModel> transferMultiple({
    required List<EthereumAddress> addresses,
    required List<EtherAmount> amounts,
  }) {
    return Future(() async {
      List<BigInt> amounts_ = amounts.map((e) => e.getInWei).toList();
      return await buildTransaction(
        function: 'transferMultiple',
        params: [addresses, amounts_],
      );
    });
  }

  Future<TxDetailsModel> burn({required EtherAmount amount}) {
    return buildTransaction(
      function: 'burn',
      params: [amount.getInWei],
    );
  }

  Future<TxDetailsModel> burnFrom({
    required EthereumAddress sender,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'burnFrom',
      params: [sender, amount.getInWei],
    );
  }

  Future<TxDetailsModel> mint({required EtherAmount amount}) {
    return buildTransaction(
      function: 'mint',
      params: [amount.getInWei],
    );
  }

  Future<TxDetailsModel> recoverToken({
    required EthereumAddress token,
    required EtherAmount amount,
  }) {
    return buildTransaction(
      function: 'recoverToken',
      params: [token, amount.getInWei],
    );
  }

  Future<TxDetailsModel> renounceOwnership() {
    return buildTransaction(
      function: 'renounceOwnership',
    );
  }

  Future<TxDetailsModel> transferOwnership(
      {required EthereumAddress newOwner}) {
    return buildTransaction(
      function: 'transferOwnership',
      params: [newOwner],
    );
  }
}
