import 'package:aesdatabase/aesdatabase.dart';

import '../core/core.dart';
import '../models.dart';

Stream<AddressBookData> getAllAddressesBook() async* {
  await for (final DBRow row in addressesBookDB.select()) {
    yield AddressBookData.fromJson(row.items);
  }
}

Future<void> addNewAddressBook(AddressBookData addressBookData) async {
  addressesBookDB.addRow(addressBookData.toJson());
  await addressesBookDB.dump();
}

Future<bool> removeAddressBook(AddressBookData addressBook) async {
  bool result = false;

  await for (final DBRow row in addressesBookDB.select(
    items: addressBook.toJson(),
  )) {
    addressesBookDB.removeRow(row.index);
    await addressesBookDB.dump();
    result = true;
    break;
  }

  return result;
}
