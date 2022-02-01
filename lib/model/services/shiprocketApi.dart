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

  Future<bool> authenticate() async {
    var shiprocket_auth = await storage.getItem('shiprocket_auth');
    dynamic token, timestamp;
    if (shiprocket_auth == null) {
      final res = await ShiprocketApi().getToken();
      if (res == null) {
        return false;
      }
      token = res['token'];
      timestamp = DateTime.now().toLocal().toIso8601String();

      shiprocket_auth = {"token": token, "timestamp": timestamp};
      await storage.setItem('shiprocket_auth', shiprocket_auth);
    } else {
      var token = shiprocket_auth['token'];
      dynamic timestamp = DateTime.parse(shiprocket_auth['timestamp']);
      print("t, a = $token\n $timestamp");
      var now = DateTime.now();
      final diff = (now.difference(timestamp).inHours.floor());
      print("diff: $diff");
      if (diff > 20) {
        final res = await ShiprocketApi().getToken();
        if (res == null) {
          return false;
        }
        token = res['token'];
        timestamp = DateTime.now().toLocal().toIso8601String();
        shiprocket_auth = {"token": token, "timestamp": timestamp};
        await storage.setItem('shiprocket_auth', shiprocket_auth);
      }
    }
    return true;
  }

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

      var shiprocket_auth = await storage.getItem('shiprocket_auth');
      var _token = shiprocket_auth['token'];
      var _headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token"
      };

      var _url =
          Uri.parse(Math().ip() + "/shiprocketApi/checkDeliveryServiceability");

      final res = await http.post(_url, headers: _headers, body: _body);

      var decoded = await jsonDecode(res.body);
      print("dec: $decoded");
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
      print("Create ShhipRocket Order $order");
      var _body = json.encode(order);

      var shiprocket_auth = await storage.getItem('shiprocket_auth');
      var _token = shiprocket_auth['token'];
      print("shiprocket_auth: $shiprocket_auth");
      var _headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token"
      };

      var _uri = dotenv.env['shiprocket_create_order_api'];
      var _url = Uri.parse(_uri);
      print("_url: $_url");

      final res = await http.post(_url, headers: _headers, body: _body);
      print("res $res");
      var decoded = await jsonDecode(res.body);
      print("decoded $decoded");

      return decoded;
    } catch (err) {
      print("create order err -- $err");
    }
  }

  Future<dynamic> cancelOrder(order) async {
    try {
      print("Cancel ShhipRocket Order");
      var _body = json.encode(order);

      var shiprocket_auth = await storage.getItem('shiprocket_auth');
      var _token = shiprocket_auth['token'];
      var _headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token"
      };

      var _uri = dotenv.env['shiprocket_cancel_order_api'];
      var _url = Uri.parse(_uri);

      final res = await http.post(_url, headers: _headers, body: _body);

      var decoded = await jsonDecode(res.body);

      return decoded;
    } catch (err) {
      print("create order err -- $err");
    }
  }

  Future<dynamic> getAllPickupLocations() async {
    try {
      print("get all pickup loca");
      var shiprocket_auth = await storage.getItem('shiprocket_auth');
      var _token = shiprocket_auth['token'];
      var _headers = {"Authorization": "Bearer $_token"};

      var _uri = dotenv.env['shiprocket_get_all_pickup_locations_api'];
      var _url = Uri.parse(_uri);

      final res = await http.get(_url, headers: _headers);

      var decoded = await jsonDecode(res.body);

      return decoded;
    } catch (err) {
      print("get all pick loc err - $err");
      return null;
    }
  }

  Future<dynamic> requestNewPickupLocation(data) async {
    try {
      print("req new pickup loca");
      var shiprocket_auth = await storage.getItem('shiprocket_auth');
      var _token = shiprocket_auth['token'];
      var _headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token"
      };

      var _uri = dotenv.env['shiprocket_add_new_pickup_location_api'];
      var _url = Uri.parse(_uri);

      final res = await http.post(_url, headers: _headers, body: data);

      var decoded = await jsonDecode(res.body);

      return decoded;
    } catch (err) {
      print("req new pick loc err - $err");
      return null;
    }
  }

  Future<dynamic> getChannels() async {
    try {
      print("get channels");
      var shiprocket_auth = await storage.getItem('shiprocket_auth');
      var _token = shiprocket_auth['token'];
      var _headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token"
      };

      var _uri = dotenv.env['shiprocket_get_channels_api'];
      var _url = Uri.parse(_uri);

      final res = await http.get(_url, headers: _headers);

      var decoded = await jsonDecode(res.body);

      return decoded["data"];
    } catch (err) {
      print("get channels err - $err");
      return null;
    }
  }

  // requests from backend

  Future createShiprocketOrder(order) async {
    try {
      print("create ship order: $order");
      var uri = Math().ip();
      var url = Uri.parse(uri + '/shiprocketApi/createShiprocketOrderWrapper');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      var res = await http.post(url,
          headers: headers, body: await json.encode(order));
      var decoded = await jsonDecode(res.body);
      if (decoded['success']) {
        Toast().notifySuccess("Order Successfully shipped");
      } else {
        Toast().notifyErr("Some error occurred");
      }

      return decoded;
    } catch (err) {
      print("create ship err: $err");
      return {"success": false, "err": err};
    }
  }
}
