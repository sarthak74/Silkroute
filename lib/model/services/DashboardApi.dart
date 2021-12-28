import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/core/Bill.dart';
import 'package:silkroute/model/core/CrateListItem.dart';

class DashboardApi {
  Future<dynamic> getData() async {
    print("Dashborad getdata");
    try {
      LocalStorage storage = await LocalStorage('silkroute');
      String contact = await storage.getItem('contact');
      String userType = await storage.getItem('userType');
      print("$contact");
      String token = await storage.getItem('token');
      var headers = {"Authorization": token};
      var route = (userType == "Reseller") ? "resellerApi" : "manufacturerApi";
      var url = Uri.parse(Math().ip() + '/' + route + '/getDashboardData');
      final res =
          await http.post(url, body: {'contact': contact}, headers: headers);
      var decodedRes2 = jsonDecode(res.body);
      print("dash res: $decodedRes2");
      return decodedRes2['data'];
    } catch (e) {
      print("err - $e");
      Toast().notifyErr("Some error occurred\nPlease try again");
      return e;
    }
  }
}
