import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/model/core/ProductList.dart';

class ProductListApi {
  LocalStorage storage = LocalStorage('silkroute');
  String endpoint = "192.168.43.220:4000";
  Future<List<ProductList>> getProductList() async {
    try {
      var data = {
        "contact": "7408159898",
      };
      var url = Uri.parse(
          'http://192.168.43.220:4000/manufacturerApi/getAllProducts');
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
}
