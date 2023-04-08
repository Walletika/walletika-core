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
    DBKeys.rpc: "https://public-en-cypress.klaytn.net",
    DBKeys.name: "Klaytn Cypress Mainnet",
    DBKeys.chainID: 8217,
    DBKeys.symbol: "KLAY",
    DBKeys.explorer: "https://scope.klaytn.com",
  },
  {
    DBKeys.rpc: "https://api.avax.network/ext/bc/C/rpc",
    DBKeys.name: "Avalanche Mainnet",
    DBKeys.chainID: 43114,
    DBKeys.symbol: "AVAX",
    DBKeys.explorer: "https://snowtrace.io",
  },
  {
    DBKeys.rpc: "https://evm.confluxrpc.com",
    DBKeys.name: "Conflux eSpace Mainnet",
    DBKeys.chainID: 1030,
    DBKeys.symbol: "CFX",
    DBKeys.explorer: "https://evm.confluxscan.net",
  },
  {
    DBKeys.rpc: "https://exchainrpc.okex.org",
    DBKeys.name: "OKExChain Mainnet",
    DBKeys.chainID: 66,
    DBKeys.symbol: "OKT",
    DBKeys.explorer: "https://www.oklink.com/okexchain",
  },
  {
    DBKeys.rpc: "https://flare-api.flare.network/ext/C/rpc",
    DBKeys.name: "Flare Mainnet",
    DBKeys.chainID: 14,
    DBKeys.symbol: "FLR",
    DBKeys.explorer: "https://flare-explorer.flare.network",
  },
  {
    DBKeys.rpc: "https://evm.cronos.org",
    DBKeys.name: "Cronos Mainnet",
    DBKeys.chainID: 25,
    DBKeys.symbol: "CRO",
    DBKeys.explorer: "https://cronoscan.com",
  },
  {
    DBKeys.rpc: "https://forno.celo.org",
    DBKeys.name: "Celo Mainnet",
    DBKeys.chainID: 42220,
    DBKeys.symbol: "CELO",
    DBKeys.explorer: "https://celoscan.io",
  },
  {
    DBKeys.rpc: "https://rpc-mainnet.kcc.network",
    DBKeys.name: "KCC Mainnet",
    DBKeys.chainID: 321,
    DBKeys.symbol: "KCS",
    DBKeys.explorer: "https://explorer.kcc.io",
  },
  {
    DBKeys.rpc: "https://http-mainnet.hecochain.com",
    DBKeys.name: "Heco Mainnet",
    DBKeys.chainID: 128,
    DBKeys.symbol: "HT",
    DBKeys.explorer: "https://hecoinfo.com",
  },
  {
    DBKeys.rpc: "https://eth-rpc-api.thetatoken.org/rpc",
    DBKeys.name: "Theta Mainnet",
    DBKeys.chainID: 361,
    DBKeys.symbol: "TFUEL",
    DBKeys.explorer: "https://explorer.thetatoken.org",
  },
  {
    DBKeys.rpc: "https://babel-api.mainnet.iotex.io",
    DBKeys.name: "IoTeX Mainnet",
    DBKeys.chainID: 4689,
    DBKeys.symbol: "IOTX",
    DBKeys.explorer: "https://iotexscan.io",
  },
  {
    DBKeys.rpc: "https://mainnet-rpc.brisescan.com",
    DBKeys.name: "Brise Mainnet",
    DBKeys.chainID: 32520,
    DBKeys.symbol: "BRISE",
    DBKeys.explorer: "https://brisescan.com",
  },
  {
    DBKeys.rpc: "https://rpc.coredao.org",
    DBKeys.name: "CORE Mainnet",
    DBKeys.chainID: 1116,
    DBKeys.symbol: "CORE",
    DBKeys.explorer: "https://scan.coredao.org",
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
