## 4.0.5
- Removed WalletikaTokenEngine

## 4.0.4
- Provider connect method become sync and returns void
- Fix: aprCalculator function returns infinity value

## 4.0.3
- Fix: isSupportEIP1559 to check by value

## 4.0.2
- Code improvement for addNewTransaction function

## 4.0.1
- Get methods become returns future instead of stream
- Added aprCalculator function

## 4.0.0
- Dart 3 compatible
- Rename package name to `WalletikaCore`
- Convert `ContractEngine.contract` to be private
#### Database
- Default directory folder name become `storage`
- Rename `databaseLoader` function to `databaseInitialize`
#### Stake
- Added `stakesDataBuilder` function
- Removed `importStakeContracts` function
- Removed `startTime` and `endTime` from `stakeData`
#### Network and provider
- Use `NetworkData` with `addNewNetwork` function
- Added `isLocked` attribute to `NetworkData`
- Rename `Provider` to `ProviderEngine` and support singleton algorithm
- Added `blockTimeInSeconds` to `ProviderEngine`
- Added `estimatedBlockTime` to `ProviderEngine`
- Added `isSupportEIP1559` instead of `isEIP1559Supported` to `ProviderEngine`
- Move hex converting methods from `ProviderEngine` to utils
#### Address book
- Use `AddressBookData` with `addNewAddressBook` function
- Returns `void` instead `bool` for `addNewAddressBook` 
#### Wallet
- Added `type` attribute to `WalletData`
- returns `bool` for `setFavorite` method in `WalletEngine`