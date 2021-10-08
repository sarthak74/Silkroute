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
}
