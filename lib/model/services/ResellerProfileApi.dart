import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/User.dart';

class ResellerProfileApi {
  LocalStorage storage = LocalStorage('silkroute');

  setProfile() async {
    try {
      //Reseller user = storage.user
      var reqBody = {
        //user
      };
      var uri = Math().ip();
      var url = Uri.parse(uri + '/x/y/z');
      final res = await http.post(url, body: reqBody);
      var decodedRes = jsonDecode(res.body);
    } catch (e) {
      print("error - $e");
    }
  }
}
