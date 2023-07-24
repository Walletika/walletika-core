import 'package:walletika_core/walletika_core.dart';

void main() async {
  EthereumAddress address = EthereumAddress.fromHex(
    '0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3',
  );

  // initialize walletika Core
  await walletikaCoreInitialize();

  NetworkData networkData = NetworkData(
    rpc: 'https://data-seed-prebsc-1-s1.binance.org:8545',
    name: 'Binance Smart Chain (Testnet)',
    chainID: 97,
    symbol: 'BNB',
    explorer: 'https://testnet.bscscan.com',
    isLocked: false,
  );

  // Connect with RPC
  await ProviderEngine.instance.connect(networkData);

  // Check balance
  EtherAmount balance =
      await ProviderEngine.instance.balanceOf(address: address);

  // Get current block number
  await ProviderEngine.instance.blockNumber();

  // Check is current network supported EIP1559
  await ProviderEngine.instance.isSupportEIP1559();

  // Explorer URL of address
  ProviderEngine.instance.getExploreUrl(address.hexEip55);

  // Get transaction
  await ProviderEngine.instance.getTransaction(
    '0x92a00e77d80cb89bcbf844fa8b05640c59087031ff50557299998bd889cce16b',
  );

  // Get transaction receipt
  await ProviderEngine.instance.getTransactionReceipt(
    '0x92a00e77d80cb89bcbf844fa8b05640c59087031ff50557299998bd889cce16b',
  );

  // Transfer coin
  TxDetailsData txDetails = await ProviderEngine.instance.transfer(
    sender: address,
    recipient: address,
    amount: balance,
  );
  Transaction tx = txDetails.tx;
  txDetails.abi;
  txDetails.args;

  // Add gas fee
  TxGasDetailsData txGasDetails = await ProviderEngine.instance.addGas(tx: tx);
  tx = txGasDetails.tx;
  txGasDetails.estimateGas;
  txGasDetails.maxFee;
  txGasDetails.total;
  txGasDetails.maxAmount;

  // Send transaction
  await ProviderEngine.instance.sendTransaction(
    credentials: EthPrivateKey.fromHex(
      '0xe394b45f8ab120fbf238e356de30c14fdfa6ddf87b2c19253e161a850bfd03f7',
    ),
    tx: tx,
  );
}
