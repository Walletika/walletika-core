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

  // Check balance
  EtherAmount balance = await Provider.balanceOf(address: address);

  // Get current block nubmber
  int blockNumber = await Provider.blockNumber();

  // Check is current network supported EIP1559
  bool isEIP1559Supported = Provider.isEIP1559Supported();

  // Explorer URL of address
  String exploreUrl = Provider.getExploreUrl(address.hexEip55);

  // Get transaction
  TransactionInformation? transaction = await Provider.getTransaction(
    '0x92a00e77d80cb89bcbf844fa8b05640c59087031ff50557299998bd889cce16b',
  );

  // Get transaction receipt
  TransactionReceipt? transactionReceipt = await Provider.getTransactionReceipt(
    '0x92a00e77d80cb89bcbf844fa8b05640c59087031ff50557299998bd889cce16b',
  );

  // Transfer coin
  TxDetailsModel txDetails = await Provider.transfer(
    sender: address,
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
