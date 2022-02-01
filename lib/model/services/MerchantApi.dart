import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/MerchantOrderItem.dart';
import 'package:silkroute/model/core/OrderListItem.dart';
import 'package:silkroute/model/core/ProductList.dart';

class MerchantApi {
  LocalStorage storage = LocalStorage('silkroute');
  dynamic addNewProduct(product) async {
    try {
      var data = product;
      print("Add new product $product");
      var uri = Math().ip();

      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      var url = Uri.parse(uri + '/manufacturerApi/addProduct');
      final res =
          await http.post(url, headers: headers, body: json.encode(data));
      // var id = res.body.toString();
      print("resp: ${res.body}");
      // print("resp: ${decodedRes2[0].id}");
      return res.body;
    } catch (e) {
      print("error - $e");
      return e;
    }
  }

  Future<dynamic> getMerchantOrders(sortBy, filter, orderType) async {
    try {
      var data = {
        "contact": await storage.getItem("contact"),
        "sortBy": sortBy,
        "filter": filter,
        "orderType": orderType
      };
      var uri = Math().ip();
      var url = Uri.parse(uri + '/manufacturerApi/getMerchantOrders');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res =
          await http.post(url, headers: headers, body: json.encode(data));
      var decodedRes2 = jsonDecode(res.body);
      // print("mer orders: $decodedRes2");
      dynamic resp = decodedRes2;
      // for (var i in decodedRes2) {
      //   var order = i;
      //   order["items"] =
      //       i["items"].map((item) => MerchantOrderItem.fromMap(item)).toList();
      //   resp.add(order);
      // }
      print("mer orders: $resp");
      return resp;
    } catch (e) {
      print("error - $e");
      return null;
    }
  }

  Future<dynamic> getMerchantReturnOrders() async {
    try {
      var data = {
        "contact": await storage.getItem("contact"),
        "sortBy": {"createdDate": 1},
        "orderType": true
      };
      var uri = Math().ip();
      var url = Uri.parse(uri + '/manufacturerApi/getMerchantOrders');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res =
          await http.post(url, headers: headers, body: json.encode(data));
      var decodedRes2 = jsonDecode(res.body);
      // print("mer orders: $decodedRes2");
      List<dynamic> resp = [];
      for (var i in decodedRes2) {
        var order = i;
        // order["items"] =
        //     i["items"].map((item) => MerchantOrderItem.fromMap(item)).toList();
        resp.add(order);
      }
      print("mer orders: $resp");
      return resp;
    } catch (e) {
      print("error - $e");
      return null;
    }
  }

  Future<dynamic> getPendingOrders() async {
    try {
      print("get pending orders");
      var data = {"contact": await storage.getItem("contact")};
      var uri = Math().ip();
      var url = Uri.parse(uri + '/manufacturerApi/getPendingOrders');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );

      var decodedRes2 = jsonDecode(res.body);
      print("mer orders: $decodedRes2");
      List<MerchantOrderItem> resp = [];
      for (var i in decodedRes2) {
        print("mer order: $i");
        MerchantOrderItem r = MerchantOrderItem.fromMap(i);
        resp.add(r);
      }
      print("mer orders: $resp");
      return resp;
    } catch (e) {
      print("get pending orders error - $e");
      return e;
    }
  }

  Future<dynamic> updateProduct(Map<String, dynamic> body) async {
    try {
      print("update product");
      var data = body;
      var uri = Math().ip();
      var url = Uri.parse(uri + '/manufacturerApi/updateProduct');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );
      var decodedRes2 = jsonDecode(res.body);

      print("update product result: $decodedRes2");
      return decodedRes2;
    } catch (e) {
      print("update product err: $e");
      return e;
    }
  }

  Future<dynamic> deleteProduct(Map<String, dynamic> body) async {
    try {
      print("delete product");
      var data = body;
      var uri = Math().ip();
      var url = Uri.parse(uri + '/manufacturerApi/deleteProduct');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );
      var decodedRes2 = jsonDecode(res.body);

      print("update product result: $decodedRes2");
      return decodedRes2;
    } catch (e) {
      print("update product err: $e");
      return e;
    }
  }
}
