import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/ProductList.dart';

class MerchantHomeApi {
  LocalStorage storage = LocalStorage('silkroute');
  Future<List<ProductList>> getProductList() async {
    try {
      String contact = await storage.getItem('contact');
      var data = {
        "contact": contact,
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

  Future<List<ProductList>> getEightProducts() async {
    try {
      String contact = await storage.getItem('contact');
      var data = {
        "contact": contact,
      };
      var uri = Math().ip();
      var url = Uri.parse(uri + '/manufacturerApi/getEightProducts');
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

  getTopSelling() {}
  getcategories() {}
}
