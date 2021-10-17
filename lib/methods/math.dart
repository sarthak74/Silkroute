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
    return "http://localhost:4000";
    // return "http://192.168.43.220:4000";
  }

  double aspectRatio(context) {
    double aspectRatio = 1.45 *
        (MediaQuery.of(context).size.width *
            0.86 /
            MediaQuery.of(context).size.height);
    return aspectRatio;
  }
}

/*
Helper: WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProductDetails();
    });

₹
*/
