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
  void loadVars() async {}

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(),
    );
  }
}
