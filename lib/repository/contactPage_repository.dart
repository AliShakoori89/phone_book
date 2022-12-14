

import 'package:phone_book/database/database.dart';
import 'package:phone_book/model/contact_model.dart';

class ContactRepository {
  Future<List> getAllContactsRepo() async {
    var helper = DatabaseHelper();

    return await helper.getAllContacts();
  }

  Future<Contact> getContactRepo(int id) async {
    var helper = DatabaseHelper();
    print("hi id is ");
    print(id);
    return await helper.getContact(id);
  }

  Future<bool> saveContactRepo(Contact contact) async {
    var helper = DatabaseHelper();
    return await helper.saveContact(contact);
  }

  Future<int> deleteContactRepo(int id) async {
    print('deleteContactRepo id ');
    print(id);
    var helper = DatabaseHelper();
    return await helper.deleteContact(id);
  }

  Future<int> updateContactRepo(Contact contact) async {
    var helper = DatabaseHelper();
    return await helper.updateContact(contact);
  }

  Future<List> fetchFavoriteContacts() async {
    var helper = DatabaseHelper();
    print('1111111111111111${helper.fetchFavorite()}');
    return await helper.fetchFavorite();
  }

  Future<int> addFavoriteContactRepo(Contact contact) async {
    var helper = DatabaseHelper();
    return await helper.isFavorite(contact);
  }

  Future closeRepo() async {
    var helper = DatabaseHelper();
    helper.close();
  }
}
