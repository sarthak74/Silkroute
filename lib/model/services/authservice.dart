import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/services/firebase.dart';

class AuthService {
  Dio dio = new Dio();
  // String uri = "http://localhost:4000/authenticate";

  String uri = Math().ip() + "/api";
  auth(contact) async {
    try {
      print("auth + $contact");
      Response res = await dio.post(uri + "/auth",
          data: {
            "contact": contact,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      print("auth res+ $res");
      var data = jsonDecode(res.toString());
      print("auth data+ $data");
      // var data = {
      //   "msg": "Otp Sent Succesfully",
      //   "token": "test",
      //   "success": true,
      //   "index": 2
      // };
      print(data);
      Fluttertoast.showToast(
        msg: data["msg"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.grey[500],
        fontSize: 10,
      );
      if (data["success"]) {
        return [true, data["token"]];
      } else {
        return [false];
      }
    } on DioError catch (err) {
      print("error - $err");
      Fluttertoast.showToast(
        msg: "server-side error, Please retry",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red,
        fontSize: 15,
      );
      print("Auth error");
      print(err.response);
    }
  }

  Future<dynamic> verifyotp(otp, token) async {
    try {
      var url = Uri.parse(uri + '/otpverify');
      var tosend = {"otp": otp};
      var res = await http.post(url,
          body: tosend, headers: {HttpHeaders.authorizationHeader: token});

      var dres = await jsonDecode(res.body);
      print("Otp response - \ndata -- $dres\nUser--${dres['user']}");

      LocalStorage storage = await LocalStorage('silkroute');

      String send = "";

      print("print ${dres['success']}");
      if (dres["success"]) {
        dynamic data = dres['user'];
        data["success"] = dres["success"];
        data["msg"] = dres["msg"];
        print("success");
        send += "1";
        await storage.clear();

        await storage.setItem('token', token.toString());

        await storage.setItem('contact', data['contact']);
        await storage.setItem('userType', data['userType']);
        await storage.setItem('name', data['name']);

        if (data['registered']) {
          print("reg");
          send += "1";

          if (data['fcmtoken'] == null) {
            data['fcmtoken'] = await FirebaseService().getToken();
          }

          print("Storage User -- $data");
        } else {
          send += "0";
        }
        await storage.setItem('user', data);
        Fluttertoast.showToast(
          msg: dres['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[100],
          textColor: Colors.grey[500],
          fontSize: 10,
        );
      } else {
        send += "00";
        Fluttertoast.showToast(
          msg: dres['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey[100],
          textColor: Colors.red,
          fontSize: 10,
        );
      }
      return send;
    } on DioError catch (err) {
      Fluttertoast.showToast(
        msg: err.response.data["msg"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red,
        fontSize: 10,
      );
    }
  }

  getinfo(contact) async {
    try {
      LocalStorage storage = await LocalStorage('silkroute');
      var url = Uri.parse(uri + '/getinfo');
      var tosend = {"contact": contact};
      String token = await storage.getItem('token');
      var headers = {"Authorization": token};
      final res = await http.post(url, body: tosend, headers: headers);
      print("getinfo res --  $res");
      var data = await jsonDecode(res.body);
      print("getinfo data --  $data");
      if (data["success"]) {
        return data["user"];
      } else {
        Fluttertoast.showToast(
          msg: "Some error occurred",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12,
        );
        return null;
      }
    } on DioError catch (err) {
      // Fluttertoast.showToast(
      //   msg: err.response.data['msg'],
      // );
      Fluttertoast.showToast(
        msg: "Some error occurred",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12,
      );
      return null;
    }
  }

  register(userData) async {
    try {
      Response res = await dio.post(
        uri + "/register",
        data: {
          "data": userData,
        },
      );
      var data = await jsonDecode(res.toString());

      LocalStorage storage = await LocalStorage('silkroute');
      print("register resp $data");
      // var data = {
      //   "success": true,
      //   "msg": "Invalid user Data",
      // };

      if (data["success"]) {
        Fluttertoast.showToast(
          msg: "Successfully Registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[100],
          textColor: Colors.grey[500],
          fontSize: 10,
        );
        await storage.clear();

        print("bef user --  $data");
        await storage.setItem('token', data['token'].toString());
        data = data["user"];
        await storage.setItem('contact', data['contact']);
        await storage.setItem('userType', data['userType']);
        await storage.setItem('name', data['name']);

        // var usr = await storage.getItem('user');
        if (data['fcmtoken'] == null) {
          data['fcmtoken'] = await FirebaseService().getToken();
        }
        // print("Storage User -- $usr");
        await storage.setItem('user', data);
        return true;
      } else {
        Fluttertoast.showToast(
          msg: data["msg"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[100],
          textColor: Colors.red,
          fontSize: 10,
        );
        return false;
      }
    } on DioError catch (err) {
      // Fluttertoast.showToast(
      //   msg: err.response.data['msg'],
      // );
      Fluttertoast.showToast(
        msg: err.response.data['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red,
        fontSize: 10,
      );
    }
  }

  dynamic updateUser(contact, userData) async {
    try {
      var url = Uri.parse(uri + '/updateUser');
      var tosend = await json.encode({"contact": contact, "data": userData});
      LocalStorage storage = await LocalStorage('silkroute');
      String token = await storage.getItem('token');
      final res = await http.post(url,
          headers: {"Content-Type": "application/json", "Authorization": token},
          body: tosend);
      print("updateUser res --  $res");
      var data = await jsonDecode(res.body);

      print("updateUser data --  $data, user: ${data['user']}");
      if (data["success"]) {
        Fluttertoast.showToast(
          msg: "User Updated Successfully",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12,
        );
        return data["user"];
      } else {
        Fluttertoast.showToast(
          msg: "Some error occurred",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12,
        );
        return null;
      }
    } on DioError catch (err) {
      // Fluttertoast.showToast(
      //   msg: err.response.data['msg'],
      // );
      Fluttertoast.showToast(
        msg: err.response.data['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red,
        fontSize: 10,
      );
      return null;
    }
  }

  Future<bool> checkVerificationStatus() async {
    try {
      LocalStorage storage = LocalStorage('silkroute');
      var contact = await storage.getItem('contact');
      var url = Uri.parse(uri + '/checkVerificationStatus');
      var tosend = await json.encode({"contact": contact});
      String token = await storage.getItem('token');
      final res = await http.post(url,
          headers: {"Content-Type": "application/json", "Authorization": token},
          body: tosend);
      print("updateUser res --  $res");
      var data = await jsonDecode(res.body);

      if (data["success"] == false) {
        Fluttertoast.showToast(
          msg: "Some Server error occurred",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10,
        );
        return false;
      }

      return data["verified"];
    } on DioError catch (err) {
      // Fluttertoast.showToast(
      //   msg: err.response.data['msg'],
      // );
      Fluttertoast.showToast(
        msg: err.response.data['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red,
        fontSize: 10,
      );
      return false;
    }
  }
}
