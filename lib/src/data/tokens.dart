import '../core/core.dart';

final List<Map<String, dynamic>> defaultTokensData = [
  {
    DBKeys.rpc: "https://mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
    DBKeys.contract: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
    DBKeys.name: "Tether USD",
    DBKeys.symbol: "USDT",
    DBKeys.decimals: 6,
    DBKeys.website: "https://tether.to",
  },
  {
    DBKeys.rpc: "https://bsc-dataseed1.binance.org",
    DBKeys.contract: "0x55d398326f99059fF775485246999027B3197955",
    DBKeys.name: "Tether USD",
    DBKeys.symbol: "USDT",
    DBKeys.decimals: 18,
    DBKeys.website: "https://tether.to",
  },
  {
    DBKeys.rpc: "https://data-seed-prebsc-1-s3.binance.org:8545",
    DBKeys.contract: "0x8cA86F6eE71Ee4B951279711341F051195B188F8",
    DBKeys.name: "Tether USD",
    DBKeys.symbol: "USDT",
    DBKeys.decimals: 6,
    DBKeys.website: "https://walletika.com",
  },
  {
    DBKeys.rpc: "https://data-seed-prebsc-1-s3.binance.org:8545",
    DBKeys.contract: "0xc4d3716B65b9c4c6b69e4E260b37e0e476e28d87",
    DBKeys.name: "Walletika",
    DBKeys.symbol: "WTK",
    DBKeys.decimals: 18,
    DBKeys.website: "https://walletika.com",
  },
];

Future<void> tokenDataBuilder() async {
  if (tokensDB.countRow() > 0) return;

  for (final Map<String, dynamic> token in defaultTokensData) {
    tokensDB.addRow({
      DBKeys.rpc: token[DBKeys.rpc],
      DBKeys.contract: token[DBKeys.contract],
      DBKeys.name: token[DBKeys.name],
      DBKeys.symbol: token[DBKeys.symbol],
      DBKeys.decimals: token[DBKeys.decimals],
      DBKeys.website: token[DBKeys.website],
    });
  }

  await tokensDB.dump();
}
