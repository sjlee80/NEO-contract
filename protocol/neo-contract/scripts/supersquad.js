const { Connection, PublicKey } = require('@solana/web3.js');
const { SolendMarket } = require('@solendprotocol/solend-sdk');

const connection = new Connection('https://api.mainnet-beta.solana.com');

async function main() {
  // There are three levels of data you can request (and cache) about the lending market.
  // 1. Initalize market with parameters and metadata
  const market = await SolendMarket.initialize(
    connection,
    'production', // optional environment argument
    new PublicKey('7RCz8wb6WXxUhAigok9ttgrVgDFFFbibcirECzWSBauM') // optional market address (TURBO SOL). Defaults to 'Main' market
  );
  console.log(market.reserves.map((reserve) => reserve.config.loanToValueRatio));

  // 2. Read on-chain accounts for reserve data and cache
  await market.loadReserves();

  const usdcReserve = market.reserves.find((res) => res.config.symbol === 'USDC');
  console.log(usdcReserve.stats.totalDepositsWads.toString());

  // Read Solend liquidity mining stats
  await market.loadRewards();
  console.log(reserve.stats.totalSupplyAPY().rewards); // {apy: 0.07, rewardMint: "SLND...

  // Refresh all cached data
  market.refreshAll();

  const obligation = market.fetchObligationByWallet('[WALLET_ID]');
  console.log(obligation.stats.borrowLimit);
}

main().catch((err) => console.error(err));
