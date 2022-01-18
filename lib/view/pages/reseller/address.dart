import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/notification_service.dart';
import 'package:silkroute/methods/payment_methods.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/CrateApi.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/model/services/PaymentGatewayService.dart';
import 'package:silkroute/model/services/authservice.dart';
import 'package:silkroute/model/services/couponApi.dart';
import 'package:silkroute/model/services/pincode_api.dart';
import 'package:silkroute/model/services/shiprocketApi.dart';
import 'package:silkroute/view/pages/reseller/crate.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/text_field.dart';
import 'package:silkroute/view/widget/topbar.dart';

class AddressPage extends StatefulWidget {
  AddressPage(
      {this.pageController,
      this.productlength,
      this.crateList,
      this.bill,
      this.pincode});
  final PageController pageController;
  final bool productlength;
  final dynamic crateList, bill;
  final String pincode;
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  LocalStorage storage = LocalStorage('silkroute');
  Razorpay _razorpay = new Razorpay();
  bool loading = true,
      _addressSave = false,
      canBeDelivered = false,
      _proceeding = false;
  dynamic _order,
      _bill,
      _crateListM,
      _crateList,
      pincodeAddress,
      amt,
      amtForRazor,
      courierData,
      user;
  List<String> localities = [];
  TextEditingController _pincodeController = new TextEditingController();
  // Map<String, String> _deliveryServiceabilityStatus = {
  //   "title": "Enter a valid pincode to check status",
  //   "etd": "",
  //   "rate": ""
  // };
  var data = {
    "fullName": "",
    "contact": "",
    "pincode": "",
    "state": "",
    "city": "",
    "addLine1": "",
    "addLine2": ""
  };
  var titleOf = {
    "fullName": "Full Name",
    "contact": "Phone Number",
    "pincode": "Pin Code",
    "state": "State",
    "city": "City",
    "addLine1": "Address Line 1",
    "addLine2": "Address Line 2"
  };
  var fields = [
    "fullName",
    "contact",
    "pincode",
    "state",
    "city",
    "addLine1",
    "addLine2"
  ];

  Future<bool> addressSaveHandler() async {
    setState(() {
      _addressSave = true;
    });
    var req = [
      "fullName",
      "contact",
      "pincode",
      "state",
      "city",
      "addLine1",
      "addLine2"
    ];
    for (String x in req) {
      if (data[x].length < 1) {
        Toast().notifyErr(titleOf[x] + " is required");
        setState(() {
          _addressSave = false;
        });
        return false;
      }
    }
    await storage.setItem('paymentAddress', data);
    setState(() {
      _addressSave = false;
    });
    print("address saved");
    return true;
  }

