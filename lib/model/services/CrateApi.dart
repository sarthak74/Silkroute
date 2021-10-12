import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/model/core/Bill.dart';
import 'package:silkroute/model/core/CrateListItem.dart';

class CrateApi {
  LocalStorage storage = LocalStorage('silkroute');
  String endpoint = "http://192.168.43.220:4000";

  Future<Tuple<List<CrateListItem>, Bill>> getCrateItems() async {
    try {
      var data = {'contact': storage.getItem('contact')};
      var url = Uri.parse(endpoint + '/crateApi/getAllProducts');
      final res = await http.post(url, body: data);
      print("res: $res");
      var decodedRes2 = jsonDecode(res.body);
      print("decodedRes2: $decodedRes2");
      List<CrateListItem> resp = [];
      for (var i in decodedRes2[0]) {
        CrateListItem r = CrateListItem.fromMap(i);
        resp.add(r);
      }
      print("resp: $resp");
      Bill bill = Bill.fromMap(decodedRes2[1]);
      print("bill: $bill");
      return Tuple<List<CrateListItem>, Bill>(resp, bill);
    } catch (e) {
      print("error - $e");
      return e;
    }
  }

  setCrateItems(body) async {
    try {
      var data = body;
      print("Set Crate items body: $data");
      var url = Uri.parse(endpoint + '/crateApi/setItem');
      print("1");
      final res = await http.post(url, body: data);
      print("1");
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
