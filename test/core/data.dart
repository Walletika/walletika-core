List<Map<String, dynamic>> walletsDataTest() {
  return [
    {
      'address': '0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3',
      'username': 'username1',
      'password': 'password1',
      'securityPass': '123456',
    },
    {
      'address': '0xB41aD6b3EE5373dbAC2b471E4582A0b50f4bC9DE',
      'username': 'username2',
      'password': 'password2',
      'securityPass': '123457',
    },
    {
      'address': '0xB72bEC2cB81F9B61321575D574BAC577BAb99141',
      'username': 'username3',
      'password': 'password3',
      'securityPass': '123458',
    },
    {
      'address': '0x45EF6cc9f2aD7A85e282D14fc23C745727e547b6',
      'username': 'username4',
      'password': 'password4',
      'securityPass': '123459',
    },
    {
      'address': '0x71471d05114c758eBfC3D3b952a722Ef2d53970b',
      'username': 'username5',
      'password': 'password5',
      'securityPass': '123460',
    },
  ];
}

List<Map<String, dynamic>> networksDataTest() {
  return [
    {
      "rpc": "https://mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
      "name": "Ethereum",
      "chainID": 1,
      "symbol": "ETH",
      "explorer": "https://etherscan.io",
    },
    {
      "rpc": "https://bsc-dataseed1.binance.org",
      "name": "Binance Smart Chain",
      "chainID": 56,
      "symbol": "BNB",
      "explorer": "https://bscscan.com",
    },
    {
      "rpc": "https://data-seed-prebsc-1-s1.binance.org:8545",
      "name": "Binance Smart Chain (Testnet)",
      "chainID": 97,
      "symbol": "BNB",
      "explorer": "https://testnet.bscscan.com",
    },
  ];
}

List<Map<String, dynamic>> tokensBSCTestnetDataTest() {
  return [
    {
      'contract': '0x8cA86F6eE71Ee4B951279711341F051195B188F8',
      'symbol': 'USDT',
      'decimals': 6,
      'website': '',
    },
    {
      'contract': '0xCc0710d99467BE543e5d85f67A31cA674125659C',
      'symbol': 'USDC',
      'decimals': 18,
      'website': '',
    },
    {
      'contract': '0xc4d3716B65b9c4c6b69e4E260b37e0e476e28d87',
      'symbol': 'WTK',
      'decimals': 18,
      'website': '',
    },
  ];
}

List<Map<String, dynamic>> stakesBSCTestnetDataTest() {
  return [
    {
      'rpc': 'https://data-seed-prebsc-1-s1.binance.org:8545',
      'contract': '0xbfAa034b854703f31B34eCC1c68C356feeb19268',
      'stakeToken': {
        'contract': '0xc4d3716B65b9c4c6b69e4E260b37e0e476e28d87',
        'symbol': 'WTK',
        'decimals': 18,
        'website': '',
      },
      'rewardToken': {
        'contract': '0xc4d3716B65b9c4c6b69e4E260b37e0e476e28d87',
        'symbol': 'WTK',
        'decimals': 18,
        'website': '',
      },
      'startBlock': 23545120,
      'endBlock': 128636320,
      'startTime': '2022-10-09 09:00:00',
      'endTime': '2032-10-09 09:00:00',
    },
  ];
}

List<Map<String, dynamic>> transactionsBSCTestnetDataTest() {
  return [
    {
      'txHash':
          '0x0999608c57697ff7a6051bbbc76f8fe7d2c552d1df7e0f0553d91798f722ec3f',
      'function': 'transfer',
      'fromAddress': '0x5c8CE2AaDA53a7c909e5e1ddf26Da19c32083E6D',
      'toAddress': '0xD99D1c33F9fC3444f8101754aBC46c52416550D1',
      'amount': '0',
      'symbol': 'BNB',
      'dateCreated': '2022-10-04 14:10:16.648948',
      'status': 1,
    },
    {
      'txHash':
          '0x4071ff1b7601ab547599fe059bfced11e7e00dff684bd99b146156e69da50b1d',
      'function': 'transfer',
      'fromAddress': '0x4f5d7100c48EE070caF6C8Ae940C125b23f12Fa4',
      'toAddress': '0x8f7af74A269aD76cbd3B278A7E7080295819f161',
      'amount': '0',
      'symbol': 'BNB',
      'dateCreated': '2022-10-04 14:10:16.648948',
      'status': 1,
    },
    {
      'txHash':
          '0x49158a8a258d9a6b264746f02e1387de6c4df4694b1f3637d6624de15844ee0b',
      'function': 'transfer',
      'fromAddress': '0x3f5ab9e22360921BE88e255C8a22b63B5E76dFf1',
      'toAddress': '0xD99D1c33F9fC3444f8101754aBC46c52416550D1',
      'amount': '1000000000000000000',
      'symbol': 'BNB',
      'dateCreated': '2022-10-04 14:10:16.648948',
      'status': 1,
    },
    {
      'txHash':
          '0x4b30e31aeced2c7e3ee65c02fc929bec5790d84d6d94077edce9bcd4d3a84b40',
      'function': 'transfer',
      'fromAddress': '0x47814C91626B0929c1A786846487eFdbA100846c',
      'toAddress': '0x9027A1A724ffa5bcB1478E3AC994a706AFa7C2DE',
      'amount': '1000000000000000000',
      'symbol': 'BNB',
      'dateCreated': '2022-10-04 14:10:16.648948',
      'status': 1,
    },
  ];
}
