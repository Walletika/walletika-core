import 'package:walletika_sdk/walletika_sdk.dart';

void main() async {
  String username = 'username';
  EthereumAddress address = EthereumAddress.fromHex(
    '0xC94EA8D9694cfe25b94D977eEd4D60d7c0985BD3',
  );

  // initialize walletika SDK
  await walletikaSDKInitialize();

  // Add new address book
  AddressBookData addressBookData = AddressBookData(
    username: username,
    address: address,
    dateCreated: DateTime.now(),
    salt: 'Enter unique salt value for verification',
  );
  await addNewAddressBook(addressBookData);

  // Get all addresses book
  List<AddressBookData> allAddressesBook = [
    await for (AddressBookData item in getAllAddressesBook()) item
  ];

  // Remove a address book
  await removeAddressBook(allAddressesBook[0]);
}
