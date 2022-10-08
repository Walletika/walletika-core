import 'package:walletika_sdk/walletika_sdk.dart';
import 'package:web3dart/web3dart.dart';

void main() async {
  EthereumAddress address = EthereumAddress.fromHex(
    '0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3',
  );

  // initialize walletika SDK
  await walletikaSDKInitialize();

  NetworkModel networkModel = NetworkModel(
    rpc: 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161',
    name: 'Ethereum Ropsten (Testnet)',
    chainID: 3,
    symbol: 'ETH',
    explorer: 'https://ropsten.etherscan.io',
  );

  // Connect with RPC
  bool isConnected = await Provider.connect(networkModel);

  TokenModel tokenModel = TokenModel(
    contract: EthereumAddress.fromHex(
      '0x45Fa0b2Dc4095Be21D7b3d1985f71a52f6a34c07',
    ),
    symbol: 'USDT',
    decimals: 6,
    website: '',
  );

  StakeModel stakeModel = StakeModel(
    rpc: 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161',
    contract: EthereumAddress.fromHex(
      '0x2071D97f7795742eAcb03783F349163E987455a7',
    ),
    stakeToken: tokenModel,
    rewardToken: tokenModel,
    startBlock: 0,
    endBlock: 0,
    startTime: DateTime.parse('1970-01-01 02:00:00.000'),
    endTime: DateTime.parse('1970-01-01 02:00:00.000'),
  );

  // Token engine
  StakeEngine stakeEngine = StakeEngine(
    stakeModel: stakeModel,
    sender: address,
  );

  // Get totalSupply
  EtherAmount totalSupply = await stakeEngine.totalSupply();

  // Get rewardSupply
  EtherAmount rewardSupply = await stakeEngine.rewardSupply();

  // Check balance
  EtherAmount balance = await stakeEngine.balanceOf(address: address);

  // Despoit token
  TxDetailsModel txDetails = await stakeEngine.deposit(
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
