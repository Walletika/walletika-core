import 'package:walletika_sdk/walletika_sdk.dart';
import 'package:web3dart/web3dart.dart';

void main() async {
  EthereumAddress address = EthereumAddress.fromHex(
    '0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3',
  );

  // initialize walletika SDK
  await walletikaSDKInitialize();

  NetworkModel networkModel = NetworkModel(
    rpc: 'https://data-seed-prebsc-1-s1.binance.org:8545',
    name: 'Binance Smart Chain (Testnet)',
    chainID: 97,
    symbol: 'BNB',
    explorer: 'https://testnet.bscscan.com',
  );

  // Connect with RPC
  bool isConnected = await Provider.connect(networkModel);

  TokenModel tokenModel = TokenModel(
    contract: EthereumAddress.fromHex(
      '0x8cA86F6eE71Ee4B951279711341F051195B188F8',
    ),
    name: 'Tether',
    symbol: 'USDT',
    decimals: 6,
    website: '',
  );

  // Token engine
  TokenEngine tokenEngine = TokenEngine(
    tokenModel: tokenModel,
    sender: address,
  );

  // Get token name
  String name = await tokenEngine.name();

  // Get symbol name
  String symbol = await tokenEngine.symbol();

  // Get decimals name
  int decimals = await tokenEngine.decimals();

  // Get totalSupply
  EtherAmount totalSupply = await tokenEngine.totalSupply();

  // Check balance
  EtherAmount balance = await tokenEngine.balanceOf(address: address);

  // Transfer token
  TxDetailsModel txDetails = await tokenEngine.transfer(
    recipient: address,
    amount: balance,
  );
  Transaction tx = txDetails.tx;
  Map<String, dynamic> abi = txDetails.abi;
  Map<String, dynamic> args = txDetails.args;
  String data = txDetails.data;

  // Add gas fee
  TxGasDetailsModel txGasDetails = await Provider.addGas(tx: tx);
  tx = txGasDetails.tx;
  EtherAmount estimateGas = txGasDetails.estimateGas;
  EtherAmount maxFee = txGasDetails.maxFee;
  EtherAmount total = txGasDetails.total;
  EtherAmount maxAmount = txGasDetails.maxAmount;

  // Send transaction
  String sendTransaction = await Provider.sendTransaction(
    credentials: EthPrivateKey.fromHex(
      '0xe394b45f8ab120fbf238e356de30c14fdfa6ddf87b2c19253e161a850bfd03f7',
    ),
    tx: tx,
  );
}
