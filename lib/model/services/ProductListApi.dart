import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/ProductList.dart';

class ProductListApi {
  LocalStorage storage = LocalStorage('silkroute');
  Future<List<ProductList>> getProductList() async {
    try {
      var data = {
        "contact": "7408159898",
      };
      var uri = Math().ip();
      var url = Uri.parse(uri + '/manufacturerApi/getAllProducts');
      final res = await http.post(url, body: data);
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
      final res = await http.post(url, body: reqBody);
      dynamic product = jsonDecode(res.body);
      // dynamic fp = ProductList.toMap(product);
      return product;
    } catch (e) {
      print("error - $e");
      return e;
    }
  }

  Future<List<ProductList>> getProdListfromCat(String cat) async {
    try {
      var data = {
        "Category": cat,
      };
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/getProdfromCat');
      final res = await http.post(url, body: data);
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

  Future<List<ProductList>> getProdListfromSearch(
      keyword, sortBy, filter) async {
    try {
      var data = {"keyword": keyword, "sortBy": sortBy, "filter": filter};

      print("data $data");
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/getProdfromSearch');

      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));

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
