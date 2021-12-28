import 'dart:convert';

import 'package:silkroute/methods/math.dart';
import 'package:http/http.dart' as http;

class ExtraApi {
  getFAQs() {}
  getNotif() {}
  contactUs() {}
  privacyPolicy() {}

  Future getStatesData() async {
    try {
      print("get states data");
      var uri = Math().ip();
      var url = Uri.parse(uri + '/data/getStatesData');

      final res = await http.get(url);
      var decodedRes2 = jsonDecode(res.body);
      print("res: $decodedRes2");
      return decodedRes2;
    } catch (err) {
      print("get states data err $err");
      return err;
    }
  }
}
