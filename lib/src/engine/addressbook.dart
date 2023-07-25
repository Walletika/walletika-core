import 'package:aesdatabase/aesdatabase.dart';

import '../core/core.dart';
import '../models.dart';

/// Get all addresses book from database
Future<List<AddressBookData>> getAllAddressesBook() {
  return addressesBookDB
      .select()
      .map((row) => AddressBookData.fromJson(row.items))
      .toList();
}

/// Add a new address book to database
Future<void> addNewAddressBook(AddressBookData addressBookData) async {
  addressesBookDB.addRow(addressBookData.toJson());
  await addressesBookDB.dump();
}

/// Remove a address book from database
Future<bool> removeAddressBook(AddressBookData addressBook) async {
  bool isValid = false;

  await for (final DBRow row in addressesBookDB.select(
    items: addressBook.toJson(),
  )) {
    addressesBookDB.removeRow(row.index);
    await addressesBookDB.dump();
    isValid = true;
    break;
  }

  return isValid;
}
