import 'package:flutter/material.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/model/services/PaymentGatewayService.dart';
import 'package:silkroute/model/services/shiprocketApi.dart';

class PaymentMethods {
  requestReturn(razorpay_paymentId, refund_amount) async {
    // var shiprocketRes = await ShiprocketApi().cancelOrder(order);
    print("cancelling order: $razorpay_paymentId");

    var params = {"id": razorpay_paymentId, "amount": refund_amount};
    var razorpayRes = await PaymentGatewayService().requestRefund(params);

    print("--- $razorpayRes");
    // razorpayRes is Exception ? print("y") : print("n");
    if (razorpayRes is Exception) {
      print("Something wrong happend");
      Toast().notifyErr(
          "Error occurred while requesting refund amount, Contact owner immediately");
      return;
    }
    // await OrderApi().updateOrder(order["invoiceNumber"], {
    //   "latestStatus": "Cancelled",
    //   "paymentStatus": "Pending Refund",
    //   "status": status
    // });
    print("Updated");
    return;
  }
}

// Possible EventEmitter memory leak detected.
