import 'package:flutter/material.dart';

class Math {
  static String getSp(num mrp, num discount) {
    num ans = (mrp * (100 - discount)) / 100;
    return ans.toString();
  }

  dynamic min(dynamic a, dynamic b) {
    if (a <= b) return a;
    return b;
  }

  dynamic max(dynamic a, dynamic b) {
    if (a >= b) return a;
    return b;
  }

  String ip() {
    return "http://192.168.43.220:4000";
  }
}

/*
Helper: WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProductDetails();
    });

*/