  void loadVars() async {
    // print("totalCost: ${widget.bill['totalCost']}");
    _pincodeController.text = widget.pincode;
    if (widget.productlength == false) {
      // print("false");
      widget.pageController.animateToPage(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      setState(() {
        CratePage().addressStatus = !CratePage().addressStatus;
      });
      Toast().notifyErr("Add some items to crate to proceed");
      setState(() {
        loading = false;
      });
      return;
    }

    data["pincode"] = widget.pincode;
    // print("preadding");
    var preAdd = await storage.getItem('paymentAddress');
    pincodeAddress = await PincodeApi().getAddress(widget.pincode);
    print("pincodeadd -- $pincodeAddress");
    user = await storage.getItem('user');

    setState(() {
      for (var add in pincodeAddress) {
        localities.add(add["Name"]);
      }
      data['addLine2'] = localities[0];
      data['fullName'] = user['name'];
      data['contact'] = user['contact'];
      data['state'] = pincodeAddress[0]['State'];
      data['city'] = pincodeAddress[0]['District'];
      // if (data["pincode"].length == 6) {
      //   checkDeliveryServiceabilityStatus();
      // }

      _crateList = widget.crateList;

      _crateListM = [];

      for (var i in _crateList) {
        var r = i.toMap();
        // print("cratelist items------ \n $r");
        _crateListM.add(r);
      }

      // print("_cratelistM: $_crateListM");

      _bill = widget.bill;
      loading = false;
    });
  }

  bool postpayment = false;

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
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: (loading || postpayment)
            ? Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Color(0xFF5B0D1B),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: <Widget>[
                  //// FULL NAME
                  SizedBox(height: 20),
                  CustomTextField(
                    "Full Name*",
                    "Full Name",
                    false,
                    (val) {
                      setState(() {
                        data['fullName'] = val.toString();
                      });
                    },
                    initialValue: data["fullName"],
                  ),

                  //// PHONE NUMBER
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //// phone number
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: CustomTextField(
                          "Phone Number*",
                          "Phone Number",
                          false,
                          (val) {
                            setState(() {
                              data['contact'] = val.toString();
                            });
                          },
                          initialValue: data["contact"],
                        ),
                      ),

                      //// PinCode

                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: TextFormField(
                          controller: _pincodeController,
                          enabled: false,
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                            labelText: "Pincode*",
                            hintText: "Pincode",
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          style: textStyle1(13, Colors.grey, FontWeight.w500),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //// PinCode

                      Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: CustomTextField(
                          "State*",
                          "State",
                          false,
                          (val) {
                            setState(() {
                              data['state'] = val.toString();
                            });
                          },
                          initialValue: data["state"],
                          enabled: false,
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: CustomTextField(
                          "City/Dist.*",
                          "City/Dist.",
                          false,
                          (val) {
                            setState(() {
                              data['city'] = val.toString();
                            });
                          },
                          initialValue: data["city"],
                          enabled: false,
                        ),
                      ),
                    ],
                  ),

                  /////  AddLine1
                  SizedBox(height: 20),
                  CustomTextField(
                    "Street*",
                    "House No, Area",
                    false,
                    (val) {
                      setState(() {
                        data['addLine1'] = val.toString();
                      });
                    },
                    initialValue: data["addLine1"],
                  ),

                  /////  AddLine2
                  SizedBox(height: 20),

