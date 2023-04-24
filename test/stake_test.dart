import 'package:walletika_sdk/src/core/core.dart';
import 'package:walletika_sdk/walletika_sdk.dart';
import 'package:test/test.dart';

import 'core/core.dart';

const debugging = true;
void printDebug(String message) {
  if (debugging) print(message);
}

void main() async {
  await walletikaSDKInitialize();
  printDebug("Is Initialized: $walletikaSDKInitialized");

  final List<Map<String, dynamic>> wallets = walletsDataTest();
  final List<Map<String, dynamic>> tokens = tokensBSCTestnetDataTest();
  final List<Map<String, dynamic>> stakes = stakesBSCTestnetDataTest();
  final List<Map<String, dynamic>> networks = networksDataTest();
  const int walletIndex = 0; // Username1
  const int tokenIndex = 2; // WTK Token
  const int stakeIndex = 0; // WTK x WTK
  const int networkIndex = 2; // BSC Testnet

  late WalletEngine walletEngine;
  late EthPrivateKey? credentials;

  late TokenData tokenData;

  late StakeData stakeData;
  late StakeEngine stakeEngine;

  setUpAll(() async {
    bool isConnected = await Provider.connect(
      NetworkData.fromJson(networks[networkIndex]),
    );
    printDebug("${Provider.networkData.name} connection status: $isConnected");

    Map<String, dynamic> wallet = wallets[walletIndex];
    String username = wallet[DBKeys.username];
    String password = wallet[DBKeys.password];
    String securityPassword = wallet[DBKeys.securityPassword];
    String otpCode = getOTPCode(username, password, securityPassword);

    walletEngine = WalletEngine(
      await getWalletData(username, password, securityPassword),
    );
    await walletEngine.login(password);
    credentials = await walletEngine.credentials(otpCode);

    tokenData = TokenData.fromJson(tokens[tokenIndex]);

    stakeData = StakeData.fromJson(stakes[stakeIndex]);
    stakeEngine = StakeEngine(
      stakeData: stakeData,
      sender: walletEngine.address(),
    );
  });

  group("Stake Storage Group", () {
    test("Test (importStakeContracts)", () async {
      await importStakeContracts(stakes);

      expect(stakeDB.countRow(), equals(stakes.length));
    });

    test("Test (getAllStakes)", () async {
      List<StakeData> allStakes = [
        await for (StakeData item in getAllStakes()) item
      ];

      for (int index = 0; index < allStakes.length; index++) {
        StakeData stakeData = allStakes[index];
        String contract = stakeData.contract.hexEip55;
        Map<String, dynamic> stakeToken = stakeData.stakeToken.toJson();
        Map<String, dynamic> rewardToken = stakeData.rewardToken.toJson();
        int startBlock = stakeData.startBlock;
        int endBlock = stakeData.endBlock;
        int startTime = stakeData.startTime.millisecondsSinceEpoch;
        int endTime = stakeData.endTime.millisecondsSinceEpoch;
        bool isLocked = stakeData.isLocked;

        printDebug("""
contract: $contract
stakeToken: $stakeToken
rewardToken: $rewardToken
startBlock: $startBlock
endBlock: $endBlock
startTime: $startTime
endTime: $endTime
isLocked: $isLocked
        """);

        expect(contract, equals(stakes[index][DBKeys.contract]));
        expect(stakeToken, equals(stakes[index][DBKeys.stakeToken]));
        expect(rewardToken, equals(stakes[index][DBKeys.rewardToken]));
        expect(startBlock, equals(stakes[index][DBKeys.startBlock]));
        expect(endBlock, equals(stakes[index][DBKeys.endBlock]));
        expect(startTime, equals(stakes[index][DBKeys.startTime]));
        expect(endTime, equals(stakes[index][DBKeys.endTime]));
        expect(isLocked, equals(stakes[index][DBKeys.isLocked]));
      }

      expect(allStakes.length, equals(stakes.length));
    });
  });

  group("Stake View Group:", () {
    test("Test (owner)", () async {
      EthereumAddress owner = await stakeEngine.owner();

      printDebug("""
owner: ${owner.hexEip55}
        """);

      expect(
        owner.hexEip55,
        equals('0x8AE5368C7F46572236a5B9dA4E0bf3924E16E60C'),
      );
    });

    test("Test (smartChefFactory)", () async {
      EthereumAddress smartChefFactory = await stakeEngine.smartChefFactory();

      printDebug("""
smartChefFactory: ${smartChefFactory.hexEip55}
        """);

      expect(
        smartChefFactory.hexEip55,
        equals('0x8AE5368C7F46572236a5B9dA4E0bf3924E16E60C'),
      );
    });

    test("Test (hasUserLimit)", () async {
      bool hasUserLimit = await stakeEngine.hasUserLimit();

      printDebug("""
hasUserLimit: $hasUserLimit
        """);

      expect(hasUserLimit, isFalse);
    });

    test("Test (lockedToEnd)", () async {
      bool lockedToEnd = await stakeEngine.lockedToEnd();

      printDebug("""
lockedToEnd: $lockedToEnd
        """);

      expect(lockedToEnd, isFalse);
    });

    test("Test (isInitialized)", () async {
      bool isInitialized = await stakeEngine.isInitialized();

      printDebug("""
isInitialized: $isInitialized
        """);

      expect(isInitialized, isTrue);
    });

    test("Test (paused)", () async {
      bool paused = await stakeEngine.paused();

      printDebug("""
paused: $paused
        """);

      expect(paused, isFalse);
    });

    test("Test (lastPauseTime)", () async {
      DateTime lastPauseTime = await stakeEngine.lastPauseTime();

      printDebug("""
lastPauseTime: ${lastPauseTime.toString()}
        """);

      expect(
        lastPauseTime.millisecondsSinceEpoch,
        greaterThanOrEqualTo(0),
      );
    });

    test("Test (accTokenPerShare)", () async {
      EtherAmount accTokenPerShare = await stakeEngine.accTokenPerShare();

      printDebug("""
accTokenPerShare: ${accTokenPerShare.getValueInDecimals(tokenData.decimals)}
        """);

      expect(accTokenPerShare.getInWei, greaterThanOrEqualTo(BigInt.zero));
    });

    test("Test (startBlock)", () async {
      int startBlock = await stakeEngine.startBlock();

      printDebug("""
startBlock: $startBlock
        """);

      expect(startBlock, greaterThanOrEqualTo(0));
    });

    test("Test (bonusEndBlock)", () async {
      int bonusEndBlock = await stakeEngine.bonusEndBlock();

      printDebug("""
bonusEndBlock: $bonusEndBlock
        """);

      expect(bonusEndBlock, greaterThanOrEqualTo(0));
    });

    test("Test (lastRewardBlock)", () async {
      int lastRewardBlock = await stakeEngine.lastRewardBlock();

      printDebug("""
lastRewardBlock: $lastRewardBlock
        """);

      expect(lastRewardBlock, greaterThanOrEqualTo(0));
    });

    test("Test (poolLimitPerUser)", () async {
      EtherAmount poolLimitPerUser = await stakeEngine.poolLimitPerUser();

      printDebug("""
poolLimitPerUser: ${poolLimitPerUser.getValueInDecimals(tokenData.decimals)}
        """);

      expect(poolLimitPerUser.getInWei, greaterThanOrEqualTo(BigInt.zero));
    });

    test("Test (rewardPerBlock)", () async {
      EtherAmount rewardPerBlock = await stakeEngine.rewardPerBlock();

      printDebug("""
rewardPerBlock: ${rewardPerBlock.getValueInDecimals(tokenData.decimals)}
        """);

      expect(rewardPerBlock.getInWei, greaterThanOrEqualTo(BigInt.zero));
    });

    test("Test (precisionFactor)", () async {
      EtherAmount precisionFactor = await stakeEngine.precisionFactor();

      printDebug("""
precisionFactor: ${precisionFactor.getValueInDecimals(tokenData.decimals)}
        """);

      expect(precisionFactor.getInWei, greaterThanOrEqualTo(BigInt.zero));
    });

    test("Test (rewardToken)", () async {
      EthereumAddress rewardToken = await stakeEngine.rewardToken();

      printDebug("""
rewardToken: ${rewardToken.hexEip55}
        """);

      expect(rewardToken, equals(tokenData.contract));
    });

    test("Test (stakedToken)", () async {
      EthereumAddress stakedToken = await stakeEngine.stakedToken();

      printDebug("""
stakedToken: ${stakedToken.hexEip55}
        """);

      expect(stakedToken, equals(tokenData.contract));
    });

    test("Test (totalSupply)", () async {
      EtherAmount totalSupply = await stakeEngine.totalSupply();

      printDebug("""
totalSupply: ${totalSupply.getValueInDecimals(tokenData.decimals)}
        """);

      expect(totalSupply.getInWei, greaterThanOrEqualTo(BigInt.zero));
    });

    test("Test (rewardSupply)", () async {
      EtherAmount rewardSupply = await stakeEngine.rewardSupply();

      printDebug("""
rewardSupply: ${rewardSupply.getValueInDecimals(tokenData.decimals)}
        """);

      expect(rewardSupply.getInWei, greaterThanOrEqualTo(BigInt.zero));
    });

    test("Test (balanceOf)", () async {
      EtherAmount balanceOf = await stakeEngine.balanceOf(
        address: walletEngine.address(),
      );

      printDebug("""
balanceOf: ${balanceOf.getValueInDecimals(tokenData.decimals)}
        """);

      expect(balanceOf.getInWei, greaterThanOrEqualTo(BigInt.zero));
    });

    test("Test (pendingReward)", () async {
      EtherAmount pendingReward = await stakeEngine.pendingReward(
        address: walletEngine.address(),
      );

      printDebug("""
pendingReward: ${pendingReward.getValueInDecimals(tokenData.decimals)}
        """);

      expect(pendingReward.getInWei, greaterThanOrEqualTo(BigInt.zero));
    });
  });

  Future<void> sendTransaction(TxDetailsData txDetails) async {
    // Transaction details
    Transaction tx = txDetails.tx;
    Map<String, dynamic>? abi = txDetails.abi;
    Map<String, dynamic>? args = txDetails.args;

    // Add gas fee
    TxGasDetailsData txGasDetails = await Provider.addGas(tx: tx);
    tx = txGasDetails.tx;
    Map<String, dynamic> txJson = txGasDetails.tx.toJson();
    EtherAmount estimateGas = txGasDetails.estimateGas;
    EtherAmount maxFee = txGasDetails.maxFee;
    EtherAmount total = txGasDetails.total;
    EtherAmount maxAmount = txGasDetails.maxAmount;

    // Send transaction
    String sendTransaction = await Provider.sendTransaction(
      credentials: credentials!,
      tx: tx,
    );

    printDebug("""
username: ${walletEngine.username()}
address: ${walletEngine.address()}
abi: $abi
args: $args
txJson: $txJson
estimateGas: ${estimateGas.getValueInUnit(EtherUnit.ether)}
maxFee: ${maxFee.getValueInUnit(EtherUnit.ether)}
total: ${total.getValueInUnit(EtherUnit.ether)}
maxAmount: ${maxAmount.getValueInUnit(EtherUnit.ether)}
txURL: ${Provider.getExploreUrl(sendTransaction)}
        """);

    expect(tx.from, equals(walletEngine.address()));
    expect(tx.to, equals(stakeData.contract));
    expect(tx.value, equals(EtherAmount.zero()));
    expect(tx.data, isNotNull);
    expect(tx.nonce, greaterThan(0));
    expect(tx.maxGas, greaterThan(21000));
    if (tx.isEIP1559) {
      expect(tx.maxPriorityFeePerGas!.getInWei, greaterThan(BigInt.zero));
      expect(tx.maxFeePerGas!.getInWei, greaterThan(BigInt.zero));
    } else {
      expect(tx.gasPrice!.getInWei, greaterThan(BigInt.zero));
    }
    expect(abi, isNotNull);
    expect(args, isNotNull);
    expect(txJson.length, equals(9));
    expect(estimateGas.getInWei, greaterThan(BigInt.zero));
    expect(maxFee.getInWei, greaterThanOrEqualTo(estimateGas.getInWei));
    expect(total.getInWei, greaterThan(BigInt.zero));
    expect(maxAmount.getInWei, greaterThanOrEqualTo(total.getInWei));
  }

  group("Stake Transaction Group:", () {
    test("Test (deposit)", () async {
      EtherAmount amount = EtherAmount.fromUnitAndValue(
        EtherAmount.getUintDecimals(tokenData.decimals),
        2,
      );
      TxDetailsData txDetails = await stakeEngine.deposit(
        amount: amount,
      );

      expect(txDetails.args?['_amount'], equals(amount.getInWei.toString()));

      try {
        await sendTransaction(txDetails);
      } catch (e) {
        throw Exception("Error: May need approval or insufficient amount");
      }
    });
  });
}
