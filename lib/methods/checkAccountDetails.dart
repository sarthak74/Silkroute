import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class AccountDetails {
  LocalStorage storage = LocalStorage('silkroute');
  List<String> accDetails = [
    "bankAccountNo",
    "accountHolderName",
    "email",
    "ifsc",
    "pickupAdd"
  ];
  Future<int> check(context) async {
    dynamic user = await storage.getItem('user');
    if (user['verified'] != true) {
      return 0;
    }
    for (String x in accDetails) {
      if (user[x] == null) {
        return 1;
      }

      if (user[x].length == 0) {
        return 1;
      }
    }
    return 2;
  }
}
