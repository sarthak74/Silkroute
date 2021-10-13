import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/User.dart';

class ResellerProfileApi {
  LocalStorage storage = LocalStorage('silkroute');

  setProfile(body) async {
    try {
      //Reseller user = storage.user
      var user = storage.getItem('user');
      var uri = Math().ip();
      var url = Uri.parse(uri + '/resellerApi/editDetails');
      final res = await http.post(url, body: body);
      var decodedRes = jsonDecode(res.body);
    } catch (e) {
      print("error - $e");
    }
  }
}
