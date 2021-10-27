import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/core/OrderListItem.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/model/services/PaymentGatewayService.dart';
import 'package:silkroute/view/pages/reseller/crate.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({this.pageController, this.crateList, this.bill});
  final PageController pageController;
  final dynamic crateList, bill;
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Razorpay _razorpay = new Razorpay();
  bool loading = true, _proceeding = false;
  dynamic _order, _bill, _address, _crateList, _title;
  LocalStorage storage = LocalStorage('silkroute');

  void loadVars() async {
    _address = await storage.getItem('address');
    if (_address == null) {
      widget.pageController.animateToPage(
        1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      setState(() {
        CratePage().addressStatus = !CratePage().addressStatus;
      });
      Toast().notifyErr("Enter required fields in address");
      setState(() {
        loading = false;
      });
      return;
    }
    setState(() {
      _crateList = widget.crateList;
      // _crateListM = widget.crateList.map((item) => item.toMap());
      _title = widget.crateList[0].toMap()["title"];
      _bill = widget.bill;
      loading = false;
    });
    print("crateLit; $_title\n");
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    loadVars();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: loading
          ? Text("Loading")
          : Column(
              children: <Widget>[
                Text(
                  storage.getItem('name') +
                      ", (" +
                      storage.getItem('contact') +
                      ")",
                  style: textStyle1(13, Colors.black, FontWeight.w500),
                ),
                SizedBox(height: 20),
                Text(
                  "Amount to be Paid: " + _bill["totalCost"].toString(),
                  style: textStyle(17, Colors.black),
                ),
                SizedBox(height: 20),
                Text(
                  "Address:",
                  style: textStyle1(15, Colors.black, FontWeight.w500),
                ),
                Text(
                  _address["addLine1"],
                  style: textStyle1(13, Colors.black, FontWeight.w500),
                ),
                Text(
                  _address["city"] +
                      ", " +
                      _address["state"] +
                      ", " +
                      _address["pincode"],
                  style: textStyle1(13, Colors.black, FontWeight.w500),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _proceeding = true;
                    });
                    await initOrder();
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
                      _proceeding ? "Loading" : "Proceed to Checkout",
                      style: textStyle(13, Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _id;

  Future<void> initOrder() async {
    setState(() {
      _order = {
        "items": _crateList,
        "paymentStatus": "Initiated",
        "address": storage.getItem('address'),
        "ratingGiven": 0.0,
        "reviewGiven": 0.0,
        "bill": _bill,
        "title": _title + ", ...",
        "dispatchDate": "",
        "invoiceNumber": "",
        "payment Status": "",
      };
    });
    var res = await OrderApi().setOrder(_order);
    print("in payement, ${res['success']}");

    if (res['success']) {
      Toast().notifySuccess("Order Initiated");

      checkOut(res);
    } else {
      Toast().notifyErr("Some error occurred");
    }
  }

  void checkOut(res) async {
    dynamic amt =
        (double.parse(_bill["totalCost"].toString()) * 100).toString();
    amt = double.parse(amt.split(".")[0]);

    var key = "rzp_test_XGLJQQbg9CfbPJ", secret = 'wzwPMXY3An2S8SPrmrnwrikM';

    _id = await PaymentGatewayService()
        .generateOrderId(key, secret, int.parse(amt.toString().split('.')[0]));

    print("\norder_id: $_id\n");

    var options = {
      "key": key,
      "amount": amt,
      "name": "7408159898",
      "description": "Payment to 7408159898",
      "prefill": {"contact": "7408159898", "email": ''},
      "external": {
        "wallets": ["paytm"]
      },
      "order_id": _id,
    };
    try {
      _razorpay.open(options);
    } catch (err) {
      print("checkout err -  $err");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse res) async {
    print("res -- $res");

    _order["invoiceNumber"] = _id;
    _order["paymentStatus"] = "Successfull";

    await OrderApi().updateOrder(_id, _order);
    setState(() {
      _proceeding = false;
    });
    Toast().notifySuccess("Payment Successful");
  }

  void _handlePaymentError(PaymentSuccessResponse res) {
    setState(() {
      _proceeding = false;
    });
    Toast().notifySuccess("Payment Failed");
  }

  void _handleExternalWallet(PaymentSuccessResponse res) {
    setState(() {
      _proceeding = false;
    });
    Toast().notifySuccess("External");
  }
}
