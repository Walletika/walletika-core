import 'package:aesdatabase/aesdatabase.dart';
import 'package:web3dart/web3dart.dart';

import '../core/core.dart';
import '../models.dart';

Stream<AddressBookModel> getAllAddressesBook() async* {
  await for (final DBRow row in addressesBookDB.select()) {
    yield AddressBookModel.fromJson(row.items);
  }
}

Future<bool> addNewAddressBook({
  required String username,
  required EthereumAddress address,
}) async {
  addressesBookDB.addRow({
    DBKeys.username: username,
    DBKeys.address: address.hexEip55,
  });
  await addressesBookDB.dump();

  return true;
}

Future<bool> removeAddressBook(AddressBookModel addressBook) async {
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
