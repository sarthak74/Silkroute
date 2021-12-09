import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/model/services/PaymentGatewayService.dart';
import 'package:silkroute/model/services/authservice.dart';
import 'package:silkroute/model/services/shiprocketApi.dart';
import 'package:silkroute/view/pages/reseller/crate.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/text_field.dart';
import 'package:silkroute/view/widget/topbar.dart';

class AddressPage extends StatefulWidget {
  AddressPage(
      {this.pageController, this.productlength, this.crateList, this.bill});
  final PageController pageController;
  final bool productlength;
  final dynamic crateList, bill;
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  LocalStorage storage = LocalStorage('silkroute');
  Razorpay _razorpay = new Razorpay();
  bool loading = true,
      _addressSave = false,
      canBeDelivered = false,
      _loadingDeliveryServiceabilityStatus = false,
      _proceeding = false;
  dynamic _order,
      _bill,
      _crateListM,
      _crateList,
      _title,
      amt,
      amtForRazor,
      courierData;
  Map<String, String> _deliveryServiceabilityStatus = {
    "title": "Enter a valid pincode to check status",
    "etd": "",
    "rate": ""
  };
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
    "addLine1": "Address Line 1"
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

  void checkDeliveryServiceabilityStatus() async {
    setState(() {
      _loadingDeliveryServiceabilityStatus = true;
    });

    print("pincode: ${data['pincode']}");
    // first argument has to be merchant pickup pincode and third is weight, 4th of cod and it has to be 0
    final res = await ShiprocketApi()
        .getDeliveryServiceStatus(210201, data['pincode'], 3, 0);
    if (res != null) {
      dynamic status = res['data']['available_courier_companies'];
      if (status.length > 0) {
        var f = status[0];

        setState(() {
          courierData = f;
          print("courier: ${courierData}");
          _deliveryServiceabilityStatus = {
            "title": "Product is deliverable at this location!",
            "etd": f['etd'].toString(),
            "rate": f['rate'].toString()
          };
          amt = (double.parse(_deliveryServiceabilityStatus["rate"]) +
              widget.bill['totalCost']);
          amt *= 100;
          amt = amt.floor();
          amt /= 100;
          amt = amt.toString();
          amtForRazor = (double.parse(amt) * 100).toString();
          amtForRazor = double.parse(amtForRazor.split(".")[0]);
          canBeDelivered = true;
          print("status: $_deliveryServiceabilityStatus");
          _loadingDeliveryServiceabilityStatus = false;
        });
      } else {
        setState(() {
          canBeDelivered = false;
          _deliveryServiceabilityStatus = {
            "title": "Product is NOT deliverable!",
            "etd": "",
            "rate": ""
          };
          _loadingDeliveryServiceabilityStatus = false;
        });
      }
    }
  }

  Future<bool> addressSaveHandler() async {
    setState(() {
      _addressSave = true;
    });
    var req = ["fullName", "contact", "pincode", "state", "city", "addLine1"];
    for (String x in req) {
      if (data[x].length < 1) {
        Toast().notifyErr(titleOf[x] + " is required");
        setState(() {
          _addressSave = false;
        });
        return false;
      }
    }
    await storage.setItem('address', data);
    setState(() {
      _addressSave = false;
    });
    print("address saved");
    return true;
  }

