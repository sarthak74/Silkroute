import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:http/http.dart' as http;
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/core/package.dart';

class PackagesApi {
  LocalStorage storage = LocalStorage('silkroute');
  var endPoint = Math().ip() + "/packages";

  Future<List<Package>> getAllPackages() async {
    try {
      var contact = await storage.getItem('contact');
      print("get all packages by: $contact");
      String token = await storage.getItem('token');
      var headers = {"Authorization": token};
      var uri = endPoint + "/allPackages/" + contact.toString();
      var url = Uri.parse(uri);
      var res = await http.get(url, headers: headers);
      var decoded = jsonDecode(res.body);
      List<Package> packs = [];
      for (var x in decoded['data']) {
        packs.add(Package.fromMap(x));
      }
      // print("decodedRes $decoded");
      // Toast().notifyInfo(decoded['msg']);
      return packs;
    } catch (err) {
      print("getallpacks err $err");
      return null;
    }
  }

  Future create() async {
    try {
      print("create pack");
      var contact = await storage.getItem('contact');
      var data = {"contact": contact};
      String token = await storage.getItem('token');
      var headers = {"Authorization": token};
      var url = Uri.parse(endPoint + '/create/' + contact);
      final res =
          await http.post(url, headers: headers, body: jsonEncode(data));
      var decoded = jsonDecode(res.body);
      Toast().notifyInfo(decoded['msg']);
      return decoded;
    } catch (err) {
      print("create pack err $err");
    }
  }

  Future addItem(packageId, items) async {
    try {
      print("add Item to pack");
      var data = {"packageId": packageId, "items": items};
      String token = await storage.getItem('token');
      var headers = {
        "Authorization": token,
        "Content-type": "application/json"
      };
      var url = Uri.parse(endPoint + '/addItem');
      final res =
          await http.post(url, headers: headers, body: jsonEncode(data));
      var decoded = jsonDecode(res.body);
      Toast().notifyInfo(decoded['msg']);
      return decoded['success'];
    } catch (err) {
      print("add Item to pack err $err");
      return false;
    }
  }

  Future removeItem(data) async {
    try {
      print("rmv item from pack $data");
      String token = await storage.getItem('token');
      var headers = {
        "Authorization": token,
        "Content-type": "application/json"
      };
      var url = Uri.parse(endPoint + '/removeItem');
      final res =
          await http.post(url, headers: headers, body: jsonEncode(data));
      var decoded = jsonDecode(res.body);
      Toast().notifyInfo(decoded['msg']);
      return decoded['success'];
    } catch (err) {
      print("rmv Item from pack err $err");
      return false;
    }
  }

  Future clear(id) async {
    try {
      print("clear pack $id");
      String token = await storage.getItem('token');
      var headers = {
        "Authorization": token,
        "Content-type": "application/json"
      };
      var url = Uri.parse(endPoint + '/clear/' + id);
      final res = await http.post(url, headers: headers);
      var decoded = jsonDecode(res.body);
      // Toast().notifyInfo(decoded['msg']);
      return decoded;
    } catch (err) {
      print("rmv Item from pack err $err");
      return false;
    }
  }

  Future delete(id) async {
    try {
      print("delete pack $id");
      String token = await storage.getItem('token');
      var headers = {
        "Authorization": token,
        "Content-type": "application/json"
      };
      var url = Uri.parse(endPoint + '/delete/' + id);
      final res = await http.post(url, headers: headers);
      var decoded = jsonDecode(res.body);
      Toast().notifyInfo(decoded['msg']);
      return decoded;
    } catch (err) {
      print("delete pack err $err");
      return false;
    }
  }
}
