import 'package:flutter/material.dart';
import 'package:silkroute/provider/NewProductProvider.dart';

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
    var ip_universal = "https://yibrance-backend.herokuapp.com";
    var ip_local = "http://localhost:4000";
    var ip_usb = "http://192.168.1.8:4000";
    var ip_emulator = "http://10.0.2.2:4000";
    return ip_usb;
  }

  double aspectRatio(context) {
    double aspectRatio = 1.45 *
        (MediaQuery.of(context).size.width *
            0.86 /
            MediaQuery.of(context).size.height);
    return aspectRatio;
  }

  double getHalfSetPrice() {
    // Half set price calculation
    double price = NewProductProvider.setSize * 150.12;
    return price;
  }

  double getFullSetPrice() {
    // Full set price calculation
    double price = NewProductProvider.setSize * 277.12;
    return price;
  }
}

/*
Helper: WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProductDetails();
    });

₹
*/