  void loadVars() async {
    print("totalCost: ${widget.bill['totalCost']}");
    if (widget.productlength == false) {
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
    var preAdd = await storage.getItem('address');
    setState(() {
      if (preAdd != null) {
        for (var x in fields) {
          print("pre-- $x");
          if (preAdd[x] != null) {
            data[x] = preAdd[x];
          }
        }
        if (data["pincode"].length == 6) {
          checkDeliveryServiceabilityStatus();
        }
      }
      _crateList = widget.crateList;
      _crateListM = [];

      for (var i in _crateList) {
        var r = i.toMap();
        _crateListM.add(r);
      }

      // print("_cratelistM: $_crateListM");
      _title = widget.crateList[0].toMap()["title"];
      _bill = widget.bill;
      loading = false;
    });
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
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: loading
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
                  CustomTextField(
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //// PinCode

                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.only(top: 20),
                        child: CustomTextField(
                          "Pincode*",
                          "Pincode",
                          false,
                          (val) {
                            setState(() {
                              data['pincode'] = val.toString();
                              if (data['pincode'].length == 6) {
                                checkDeliveryServiceabilityStatus();
                              } else {
                                canBeDelivered = false;
                                _deliveryServiceabilityStatus = {
                                  "title":
                                      "Enter a valid pincode to check status",
                                  "etd": "",
                                  "rate": ""
                                };
                              }
                            });
                          },
                          initialValue: data["pincode"],
                        ),
                      ),

                      //// Use My Location

                      GestureDetector(
                        onTap: null,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF5B0D1B),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.location_city,
                                size: 15,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Use My Location",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //// PinCode

                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.only(top: 20),
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
                        ),
                      ),
                      //// PinCode

                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.only(top: 20),
                        child: CustomTextField(
                          "City*",
                          "City",
                          false,
                          (val) {
                            setState(() {
                              data['city'] = val.toString();
                            });
                          },
                          initialValue: data["city"],
                        ),
                      ),
                    ],
                  ),

                  /////  AddLine1
                  SizedBox(height: 20),
                  CustomTextField(
                    "Address Line 1*",
                    "Address Line 1",
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
                  CustomTextField(
                    "Address Line 2",
                    "Address Line 2",
                    false,
                    (val) {
                      setState(() {
                        data['addLine2'] = val.toString();
                      });
                    },
                    initialValue: data["addLine2"],
                  ),

                  //// SAVE

                  // TODO: Delivery Serviceability Status

                  (data["pincode"].length == 6)
                      ? (_loadingDeliveryServiceabilityStatus
                          ? SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: Color(0xFF5B0D1B),
                              ),
                            )
                          : Column(
                              children: <Widget>[
                                SizedBox(height: 20),
                                Text(
                                  _deliveryServiceabilityStatus["title"],
                                  style: textStyle1(
                                    13,
                                    Colors.black54,
                                    FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Estimated Time: " +
                                      _deliveryServiceabilityStatus["etd"],
                                  style: textStyle1(
                                    13,
                                    Colors.black54,
                                    FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Rate: " +
                                      _deliveryServiceabilityStatus["rate"],
                                  style: textStyle1(
                                    13,
                                    Colors.black54,
                                    FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "Amount to be paid: " + amt,
                                  style: textStyle1(
                                      15, Colors.black87, FontWeight.normal),
                                ),
                                SizedBox(height: 20),
                              ],
                            ))
                      : SizedBox(height: 20),

                  GestureDetector(
                    onTap: canBeDelivered
                        ? () async {
                            var res = await addressSaveHandler();
                            print("_proceeding $res");
                            if (res) {
                              setState(() {
                                _proceeding = true;
                              });
                              await initOrder();
                              // dynamic res = await createtShiprocketOrder();
                              // print("created orfer red : $res");
                            }
                          }
                        : () {
                            Toast().notifyErr(
                                "Product is not deliverable or Invalid Pincode");
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
                                  color: canBeDelivered
                                      ? Color(0xFF5B0D1B)
                                      : Colors.grey[200],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text(
                                  _proceeding
                                      ? "Loading"
                                      : "Save & Proceed to Payment",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: canBeDelivered
                                          ? Colors.white
                                          : Colors.black54,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
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

  Future<dynamic> createtShiprocketOrder(String order_id) async {
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
      "order_items": _crateListM.map((item) => toShiprocketItem(item)).toList(),
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
    dynamic status = null;
    if ((res == null) || (res['status'] != 1)) {
      Toast().notifyErr(
          "Some error occurred, refund is in process.\nDon't worry, we are working on it.");
      return;
      // TODO: implement refund
    } else {
      status = {
        "pickup_scheduled_date": res['payload']['pickup_scheduled_date'],
        "awb_code": res['payload']['awb_code'],
        "assigned_date_time": res['payload']["assigned_date_time"],
        "applied_weight": res['payload']["applied_weight"],
        "label_url": res['payload']["label_url"],
        "manifest_url": res['payload']["manifest_url"],
        "routing_code": res['payload']["routing_code"]
      };
      var qry = {
        'shipment_id': res['payload']['shipment_id'],
        'shiprocket_order_id': res['payload']['order_id'],
        'merchant': _merchant['contact'],
        'status': status
      };
      await OrderApi().updateOrder(_id, qry);
    }

    print("status : $status");

    return status;
  }

  // Payment Methods

  Future<void> initOrder() async {
    print("amtforrazor: $amtForRazor");
    _id = await PaymentGatewayService().generateOrderId(
        key, secret, int.parse(amtForRazor.toString().split('.')[0]));

    print("\norder_id: $_id\n");
    var addr = await storage.getItem('address');
    setState(() {
      _bill['totalCost'] = double.parse(amt);
      _bill['logistic'] = double.parse(_deliveryServiceabilityStatus['rate']);
      print("cratelist M in orders\n$_crateListM");
      _order = {
        "contact": data['contact'],
        "items": _crateListM,
        "paymentStatus": "Initiated",
        "address": addr,
        "ratingGiven": 0.0,
        "reviewGiven": 0.0,
        "bill": _bill,
        "title": _title + ((_crateListM.length > 0) ? ", ..." : ""),
        "dispatchDate": "",
        "invoiceNumber": _id
      };
    });
    var res = await OrderApi().setOrder(_order);
    print("in payement, ${res['success']}");

    print("in payement, ${res['cd']}");

    if (res['success']) {
      setState(() {
        final f = new DateFormat('yyyy-MM-dd hh:mm');

        _date = f.format(DateTime.parse(res['cd'].toString())).toString();
        print("date-qq: $_date");
        _dbid = res['id'];
      });
      Toast().notifySuccess("Order Initiated");

      checkOut(res);
    } else {
      Toast().notifyErr("Some error occurred");
    }
  }

  void checkOut(res) async {
    var options = {
      "key": key,
      "amount": amtForRazor,
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
    dynamic status = await createtShiprocketOrder(res.orderId);
    // Map<String, dynamic> status = {
    //   "pickup_scheduled_date": "res['payload']['pickup_scheduled_date']",
    //   "awb_code": "res['payload']['awb_code']",
    //   "assigned_date_time": "res['payload']['assigned_date_time']",
    //   "applied_weight": "res['payload']['applied_weight']",
    //   "label_url": "res['payload']['label_url']",
    //   "manifest_url": "res['payload']['manifest_url']",
    //   "routing_code": "res['payload']['routing_code']"
    // };

    print("razorpay_payment_id ${res.paymentId}");

    status["razorpay_paymentId"] = res.paymentId;
    status["razorpay_signature"] = res.signature;
    status["razorpay_orderId"] = res.orderId;
    await OrderApi().updateOrder(_id, {
      "paymentStatus": "Completed",
      "latestStatus": "Order Placed",
      "status": status
    });
    setState(() {
      _proceeding = false;
    });
    Toast().notifySuccess("Payment Successful");
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
