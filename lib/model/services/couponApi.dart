import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:silkroute/methods/math.dart';
import 'package:http/http.dart' as http;

class CouponApi {
  Future<dynamic> getCoupons(String contact, num orderAmount) async {
    try {
      dynamic data = {'contact': contact, 'orderAmount': orderAmount};
      dynamic body = await json.encode(data);
      print("getcoupons data: $data");
      print("body $body");
      var headers = {"Content-Type": "application/json"};
      var url = Uri.parse(Math().ip() + '/resellerApi/getCoupons');
      final res = await http.post(url, body: body, headers: headers);
      var decodedRes2 = jsonDecode(res.body);
      return decodedRes2['coupons'];
    } catch (e) {
      print("get coupons e: $e");
      return null;
    }
  }

  Future<dynamic> useCoupons(contact, coupons) async {
    try {
      dynamic data = {'contact': contact, 'coupons': coupons};
      dynamic body = await json.encode(data);
      print("usecoupons data: $data");
      print("body $body");
      var headers = {"Content-Type": "application/json"};
      var url = Uri.parse(Math().ip() + '/resellerApi/useCoupons');
      final res = await http.post(url, body: body, headers: headers);
      var decodedRes2 = jsonDecode(res.body);
      return decodedRes2;
    } catch (e) {
      print("get coupons e: $e");
      return null;
    }
  }
}
