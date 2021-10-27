import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentGatewayService {
  Future<String> generateOrderId(String key, String secret, int amount) async {
    print("in generateOrder");
    var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));
    print("authn: $authn");
    var headers = {
      'content-type': 'application/json',
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
  }
}