                  (localities == null || localities.length == 0)
                      ? Text("Loading")
                      : DropdownSearch<String>(
                          mode: Mode.MENU,
                          showSelectedItems: true,
                          items: localities,
                          label: "Locality",
                          // selectedItem: pincodeAddress[0]["Name"],
                          onChanged: (val) {
                            setState(() {
                              data["addLine2"] = val.toString();
                            });
                          },
                          dropdownSearchDecoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          ),
                        ),

                  //// SAVE

                  // (data["pincode"].length == 6)
                  //     ? (_loadingDeliveryServiceabilityStatus
                  //         ? SizedBox(
                  //             height: 30,
                  //             width: 30,
                  //             child: CircularProgressIndicator(
                  //               color: Color(0xFF5B0D1B),
                  //             ),
                  //           )
                  //         : Column(
                  //             children: <Widget>[
                  //               SizedBox(height: 20),
                  //               Text(
                  //                 _deliveryServiceabilityStatus["title"],
                  //                 style: textStyle1(
                  //                   13,
                  //                   Colors.black54,
                  //                   FontWeight.normal,
                  //                 ),
                  //               ),
                  //               SizedBox(height: 10),
                  //               Text(
                  //                 "Estimated Time: " +
                  //                     _deliveryServiceabilityStatus["etd"],
                  //                 style: textStyle1(
                  //                   13,
                  //                   Colors.black54,
                  //                   FontWeight.normal,
                  //                 ),
                  //               ),
                  //               SizedBox(height: 10),
                  //               Text(
                  //                 "Rate: " +
                  //                     _deliveryServiceabilityStatus["rate"],
                  //                 style: textStyle1(
                  //                   13,
                  //                   Colors.black54,
                  //                   FontWeight.normal,
                  //                 ),
                  //               ),
                  //               Text(
                  //                 "Amount to be paid: " + amt,
                  //                 style: textStyle1(
                  //                     15, Colors.black87, FontWeight.normal),
                  //               ),
                  //               SizedBox(height: 20),
                  //             ],
                  //           ))
                  //     : SizedBox(height: 20),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      var res = await addressSaveHandler();
                      print("_proceeding $res");
                      if (res) {
                        setState(() {
                          _proceeding = true;
                        });
                        await initOrder();
                        setState(() {
                          _proceeding = false;
                        });
                        // dynamic res = await createtShiprocketOrder();
                        // print("created orfer red : $res");
                      }
                    },
                    child: _addressSave
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.05,
                            height: MediaQuery.of(context).size.width * 0.05,
                            child: CircularProgressIndicator(
                              color: Color(0xFF5B0D1B),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF5B0D1B),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text(
                                  _proceeding
                                      ? "Loading"
                                      : "Proceed to Payment",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      var orderId = await initOrder(flag: 1);
                      print("orderId");
                      await Helpers()
                          .showOfflineBankTransferDialog(context, orderId);
                    },
                    child: Text(
                      "Offline Bank Transfer?",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.grey,
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  String _id, _dbid, _date;
  dynamic _merchant;
  var key = "rzp_test_zbF9BwMKHoWRR6", secret = 'a4lLo5H9zbTY3PNU3ADvSWQt';

  Future<dynamic> getPickup() async {
    var allPickupLocations = await ShiprocketApi().getAllPickupLocations(),
        new_loc = false;
    List locations = [];
    for (var x in allPickupLocations["data"]["shipping_address"]) {
      locations.add(x["pickup_location"]);
    }
    var contact = await storage.getItem('contact');
    var merchant = await AuthService().getinfo(contact);
    setState(() {
      _merchant = merchant;
    });
    if (merchant == null) {
      Toast().notifyErr("Some error occurred");
      // refund
      return "";
    }
    var pickup_location = merchant['_id'].toString();

    if (!locations.contains(pickup_location)) {
      setState(() {
        new_loc = true;
      });
      var new_pickup_location = {
        "pickup_location": merchant['_id'].toString(),
        "name": merchant['name'],
        "email": merchant['_id'].toString() + "@gmail.com",
        "phone": merchant['contact'],
        "address": merchant['currAdd']['address'],
        "city": merchant['currAdd']['city'],
        "state": merchant['currAdd']['state'],
        "country": merchant['currAdd']['country'],
        "pin_code": merchant['currAdd']['pincode']
      };
      await ShiprocketApi().requestNewPickupLocation(new_pickup_location);
    }

    return {"new_loc": new_loc, "pickup_location": pickup_location};
  }

  Map<String, dynamic> toShiprocketItem(Map<String, dynamic> item) {
    Map<String, dynamic> newitem = item;
    newitem['sku'] = item['id'];
    newitem['selling_price'] = item['mrp'];
    newitem['units'] = item['quantity'];
    newitem['discount'] = item['discount'] ? item['discountValue'] : 0.00;
    return newitem;
  }

  Future<dynamic> createtShiprocketOrder(String order_id, dynamic item) async {
    print("order_id: $order_id");
    var pickup_location = await getPickup();
    print("pickup: $pickup_location");
    var channels = await ShiprocketApi().getChannels();

    var channel_id = channels[0]["id"];
    print("channel: $channel_id");

    // Billing - from
    // Shipping - to
    /*
    var data = {
      "fullName": "",
      "contact": "",
      "pincode": "",
      "state": "",
      "city": "",
      "addLine1": "",
      "addLine2": ""
    };
      */
    print("_merchant: $_merchant");
    var ship_order = {
      "order_id": order_id,
      "order_date": _date,
      "channel_id": channel_id,
      "pickup_location": pickup_location['pickup_location'], // manuf id\
      "billing_customer_name": _merchant['name'], // manuf name
      "billing_last_name": "",
      "billing_address": _merchant["currAdd"]["address"],
      "billing_city": _merchant['currAdd']['city'], // manuf city
      "billing_pincode": _merchant['currAdd']['pincode'],
      "billing_state": _merchant['currAdd']['state'],
      "billing_country": _merchant['currAdd']['country'],
      "billing_email": _merchant['_id'].toString() + "@gmail.com",
      "billing_phone": _merchant['contact'],

      "shipping_is_billing": false,
      "shipping_customer_name": data['fullName'], // cust name

      "shipping_address": data['addLine1'],

      "shipping_city": data['city'],
      "shipping_pincode": data['pincode'],
      "shipping_country": 'India',
      "shipping_state": data['state'],
      "shipping_email": data['contact'] + "@gmail.com",
      "shipping_phone": data['contact'],
      "order_items": [toShiprocketItem(item)],
      "payment_method": "Prepaid",

      "sub_total": widget.bill['totalCost'],
      "length": "30",
      "breadth": "30",
      "height": "30",
      "weight": "2",
    };

    if (pickup_location["new_loc"] == true) {
      ship_order["vendor_details"] = {
        "email": _merchant['_id'].toString() + "@gmail.com",
        "phone": _merchant['contact'],
        "name": _merchant['Name'],
        "address": _merchant['currAdd']['address'],
        "city": _merchant['currAdd']['city'],
        "state": _merchant['currAdd']['state'],
        "country": _merchant['currAdd']["country"],
        "pin_code": _merchant['currAdd']['pin_code'],
        "pickup_location": _merchant['_id'].toString()
      };
    }

    print("ship_order: $ship_order");

    final dynamic res = await ShiprocketApi().createOrder(ship_order);
    print("create_roder: $res");
    dynamic shiprocket_status = null;
    if ((res == null) || (res['status'] != 1)) {
      Toast().notifyErr(
          "Some error occurred, refund is in process.\nDon't worry, we are working on it.");
      return;
      // TODO: implement refund
    } else {
      shiprocket_status = {
        "pickup_scheduled_date": res['payload']['pickup_scheduled_date'],
        "awb_code": res['payload']['awb_code'],
        "assigned_date_time": res['payload']["assigned_date_time"],
        "applied_weight": res['payload']["applied_weight"],
        "label_url": res['payload']["label_url"],
        "manifest_url": res['payload']["manifest_url"],
        "routing_code": res['payload']["routing_code"]
      };
      var data = {
        'shipment_id': res['payload']['shipment_id'],
        'shiprocket_order_id': res['payload']['order_id'],
        'shiprocket': shiprocket_status
      };
    }

    return data;
  }

  // Payment Methods

  Future initOrder({flag = 0}) async {
    print("amtforrazor: $amtForRazor");
    amtForRazor = int.parse((_bill['totalCost'] * 100).toString());
    if (_crateListM[0]['orderId'] != null && _crateListM[0]['orderId'] != '') {
      _id = _crateListM[0]['orderId'];
    } else {
      _id = await PaymentGatewayService()
          .generateOrderId(key, secret, amtForRazor);
    }

    print("\norder_id: $_id\n");
    var addr = await storage.getItem('paymentAddress');
    await CrateApi().updateOrderId(_id);
    setState(() {
      // _bill['totalCost'] = double.parse(amt);
      // _bill['logistic'] = double.parse(_deliveryServiceabilityStatus['rate']);
      print("cratelist M in orders\n$_crateListM");
      for (int i = 0; i < _crateListM.length; i++) {
        _crateListM[i]['orderId'] = _id;
      }

      _order = {
        "contact": data['contact'],
        // "items": _crateListM,
        "title":
            _crateListM[0]["title"] + (_crateListM.length > 0 ? ", ..." : ""),
        "customerPaymentStatus": "Initiated",
        "address": addr,
        "bill": _bill,
        "dispatchDate": "",
        "invoiceNumber": _id
      };
    });
    var res = await OrderApi().setOrder(_order);
    print("in payement, ${res['success']}");

    print("in payement, ${res['cd']}");

    if (res['success']) {
      Toast().notifySuccess("Order Initiated");
      if (flag == 0) {
        checkOut(res);
      } else {
        print("ret order : $_id");
        return _id;
      }
    } else {
      Toast().notifyErr("Some error occurred");
    }
  }

  void checkOut(res) async {
    amtForRazor = _bill['totalCost'] * 100;
    print("amt for razor: $amtForRazor");
    var options = {
      "key": key,
      "amount": _bill['totalCost'] * 100,
      "name": user["name"],
      "description": "Payment to Yibrance",
      "prefill": {
        "contact": user['contact'],
        "email": 'not.required@gmail.com'
      },
      "readonly": {'email': true, 'contact': true},
      "options": {
        "checkout": {
          "method": {"netbanking": 1, "card": 1, "upi": 1, "wallet": 0}
        }
      },
      "config": {"display": "en"},
      "timeout": "599",
      "theme": {"hide_topbar": false},
      "order_id": _id,
      "modal": {"confirm_close": true, "escape": false}
    };
    print("optios: $options");
    try {
      _razorpay.open(options);
    } catch (err) {
      setState(() {
        _proceeding = false;
      });
      Toast().notifyErr("Payment Failed");
      print("checkout err -  $err");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse res) async {
    var ship_order_id = res.orderId.split("_")[1];
    setState(() {
      _proceeding = false;
      postpayment = true;
    });
    int i = 0;
    for (dynamic item in _crateListM) {
      // dynamic data = await createtShiprocketOrder(
      //     (ship_order_id + "_" + i.toString()).toString(), item);
      // dynamic data = {
      //   'shiprocket': {
      //     "pickup_scheduled_date": "res['payload']['pickup_scheduled_date']",
      //     "awb_code": "res['payload']['awb_code']",
      //     "assigned_date_time": "res['payload']['assigned_date_time']",
      //     "applied_weight": "res['payload']['applied_weight']",
      //     "label_url": "res['payload']['label_url']",
      //     "manifest_url": "res['payload']['manifest_url']",
      //     "routing_code": "res['payload']['routing_code']"
      //   },
      //   'shipment_id': ship_order_id + "_" + i.toString(),
      //   'shiprocket_order_id': ship_order_id + "_" + i.toString()
      // };
      // item['shiprocket'] = data['shiprocket'];
      // item['shipment_id'] = data['shipment_id'];
      // item['shiprocket_order_id'] = data['shiprocket_order_id'];
      item['customerStatus'] = "Order Placed";
      item['merchantStatus'] = 'Not Seen';
      item['merchantPaymentStatus'] = "Incomplete";
      await OrderApi().addOrderItem(_id, item);

      print("item ${i.toString()} shiprocket status:\n$item");
    }

    // Map<String, dynamic> status = {
    //   "pickup_scheduled_date": "res['payload']['pickup_scheduled_date']",
    //   "awb_code": "res['payload']['awb_code']",
    //   "assigned_date_time": "res['payload']['assigned_date_time']",
    //   "applied_weight": "res['payload']['applied_weight']",
    //   "label_url": "res['payload']['label_url']",
    //   "manifest_url": "res['payload']['manifest_url']",
    //   "routing_code": "res['payload']['routing_code']"
    // };

    DateTime now = DateTime.now();

    var data = {
      "title": "Order Initiated",
      "body": "Your order with id $_id has been initiated!",
      "messageId": _id,
      "sentTime": now.toString()
    };

    await NotificationService().Notify(data);

    print("razorpay_payment_id ${res.paymentId}");
    Map<String, String> raz = {};
    raz["razorpay_paymentId"] = res.paymentId;
    raz["razorpay_signature"] = res.signature;
    raz["razorpay_orderId"] = res.orderId;
    raz["amount_paid"] = _bill['totalCost'].toString(); // in rs

    await OrderApi().updateOrder(_id, {
      "customerPaymentStatus": "Completed",
      "status": "Order Placed",
      "razorpay": raz
    });
    await CouponApi().useCoupons(user['contact'], _bill['couponsApplied']);

    await PaymentMethods()
        .splitPaymentAmongMerchants(_id, _crateListM, res.paymentId);

    setState(() {
      postpayment = false;
    });
    Toast().notifySuccess("Shipment Successful");
    Navigator.popAndPushNamed(context, "/crate");
  }

  void _handlePaymentError(PaymentSuccessResponse res) {
    setState(() {
      _proceeding = false;
    });
    Toast().notifyErr("Payment Failed");
  }

  void _handleExternalWallet(PaymentSuccessResponse res) {
    setState(() {
      _proceeding = false;
    });
    Toast().notifyInfo("External");
  }
}
