import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/toast.dart';

class ShiprocketApi {
  LocalStorage storage = LocalStorage('silkroute');
  Dio dio = new Dio();

  Future<dynamic> getToken() async {
    try {
      String ship_email = await dotenv.env['shiprocket_email'];
      String shiprocket_password = await dotenv.env['shiprocket_password'];
      String shiprocket_auth_api = await dotenv.env['shiprocket_auth_api'];
      var _headers = {"Content-Type": "application/json"};
      var _data = {"email": ship_email, "password": shiprocket_password};
      var _body = await json.encode(_data);
      var _url = Uri.parse(shiprocket_auth_api);
      final res = await http.post(_url, headers: _headers, body: _body);
      var decoded = jsonDecode(res.body);
      print("getToken decoded res: $decoded");
      return decoded;
    } catch (err) {
      print("gettoken err -- $err");
      return null;
    }
  }

  Future<dynamic> getDeliveryServiceStatus(
      pickup_postcode, delivery_postcode, weight, cod) async {
    try {
      print("getDeliveryServiceStatus--");
      var _data = {
        'pickup_postcode': int.parse(pickup_postcode.toString()),
        'delivery_postcode': int.parse(delivery_postcode.toString()),
        'weight': int.parse(weight.toString()),
        'cod': 0
      };
      var _body = json.encode(_data);

      var shiprocket_auth = storage.getItem('shiprocket_auth');
      var _token = shiprocket_auth['token'];
      var _headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token"
      };

      var _url =
          Uri.parse(Math().ip() + "/shiprocketApi/checkDeliveryServiceability");

      final res = await http.post(_url, headers: _headers, body: _body);

      var decoded = await jsonDecode(res.body);

      return decoded;
    } catch (err) {
      print("getDeliveryServiceStatus err --  $err");
      Toast().notifyErr(
          "Some error occurred. Don't worry we are onto it.\nTill then, try Logging in again or contact helpline.");
      return null;
    }
  }

  Future<dynamic> createOrder(order) async {
    try {
      var _body = json.encode(order);

      var shiprocket_auth = storage.getItem('shiprocket_auth');
      var _token = shiprocket_auth['token'];
      var _headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token"
      };

      var _uri = dotenv.env['shiprocket_create_order_api'];
      var _url = Uri.parse(_uri);

      final res = await http.post(_url, headers: _headers, body: _body);

      var decoded = await jsonDecode(res.body);

      return decoded;
    } catch (err) {
      print("create order err -- $err");
    }
  }
}
