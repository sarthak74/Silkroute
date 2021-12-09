import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentGatewayService {
  var key = "rzp_test_XGLJQQbg9CfbPJ", secret = 'wzwPMXY3An2S8SPrmrnwrikM';
  Razorpay _razorpay = new Razorpay();

  Future<String> generateOrderId(String key, String secret, int amount) async {
    try {
      print("in generateOrder");
      var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));
      print("authn: $authn");
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': authn,
      };

      var data =
          '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!

      var uri = 'https://api.razorpay.com/v1/orders';
      var url = Uri.parse(uri);

      var res = await http.post(url, headers: headers, body: data);
      if (res.statusCode != 200)
        throw Exception('http.post error: statusCode= ${res.statusCode}');
      print('ORDER ID response => ${res.body}');

      return json.decode(res.body)['id'].toString();
    } catch (e) {
      print("Get Order id error - $e");
      return e;
    }
  }

  Future<dynamic> requestRefund(dynamic params) async {
    try {
      print("in generateOrder");
      var body = await json.encode(params);
      var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));
      print("authn: $authn");
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': authn,
      };

      var uri =
          'https://api.razorpay.com/v1/payments/' + params['id'] + '/refund';
      var url = Uri.parse(uri);
      print("url: $url");
      dynamic res = await http.post(url, headers: headers, body: body);
      print("res: $res");
      res = json.decode(res.body);
      print("res: $res");
      // if (res.statusCode != 200)
      //   throw Exception('http.post error: statusCode= ${res.statusCode}');
      // print('ORDER ID response => ${res.body}');

      return json.decode(res.body)['id'].toString();
    } catch (e) {
      print("refund Order error - $e");
      return e;
    }
  }
}
