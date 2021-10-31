import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/OrderListItem.dart';

class OrderApi {
  LocalStorage storage = LocalStorage('silkroute');

  Future<List<OrderListItem>> getOrders() async {
    try {
      var reqBody = {"contact": storage.getItem("contact")};
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/getOrders');
      final res = await http.post(url, body: reqBody);
      var decodedRes2 = jsonDecode(res.body);
      List<OrderListItem> resp = [];
      print("decodedRes2 $decodedRes2");
      for (var i in decodedRes2) {
        print("items: ${i['items']}");
        OrderListItem r = OrderListItem.fromMap(i);
        resp.add(r);
      }
      return resp;
    } catch (e) {
      print("Get Order error - $e");
      return e;
    }
  }

  Future<dynamic> setOrder(order) async {
    try {
      var data = order;
      print("Set order data -  $data");
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/setOrder');
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      print("Set order res -  ${res.body}");
      var decodedRes2 = jsonDecode(res.body);
      print("Set order res -  $decodedRes2");
      print("Set order res -  ${decodedRes2['success']}");
      return decodedRes2;
    } catch (e) {
      print("Set Order error - $e");
      return {"success": false};
    }
  }

  Future<dynamic> updateOrder(id, body) async {
    try {
      var data = {"id": id, "qry": body};
      print("Update order data -  $data");
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/updateOrder');
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      print("Update order res -  ${res.body}");
      var decodedRes2 = jsonDecode(res.body);
      print("Update order res -  $decodedRes2");
      print("Update order res -  ${decodedRes2['success']}");
      return decodedRes2;
    } catch (e) {
      print("Update Order error - $e");
      return e;
    }
  }
}
