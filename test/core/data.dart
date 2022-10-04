List<Map<String, dynamic>> walletsDataTest() {
  return [
    {
      'address': '0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3',
      'username': 'username1',
      'password': 'password1',
      'recoveryPass': '123456',
    },
    {
      'address': '0xB41aD6b3EE5373dbAC2b471E4582A0b50f4bC9DE',
      'username': 'username2',
      'password': 'password2',
      'recoveryPass': '123457',
    },
    {
      'address': '0xB72bEC2cB81F9B61321575D574BAC577BAb99141',
      'username': 'username3',
      'password': 'password3',
      'recoveryPass': '123458',
    },
    {
      'address': '0x45EF6cc9f2aD7A85e282D14fc23C745727e547b6',
      'username': 'username4',
      'password': 'password4',
      'recoveryPass': '123459',
    },
    {
      'address': '0x71471d05114c758eBfC3D3b952a722Ef2d53970b',
      'username': 'username5',
      'password': 'password5',
      'recoveryPass': '123460',
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
      "rpc": "https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
      "name": "Ethereum Ropsten (Testnet)",
      "chainID": 3,
      "symbol": "ETH",
      "explorer": "https://ropsten.etherscan.io",
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

List<Map<String, dynamic>> tokensETHRopstenDataTest() {
  return [
    {
      'contract': '0x45Fa0b2Dc4095Be21D7b3d1985f71a52f6a34c07',
      'symbol': 'USDT',
      'decimals': 6,
      'website': '',
    },
    {
      'contract': '0x6168F02C4745D27aA8fde8e844162583C42f8cBF',
      'symbol': 'USDC',
      'decimals': 18,
      'website': '',
    },
    {
      'contract': '0x11DCF2Af29068d9814A4C890e07A0Ad245738433',
      'symbol': 'WTK',
      'decimals': 18,
      'website': '',
    },
  ];
}

List<Map<String, dynamic>> transactionsETHRopstenDataTest() {
  return [
    {
      'txHash':
          '0x9458917fbda7477757a9a3a547d94f903c8eae031a16afb1f7b7847213133812',
      'function': 'transfer',
      'fromAddress': '0x81b7E08F65Bdf5648606c89998A9CC8164397647',
      'toAddress': '0x113f049b5Dc0b8D757beDDBde0c06d2a78344bF1',
      'amount': '1000000000000000000',
      'symbol': 'ETH',
      'dateCreated': '2022-10-04 14:10:16.648948',
      'status': 1,
    },
    {
      'txHash':
          '0x899be183e4100344a8def59cc9c89ff1a4168c5ec8baf5c150a6dfdf13743a60',
      'function': 'transfer',
      'fromAddress': '0x0033C8D927bB2FC7B8D918804B73Ba0e63711002',
      'toAddress': '0x971947E77F2C6e91a81D05c8aD202a8111d2aB69',
      'amount': '1000000000000000000',
      'symbol': 'ETH',
      'dateCreated': '2022-10-04 14:10:16.648948',
      'status': 1,
    },
    {
      'txHash':
          '0xecbc7811ffd30542b7d0c5cf8016931517ac2995c795bc3cb46f26175c266df1',
      'function': 'transfer',
      'fromAddress': '0x81b7E08F65Bdf5648606c89998A9CC8164397647',
      'toAddress': '0x971947E77F2C6e91a81D05c8aD202a8111d2aB69',
      'amount': '1000000000000000000',
      'symbol': 'ETH',
      'dateCreated': '2022-10-04 14:10:16.648948',
      'status': 1,
    },
    {
      'txHash':
          '0xb66c55407daec7bf7441dddad477cb0b6026c02108f77daa3edd9c0f00f76a89',
      'function': 'transfer',
      'fromAddress': '0x2cA5F489CC1Fd1CEC24747B64E8dE0F4A6A850E1',
      'toAddress': '0x971947E77F2C6e91a81D05c8aD202a8111d2aB69',
      'amount': '1000000000000000000',
      'symbol': 'ETH',
      'dateCreated': '2022-10-04 14:10:16.648948',
      'status': 1,
    },
  ];
}
