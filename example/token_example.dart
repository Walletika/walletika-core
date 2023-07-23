import 'package:walletika_sdk/walletika_sdk.dart';

void main() async {
  EthereumAddress address = EthereumAddress.fromHex(
    '0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3',
  );

  // initialize walletika SDK
  await walletikaSDKInitialize();

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

  TokenData tokenData = TokenData(
    contract: EthereumAddress.fromHex(
      '0x8cA86F6eE71Ee4B951279711341F051195B188F8',
    ),
    name: 'Tether',
    symbol: 'USDT',
    decimals: 6,
  );

  // Get all tokens
  await for (TokenData item in getAllTokens()) {
    item;
  }

  // Add token
  await addNewToken(tokenData);

  // Remove token
  await removeToken(tokenData);

  // Token engine
  TokenEngine tokenEngine = TokenEngine(
    tokenData: tokenData,
    sender: address,
  );

  // Get token name
  await tokenEngine.name();

  // Get symbol name
  await tokenEngine.symbol();

  // Get decimals name
  await tokenEngine.decimals();

  // Get totalSupply
  await tokenEngine.totalSupply();

  // Check balance
  EtherAmount balance = await tokenEngine.balanceOf(address: address);

  // Transfer token
  TxDetailsData txDetails = await tokenEngine.transfer(
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
