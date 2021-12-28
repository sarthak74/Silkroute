import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/model/services/PaymentGatewayService.dart';
import 'package:silkroute/model/services/authservice.dart';
import 'package:silkroute/model/services/shiprocketApi.dart';

class PaymentMethods {
  LocalStorage storage = LocalStorage('silkroute');
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

  Future addContact(data) async {
    try {
      var contact = await storage.getItem('contact');

      final dynamic addContactData = {
        "contact": contact,
        "email": data["email"]
      };
      final dynamic res =
          await PaymentGatewayService().createContact(addContactData);
      final dynamic addFundData = {
        "contact_id": res["id"],
        "account_type": "bank_account",
        "bank_account": {
          "name": data["accountHolderName"],
          "ifsc": data["ifsc"],
          "account_number": data["bankAccountNo"]
        }
      };
      await PaymentGatewayService().createFundAccount(addFundData);

      // fund account validation transaction validation

      Map<String, dynamic> updateData = {"razorpayContactId": res["id"]};
      await AuthService().updateUser(contact, updateData);
    } catch (err) {
      return {"success": false, "err": err};
    }
  }
}

// Possible EventEmitter memory leak detected.
