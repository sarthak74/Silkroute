import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/ProductList.dart';

class ProductDetailApi {
  LocalStorage storage = LocalStorage('silkroute');

  Future<dynamic> getProductInfo(pId) async {
    try {
      var reqBody = {"id": pId};
      var uri = Math().ip();
      var url = Uri.parse(uri + '/manufacturerApi/getProductInfo');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      final res = await http.post(url, body: reqBody, headers: headers);
      dynamic product = jsonDecode(res.body);
      // dynamic fp = ProductList.toMap(product);
      return product;
    } catch (e) {
      print("error - $e");
      return e;
    }
  }
}
