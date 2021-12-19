import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';

class NotificationApi {
  LocalStorage storage = LocalStorage('silkroute');
  Future saveNotification(data) async {
    try {
      print("save notification $data");
      String contact = await storage.getItem('contact');
      var body = {"contact": contact, "data": data};
      var headers = {"Content-Type": "application/json"};
      var uri = Uri.parse(Math().ip() + "/notifications/save");
      dynamic res =
          await http.post(uri, headers: headers, body: json.encode(body));
      print("res: $res");
      return res;
    } catch (e) {
      print("save notfication err -- $e");
      return e;
    }
  }

  Future<dynamic> getNotifications() async {
    try {
      print("get notifications: ");
      String contact = await storage.getItem('contact');
      var uri = Uri.parse(Math().ip() + "/notifications/get/$contact");
      dynamic res = await http.get(uri);
      // print("res: $res");
      var decoded = json.decode(res.body);

      // print("res: $decoded");
      return decoded['notifications'];
    } catch (e) {
      print("get notifications err: $e");
      return e;
    }
  }
}
