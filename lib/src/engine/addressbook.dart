import 'package:aesdatabase/aesdatabase.dart';
import 'package:web3dart/web3dart.dart';

import '../core/core.dart';
import '../models.dart';

Future<List<AddressBookModel>> getAllAddressesBook() async {
  List<AddressBookModel> result = [];

  await for (RowModel row in addressesBookDB.select()) {
    AddressBookModel addressBook = AddressBookModel.fromJson(row.items);
    result.add(addressBook);
  }

  return result;
}

Future<bool> addNewAddressBook({
  required String username,
  required EthereumAddress address,
}) {
  return Future(() {
    addressesBookDB.insertSync(
      rowIndex: addressesBookDB.countRowSync(),
      items: {
        "username": username,
        "address": address.hexEip55,
      },
    );

    addressesBookDB.dumpSync();

    return true;
  });
}

Future<bool> removeAddressBook(AddressBookModel addressBook) async {
  bool result = false;

  await for (RowModel row in addressesBookDB.select(
    items: addressBook.toJson(),
  )) {
    addressesBookDB.removeRowSync(row.index);
    addressesBookDB.dumpSync();
    result = true;
    break;
  }

  return result;
}
