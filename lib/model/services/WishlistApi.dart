import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/ProductList.dart';

class WishlistApi {
  LocalStorage storage = LocalStorage('silkroute');

  setWishlist() async {
    try {
      var user = storage.getItem('user');
      var data = {
        'contact': storage.getItem('contact'),
        'wishlist': user['wishlist'].toString()
      };
      print("setWishlist $data");
      var uri = Math().ip();
      var url = Uri.parse(uri + '/userApi/setWishlist');
      final res = await http.post(url, body: data);
      print("res $res");
    } catch (e) {
      print("error - $e");
    }
  }

  Future<List<ProductList>> getProd() async {
    // function to get product given list of ids in wishlist
    try {
      List<ProductList> products = [];
      var user = storage.getItem('user');
      var wishlists = user['wishlist'];
      for (String pId in wishlists) {
        var reqBody = {"id": pId};
        var uri = Math().ip();
        var url = Uri.parse(uri + '/manufacturerApi/getProductInfo');
        final res = await http.post(url, body: reqBody);
        dynamic product = jsonDecode(res.body);
        ProductList fp = ProductList.fromMap(product);
        products.add(fp);
      }
      return products;
    } catch (err) {
      print("error - $err");
      return err;
    }
  }
}
