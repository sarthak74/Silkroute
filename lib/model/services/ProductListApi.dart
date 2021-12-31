import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/ProductList.dart';

class ProductListApi {
  LocalStorage storage = LocalStorage('silkroute');
  Future<List<ProductList>> getProductList() async {
    try {
      var data = {
        "contact": await storage.getItem('contact'),
      };
      var uri = Math().ip();
      var url = Uri.parse(uri + '/manufacturerApi/getAllProducts');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res = await http.post(url, body: data, headers: headers);
      var decodedRes2 = jsonDecode(res.body);
      List<ProductList> resp = [];
      for (var i in decodedRes2) {
        ProductList r = ProductList.fromMap(i);
        resp.add(r);
      }
      return resp;
    } catch (e) {
      print("error - $e");
      return e;
    }
  }

  Future<dynamic> getProductInfo(pId) async {
    try {
      var reqBody = {"id": pId};
      var uri = Math().ip();
      var url = Uri.parse(uri + '/manufacturerApi/getProductInfo');
      String token = await storage.getItem('token');
      var headers = {"Authorization": token};
      final res = await http.post(url, body: reqBody, headers: headers);
      dynamic product = jsonDecode(res.body);
      // dynamic fp = ProductList.toMap(product);
      return product;
    } catch (e) {
      print("error - $e");
      return e;
    }
  }

  Future getTopPicks() async {
    try {
      var uri = Math().ip();
      var userType = await storage.getItem('userType');
      var route = userType == "Reseller" ? "resellerApi" : "manufacturerApi";
      var url = Uri.parse(uri + '/' + route + '/getTopPicks');
      String token = await storage.getItem('token');

      var headers = {"Authorization": token};

      final res = await http.get(url, headers: headers);
      print("res $res");
      var decodedRes = jsonDecode(res.body);

      var decodedRes2 = decodedRes["products"];
      print("dec $decodedRes2");

      return decodedRes2;
    } catch (err) {
      print("get top picks err $err");
      return null;
    }
  }

  Future<List<ProductList>> getProdListfromCat(sortBy, filter) async {
    try {
      var data = {"sortBy": sortBy, "filter": filter};
      print("data $data");
      var uri = Math().ip();
      var userType = await storage.getItem('userType');
      var route = userType == "Reseller" ? "resellerApi" : "manufacturerApi";
      var url = Uri.parse(uri + '/' + route + '/getProdfromCat');
      String token = await storage.getItem('token');

      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };

      final res =
          await http.post(url, headers: headers, body: json.encode(data));
      print("res $res");
      var decodedRes2 = jsonDecode(res.body);
      print("dec $decodedRes2");
      List<ProductList> resp = [];
      for (var i in decodedRes2) {
        ProductList r = ProductList.fromMap(i);
        resp.add(r);
      }
      return resp;
    } catch (e) {
      print("error - $e");
      return e;
    }
  }

  Future<List<ProductList>> getProdListfromSearch(
      keyword, sortBy, filter) async {
    try {
      var data = {"keyword": keyword, "sortBy": sortBy, "filter": filter};

      print("data $data");
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/getProdfromSearch');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res =
          await http.post(url, headers: headers, body: json.encode(data));

      var decodedRes2 = jsonDecode(res.body);

      List<ProductList> resp = [];
      for (var i in decodedRes2) {
        ProductList r = ProductList.fromMap(i);
        resp.add(r);
      }
      print("posted $resp");
      return resp;
    } catch (e) {
      print("error - $e");
      return e;
    }
  }
  // also consider implementation of sorting & filtering

}
