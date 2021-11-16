import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';

class Methods {
  LocalStorage storage = LocalStorage('silkroute');

  Future<bool> isAuthenticated() async {
    var contact = await storage.getItem('contact');

    if (contact != null) {
      if (contact.length != 10) {
        contact = null;
        storage.clear();
      }
    }
    print("isAuth -- $contact");
    return (contact != null && contact.length == 10);
  }

  dynamic getUser() async {
    var user = await storage.getItem('user');
    return user;
  }

  void logout(context) {
    storage.clear();
    print(
        "Logout \n Contact - ${storage.getItem('contact') == null ? "null" : "In"}");
    Navigator.of(context).pushNamed('/enter_contact');
  }
}
