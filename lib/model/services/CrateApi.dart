import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/Bill.dart';
import 'package:silkroute/model/core/CrateListItem.dart';

class CrateApi {
  LocalStorage storage = LocalStorage('silkroute');
  String endpoint = Math().ip();

  Future<Tuple<List<CrateListItem>, Bill>> getCrateItems() async {
    try {
      var contact = await storage.getItem('contact');
      var data = {'contact': contact};
      print("get crate items: $data");
      String token = await storage.getItem('token');
      var headers = {"Authorization": token};
      var url = Uri.parse(Math().ip() + '/crateApi/getAllProducts');
      final res = await http.post(url, body: data, headers: headers);
      var decodedRes2 = jsonDecode(res.body);

      List<CrateListItem> resp = [];
      for (var i in decodedRes2[0]) {
        CrateListItem r = CrateListItem.fromMap(i);

        resp.add(r);
      }
      print("resp: $resp");
      Bill bill = Bill.fromMap(decodedRes2[1]);

      return Tuple<List<CrateListItem>, Bill>(resp, bill);
    } catch (e) {
      print("get crate items error - $e");
      return e;
    }
  }

  setCrateItems(body) async {
    try {
      var data = body;
      print("Set Crate items body: $data");
      var url = Uri.parse(endpoint + '/crateApi/setItem');

      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res =
          await http.post(url, headers: headers, body: json.encode(data));
      print(res.statusCode);
    } catch (e) {
      print("Set crate items error - $e");
    }
  }

  editCrateItem(body) async {
    try {
      var data = body;
      print("edit Crate items body:\n$data");
      var url = Uri.parse(endpoint + '/crateApi/editItem');

      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res =
          await http.post(url, headers: headers, body: json.encode(data));
      print(res.statusCode);
    } catch (e) {
      print("edit crate items error - $e");
    }
  }

  removeCrateItem(id) async {
    try {
      var data = {"id": id, "contact": storage.getItem('contact')};
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      var url = Uri.parse(endpoint + '/crateApi/removeItem');
      final res =
          await http.post(url, headers: headers, body: json.encode(data));
      print(res.statusCode);
    } catch (e) {
      print("error - $e");
    }
  }
}

class Tuple<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple(
    this.item1,
    this.item2,
  );
}
