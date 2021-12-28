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
  Future<bool> check(context) async {
    dynamic user = await storage.getItem('user');
    for (String x in accDetails) {
      if (user[x] == null) {
        return false;
      }

      if (user[x].length == 0) {
        return false;
      }
    }
    return true;
  }
}
