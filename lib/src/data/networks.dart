import '../core/core.dart';

final List<Map<String, dynamic>> defaultNetworksData = [
  {
    DBKeys.rpc: "https://mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
    DBKeys.name: "Ethereum Mainnet",
    DBKeys.chainID: 1,
    DBKeys.symbol: "ETH",
    DBKeys.explorer: "https://etherscan.io",
  },
  {
    DBKeys.rpc: "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
    DBKeys.name: "Goerli ( Testnet )",
    DBKeys.chainID: 5,
    DBKeys.symbol: "ETH",
    DBKeys.explorer: "https://goerli.etherscan.io",
  },
  {
    DBKeys.rpc: "https://sepolia.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
    DBKeys.name: "Sepolia ( Testnet )",
    DBKeys.chainID: 11155111,
    DBKeys.symbol: "ETH",
    DBKeys.explorer: "https://sepolia.etherscan.io",
  },
  {
    DBKeys.rpc: "https://bsc-dataseed1.binance.org",
    DBKeys.name: "BNB Smart Chain Mainnet",
    DBKeys.chainID: 56,
    DBKeys.symbol: "BNB",
    DBKeys.explorer: "https://bscscan.com",
  },
  {
    DBKeys.rpc: "https://data-seed-prebsc-1-s3.binance.org:8545",
    DBKeys.name: "BNB Smart Chain ( Testnet )",
    DBKeys.chainID: 97,
    DBKeys.symbol: "BNB",
    DBKeys.explorer: "https://testnet.bscscan.com",
  },
  {
    DBKeys.rpc: "https://polygon-rpc.com",
    DBKeys.name: "Polygon Mainnet",
    DBKeys.chainID: 137,
    DBKeys.symbol: "MATIC",
    DBKeys.explorer: "https://polygonscan.com",
  },
  {
    DBKeys.rpc: "https://matic-mumbai.chainstacklabs.com",
    DBKeys.name: "Polygon Mumbai ( Testnet )",
    DBKeys.chainID: 80001,
    DBKeys.symbol: "MATIC",
    DBKeys.explorer: "https://mumbai.polygonscan.com",
  },
  {
    DBKeys.rpc: "https://api.avax.network/ext/bc/C/rpc",
    DBKeys.name: "Avalanche Mainnet",
    DBKeys.chainID: 43114,
    DBKeys.symbol: "AVAX",
    DBKeys.explorer: "https://snowtrace.io",
  },
  {
    DBKeys.rpc: "https://api.avax-test.network/ext/bc/C/rpc",
    DBKeys.name: "Avalanche ( Testnet )",
    DBKeys.chainID: 43113,
    DBKeys.symbol: "AVAX",
    DBKeys.explorer: "https://testnet.snowtrace.io",
  },
  {
    DBKeys.rpc: "https://arb1.arbitrum.io/rpc",
    DBKeys.name: "Arbitrum One Mainnet",
    DBKeys.chainID: 42161,
    DBKeys.symbol: "ETH",
    DBKeys.explorer: "https://arbiscan.io",
  },
  {
    DBKeys.rpc: "https://nova.arbitrum.io/rpc",
    DBKeys.name: "Arbitrum Nova Mainnet",
    DBKeys.chainID: 42170,
    DBKeys.symbol: "ETH",
    DBKeys.explorer: "https://nova.arbiscan.io",
  },
  {
    DBKeys.rpc: "https://goerli-rollup.arbitrum.io/rpc",
    DBKeys.name: "Arbitrum Goerli ( Testnet )",
    DBKeys.chainID: 421613,
    DBKeys.symbol: "ETH",
    DBKeys.explorer: "https://goerli.arbiscan.io",
  },
  {
    DBKeys.rpc: "https://evm.cronos.org",
    DBKeys.name: "Cronos Mainnet",
    DBKeys.chainID: 25,
    DBKeys.symbol: "CRO",
    DBKeys.explorer: "https://cronoscan.com",
  },
  {
    DBKeys.rpc: "https://evm-t3.cronos.org",
    DBKeys.name: "Cronos ( Testnet )",
    DBKeys.chainID: 338,
    DBKeys.symbol: "CRO",
    DBKeys.explorer: "https://testnet.cronoscan.com",
  },
  {
    DBKeys.rpc: "https://rpcapi.fantom.network",
    DBKeys.name: "Fantom Opera Mainnet",
    DBKeys.chainID: 250,
    DBKeys.symbol: "FTM",
    DBKeys.explorer: "https://ftmscan.com",
  },
  {
    DBKeys.rpc: "https://mainnet.optimism.io",
    DBKeys.name: "Optimistic Ethereum Mainnet",
    DBKeys.chainID: 10,
    DBKeys.symbol: "ETH",
    DBKeys.explorer: "https://optimistic.etherscan.io",
  },
  {
    DBKeys.rpc: "https://http-mainnet.hecochain.com",
    DBKeys.name: "Heco Mainnet",
    DBKeys.chainID: 128,
    DBKeys.symbol: "HT",
    DBKeys.explorer: "https://hecoinfo.com",
  },
  {
    DBKeys.rpc: "https://public-node-api.klaytnapi.com/v1/cypress",
    DBKeys.name: "Klaytn Cypress Mainnet",
    DBKeys.chainID: 8217,
    DBKeys.symbol: "KLAY",
    DBKeys.explorer: "https://scope.klaytn.com",
  },
  {
    DBKeys.rpc: "https://rpc-mainnet.kcc.network",
    DBKeys.name: "KCC Mainnet",
    DBKeys.chainID: 321,
    DBKeys.symbol: "KCS",
    DBKeys.explorer: "https://explorer.kcc.io",
  },
];

Future<void> networkDataBuilder() async {
  if (networksDB.countRow() > 0) return;

  for (final Map<String, dynamic> network in defaultNetworksData) {
    networksDB.addRow({
      DBKeys.rpc: network[DBKeys.rpc],
      DBKeys.name: network[DBKeys.name],
      DBKeys.chainID: network[DBKeys.chainID],
      DBKeys.symbol: network[DBKeys.symbol],
      DBKeys.explorer: network[DBKeys.explorer],
    });
  }

  await networksDB.dump();
}
