import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';

class FirebaseService {
  LocalStorage storage = LocalStorage('silkroute');

  Future<String> generateToken() async {
    print("generate fcm token:");
    FirebaseMessaging.instance.getToken().then((newtoken) async {
      print("$newtoken");
      await FirebaseService().saveToken(newtoken);
      await storage.setItem('fcmtoken', newtoken);
      return newtoken.toString();
    });
  }

  Future<dynamic> getToken() async {
    print("get fcmtoken");
    String fcmtoken = await storage.getItem('fcmtoken');
    if (fcmtoken == null) {
      fcmtoken = await FirebaseService().generateToken();
    }
    return fcmtoken;
  }

  Future saveToken(fcmtoken) async {
    try {
      var contact = await storage.getItem('contact');
      dynamic data = {'token': fcmtoken};
      dynamic body = await json.encode(data);
      print("save fcm token: $contact\n$data");
      print("body $body");

      String token = await storage.getItem('token');
      var headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      var url = Uri.parse(Math().ip() + '/fcm/token/$contact');
      final res = await http.put(url, body: body, headers: headers);
      var decodedRes2 = jsonDecode(res.body);
      return decodedRes2;
    } catch (e) {
      print("save fcm token e: $e");
      return null;
    }
  }

  Future sendNotification(data) async {
    try {
      print("sendNotif $data");
      dynamic body = await json.encode(data);
      String token = await storage.getItem('token');
      var headers = {"Authorization": token};
      var url = Uri.parse(Math().ip() + '/fcm/sendNotification');
      final res = await http.put(url, body: body, headers: headers);
      var decodedRes2 = jsonDecode(res.body);
      return decodedRes2;
    } catch (e) {
      print("send notif e: $e");
      return null;
    }
  }
}
