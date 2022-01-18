import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/core/ProductDetail.dart';
import 'package:silkroute/model/services/ProductDetailApi.dart';
import 'package:silkroute/model/services/authservice.dart';

class PaymentGatewayService {
  var key = "rzp_test_XGLJQQbg9CfbPJ", secret = 'wzwPMXY3An2S8SPrmrnwrikM';
  Razorpay _razorpay = new Razorpay();
  LocalStorage storage = LocalStorage('silkroute');

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

  Future payout(data) async {
    try {
      print("payout - $data");
    } catch (e) {
      print("payout error - $e");
      return e;
    }
  }

  Future createContact(data) async {
    try {
      print("raz add contact - $data");
      var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));
      print("authn: $authn");
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': authn,
      };
      var body = await json.encode(data);

      var uri = 'https://api.razorpay.com/v1/contacts';
      var url = Uri.parse(uri);

      dynamic res = await http.post(url, headers: headers, body: body);

      res = json.decode(res.body);
      print("res: $res");
      return res;
    } catch (e) {
      print("raz add contact error - $e");
      return e;
    }
  }

  Future createFundAccount(data) async {
    try {
      print("raz add fund acc - $data");
      var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));
      print("authn: $authn");
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': authn,
      };

      var body = await json.encode(data);

      var uri = 'https://api.razorpay.com/v1/fund_accounts';
      var url = Uri.parse(uri);

      dynamic res = await http.post(url, headers: headers, body: body);

      res = json.decode(res.body);
      print("res: $res");
      return res;
    } catch (e) {
      print("raz add fund acc error - $e");
      return e;
    }
  }

  // fund acc validation transaction

  // direct transfer (from our acc to merchant acc)

  Future directTransfer(Map<String, dynamic> data) async {
    try {
      print("direct transfer $data");
      var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));
      print("authn: $authn");
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': authn,
      };
      var body = await json.encode(data);
      var uri = 'https://api.razorpay.com/v1/transfers';
      var url = Uri.parse(uri);
      dynamic res = await http.post(url, headers: headers, body: body);
      res = json.decode(res.body);
      print("res: $res");
      return {'success': true, 'res': res};
    } catch (err) {
      print("direct transfer err $err");
      return {'success': false, 'err': err};
    }
  }

  Future paymentTransfer(dynamic transfers, String payment_id) async {
    try {
      print("payment transfer $transfers");

      var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));
      print("authn: $authn");
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': authn,
      };
      var body = await json.encode({"transfers": transfers});
      var uri =
          'https://api.razorpay.com/v1/payments/' + payment_id + '/transfers';
      var url = Uri.parse(uri);
      print("url: $url");
      dynamic res = await http.post(url, headers: headers, body: body);
      print("res: $res");
      res = json.decode(res.body);
      print("res: $res");
      // if (res.statusCode != 200)
      //   throw Exception('http.post error: statusCode= ${res.statusCode}');
      // print('ORDER ID response => ${res.body}');

      return {'success': true, 'res': res};
    } catch (err) {
      print("payment transfer err $err");
      return {'success': false, 'err': err};
    }
  }

  Future createVirtualAccount(orderId) async {
    try {
      LocalStorage storage = await LocalStorage('silkroute');
      var contact = await storage.getItem('contact');
      print('createVirtualAcc contact: $contact\norder: $orderId');
      var body = await json.encode({"contact": contact, "orderId": orderId});
      var uri = Math().ip() + "/razorpay/virtualAccount/create";
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(uri);
      print("url: $url");
      dynamic res = await http.post(url, body: body, headers: headers);
      print("res: $res");
      res = json.decode(res.body);
      print("res: $res");
      if (res['success'] == false) {
        Toast().notifyErr(
            "Some error occurred\nPlease try after sometime or contact us");
      }
      return res;
    } catch (err) {
      print("createVirtualAcc err: $err");
      return {'success': false, 'err': err};
    }
  }

  Future releaseHold(razorpayItemId) async {
    try {
      print('relesehold raz item id: $razorpayItemId');
      var body = await json.encode({"on_hold": false});
      var uri = 'https://api.razorpay.com/v1/transfers/$razorpayItemId';
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(uri);

      dynamic res = await http.post(url, body: body, headers: headers);
      print("res: $res");
      res = json.decode(res.body);
      print("res: $res");

      return res;
    } catch (err) {
      print("createVirtualAcc err: $err");
      return {'success': false, 'err': err};
    }
  }
}
