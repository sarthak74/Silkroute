import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';

class NotificationApi {
  LocalStorage storage = LocalStorage('silkroute');
  Future saveNotification(data) async {
    try {
      print("save notification $data");
      var contact = await storage.getItem('contact');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      data["contact"] = contact;

      var uri = Uri.parse(Math().ip() + "/notifications/save");
      dynamic res =
          await http.post(uri, headers: headers, body: json.encode(data));
      print("res: $res");
    } catch (e) {
      print("save notfication err -- $e");
    }
  }

  Future<dynamic> getNotifications() async {
    try {
      print("get notifications: ");
      String contact = await storage.getItem('contact');
      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      var uri = Uri.parse(Math().ip() + "/notifications/get/$contact");
      dynamic res = await http.get(uri, headers: headers);
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
