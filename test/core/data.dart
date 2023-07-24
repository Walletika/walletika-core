import 'package:walletika_core/src/core/core.dart';
import 'package:walletika_core/src/models.dart';

List<Map<String, dynamic>> walletsDataTest() {
  return [
    {
      DBKeys.type: WalletType.login,
      DBKeys.address: '0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3',
      DBKeys.username: 'username1',
      DBKeys.password: 'password1',
      DBKeys.securityPassword: '123456',
    },
    {
      DBKeys.type: WalletType.login,
      DBKeys.address: '0xB41aD6b3EE5373dbAC2b471E4582A0b50f4bC9DE',
      DBKeys.username: 'username2',
      DBKeys.password: 'password2',
      DBKeys.securityPassword: '123457',
    },
    {
      DBKeys.type: WalletType.login,
      DBKeys.address: '0xB72bEC2cB81F9B61321575D574BAC577BAb99141',
      DBKeys.username: 'username3',
      DBKeys.password: 'password3',
      DBKeys.securityPassword: '123458',
    },
    {
      DBKeys.type: WalletType.login,
      DBKeys.address: '0x45EF6cc9f2aD7A85e282D14fc23C745727e547b6',
      DBKeys.username: 'username4',
      DBKeys.password: 'password4',
      DBKeys.securityPassword: '123459',
    },
    {
      DBKeys.type: WalletType.login,
      DBKeys.address: '0x71471d05114c758eBfC3D3b952a722Ef2d53970b',
      DBKeys.username: 'username5',
      DBKeys.password: 'password5',
      DBKeys.securityPassword: '123460',
    },
  ];
}

List<Map<String, dynamic>> networksDataTest() {
  return [
    {
      DBKeys.rpc:
          "https://mainnet.infura.io/v3/0bbf89ffa7794d2f9fd1ebd4cae51edd",
      DBKeys.name: "Ethereum",
      DBKeys.chainID: 1,
      DBKeys.symbol: "ETH",
      DBKeys.explorer: "https://etherscan.io",
      DBKeys.isLocked: false,
    },
    {
      DBKeys.rpc: "https://bsc-dataseed1.binance.org",
      DBKeys.name: "Binance Smart Chain",
      DBKeys.chainID: 56,
      DBKeys.symbol: "BNB",
      DBKeys.explorer: "https://bscscan.com",
      DBKeys.isLocked: false,
    },
    {
      DBKeys.rpc: "https://data-seed-prebsc-1-s1.binance.org:8545",
      DBKeys.name: "Binance Smart Chain (Testnet)",
      DBKeys.chainID: 97,
      DBKeys.symbol: "BNB",
      DBKeys.explorer: "https://testnet.bscscan.com",
      DBKeys.isLocked: false,
    },
  ];
}

List<Map<String, dynamic>> tokensBSCTestnetDataTest() {
  return [
    {
      DBKeys.contract: '0x8cA86F6eE71Ee4B951279711341F051195B188F8',
      DBKeys.name: 'Tether',
      DBKeys.symbol: 'USDT',
      DBKeys.decimals: 6,
    },
    {
      DBKeys.contract: '0xe7D28bAB8f375D0b07f382b92C3B6c9C4c1eeb8a',
      DBKeys.name: 'USD Coin',
      DBKeys.symbol: 'USDC',
      DBKeys.decimals: 18,
    },
    {
      DBKeys.contract: '0xc4d3716B65b9c4c6b69e4E260b37e0e476e28d87',
      DBKeys.name: 'Walletika',
      DBKeys.symbol: 'WTK',
      DBKeys.decimals: 18,
    },
  ];
}

List<Map<String, dynamic>> stakesBSCTestnetDataTest() {
  return [
    {
      DBKeys.rpc: 'https://data-seed-prebsc-1-s1.binance.org:8545',
      DBKeys.contract: '0xbfAa034b854703f31B34eCC1c68C356feeb19268',
      DBKeys.stakeToken: {
        DBKeys.contract: '0xc4d3716B65b9c4c6b69e4E260b37e0e476e28d87',
        DBKeys.name: 'Walletika',
        DBKeys.symbol: 'WTK',
        DBKeys.decimals: 18,
        DBKeys.website: '',
      },
      DBKeys.rewardToken: {
        DBKeys.contract: '0xc4d3716B65b9c4c6b69e4E260b37e0e476e28d87',
        DBKeys.name: 'Walletika',
        DBKeys.symbol: 'WTK',
        DBKeys.decimals: 18,
        DBKeys.website: '',
      },
      DBKeys.startBlock: 23545120,
      DBKeys.endBlock: 128636320,
      DBKeys.isLocked: false,
    },
  ];
}

List<Map<String, dynamic>> transactionsBSCTestnetDataTest() {
  return [
    {
      DBKeys.txHash:
          '0x0999608c57697ff7a6051bbbc76f8fe7d2c552d1df7e0f0553d91798f722ec3f',
      DBKeys.function: 'transfer',
      DBKeys.fromAddress: '0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3',
      DBKeys.toAddress: '0xD99D1c33F9fC3444f8101754aBC46c52416550D1',
      DBKeys.amount: '0',
      DBKeys.symbol: 'BNB',
      DBKeys.decimals: 18,
      DBKeys.dateCreated: '2022-10-04 14:10:16.648948',
      DBKeys.status: 1,
    },
    {
      DBKeys.txHash:
          '0xd44e4b40e905b0565d21674cef080db8f91828e5ee372db88143ae0c3be4aaac',
      DBKeys.function: 'transfer',
      DBKeys.fromAddress: '0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3',
      DBKeys.toAddress: '0x8f7af74A269aD76cbd3B278A7E7080295819f161',
      DBKeys.amount: '0',
      DBKeys.symbol: 'BNB',
      DBKeys.decimals: 18,
      DBKeys.dateCreated: '2022-10-04 14:10:16.648948',
      DBKeys.status: 1,
    },
    {
      DBKeys.txHash:
          '0x49158a8a258d9a6b264746f02e1387de6c4df4694b1f3637d6624de15844ee00',
      DBKeys.function: 'transfer',
      DBKeys.fromAddress: '0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3',
      DBKeys.toAddress: '0xD99D1c33F9fC3444f8101754aBC46c52416550D1',
      DBKeys.amount: '1000000000000000000',
      DBKeys.symbol: 'BNB',
      DBKeys.decimals: 18,
      DBKeys.dateCreated: '2022-10-04 14:10:16.648948',
      DBKeys.status: -1,
    },
    {
      DBKeys.txHash:
          '0x06c37c03de55eac28e2b159a6bcbcd8ce8ff8a92c9ad4880185e77f8d411fa05',
      DBKeys.function: 'transfer',
      DBKeys.fromAddress: '0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3',
      DBKeys.toAddress: '0x9027A1A724ffa5bcB1478E3AC994a706AFa7C2DE',
      DBKeys.amount: '1000000000000000000',
      DBKeys.symbol: 'BNB',
      DBKeys.decimals: 18,
      DBKeys.dateCreated: '2022-10-04 14:10:16.648948',
      DBKeys.status: 0,
    },
  ];
}
