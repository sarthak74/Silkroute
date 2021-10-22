import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Razorpay _razorpay = new Razorpay();
  bool loading = true;

  void loadVars() {
    setState(() {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess() {
    Toast().notifySuccess("Payment Successful");
    print("\nsuccess7408159898111\n");
  }

  void _handlePaymentError() {
    Toast().notifyErr("Payment Failed");
    print("\nfailed\n");
  }

  void _handleExternalWallet() {
    Toast().notifySuccess("External Wallet Payment");
    print("\nexternal\n");
  }

  void checkOut() {
    var options = {
      "key": "rzp_test_XGLJQQbg9CfbPJ",
      "amount": (1234) * 100,
      "name": "7408159898",
      "descrition": "Payment to 7408159898",
      "prefill": {"contact": "7408159898", "amount": 1234},
      "external": {
        "wallets": ["paytm"]
      }
    };
    try {
      _razorpay.open(options);
    } catch (err) {
      print("checkout err -  $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: loading
          ? Text("Loading")
          : Column(
              children: <Widget>[
                Text(
                  "Amount to be Paid: 1234",
                  style: textStyle(13, Colors.black),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    checkOut();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xFF5B0D1B)),
                    child: Text(
                      "Proceed to Checkout",
                      style: textStyle(13, Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
