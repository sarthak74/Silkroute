import 'package:flutter/material.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/model/services/PaymentGatewayService.dart';
import 'package:silkroute/model/services/shiprocketApi.dart';

class PaymentMethods {
  cancelPayment(order, cut_logistic) async {
    // var shiprocketRes = await ShiprocketApi().cancelOrder(order);
    print("cancelling order: $order");
    dynamic status = order['status'];
    if (status == null) {
      status = {};
    }
    double refund_amt = order['bill']['totalCost'] -
        (cut_logistic ? order['bill']['logistic'] : 0);
    print(refund_amt);
    status['refund_amt'] = refund_amt;

    var params = {
      "id": order['status']['razorpay_paymentId'],
      "amount": refund_amt
    };
    var razorpayRes = await PaymentGatewayService().requestRefund(params);

    print("--- $razorpayRes");
    // razorpayRes is Exception ? print("y") : print("n");
    if (razorpayRes is Exception) {
      print("Something wrong happend");
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
