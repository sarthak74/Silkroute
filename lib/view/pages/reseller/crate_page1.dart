import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/CrateApi.dart';
import 'package:silkroute/model/services/couponApi.dart';
import 'package:silkroute/model/services/shiprocketApi.dart';
import 'package:silkroute/provider/CrateProvider.dart';
import 'package:silkroute/view/dialogBoxes/CouponDialogBox.dart';
import 'package:silkroute/view/pages/reseller/crate.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/crate_product_tile.dart';
import 'package:silkroute/view/widget/flutter_dash.dart';
import 'package:silkroute/view/widget/show_dialog.dart';
import 'package:silkroute/view/widget/text_field.dart';

class CratePage1 extends StatefulWidget {
  CratePage1(
      {this.pageController,
      this.products,
      this.bill,
      this.setPincode,
      this.pincode});
  final PageController pageController;
  final dynamic products, bill;
  final String pincode;
  final dynamic setPincode;
  @override
  _CratePage1State createState() => _CratePage1State();
}

class _CratePage1State extends State<CratePage1> {
  List products = [];
  bool loading = true,
      loadingBill = true,
      canBeDelivered = false,
      _loadingDeliveryServiceabilityStatus = false;
  String pincode;
  dynamic bill,
      _coupons,
      orderAmount,
      price,
      priceData = {
        'logisticsSaving': 0,
        'finalLogistic': 0,
        'totalCost': 0,
        'savings': 0,
      },
      courierData,
      user;
  String contact;
  LocalStorage storage = LocalStorage('silkroute');
  num logisticsSaving = 0, finalLogistic = 0;

  Map<String, String> _deliveryServiceabilityStatus = {
    "title": "Enter a valid pincode to check status",
    "etd": "",
    "rate": ""
  };

  void checkDeliveryServiceabilityStatus() async {
    if (products == null || products.length == 0) {
      return;
    }
    setState(() {
      _loadingDeliveryServiceabilityStatus = true;
    });

    print("pincode: $pincode");
    // todo: first argument has to be merchant pickup pincode and third is weight, 4th of cod and it has to be 0
    final res =
        await ShiprocketApi().getDeliveryServiceStatus(210201, pincode, 3, 0);
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

          bill['totalCost'] -= bill['logistic'];
          bill['logistic'] = int.parse(_deliveryServiceabilityStatus['rate']);
          priceData['finalLogistic'] =
              bill['logistic'] - priceData['logisticsSaving'];
          bill['totalCost'] += bill['logistic'];
          priceData['totalCost'] = bill['totalCost'];

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

  void loadProducts() async {
    products = widget.products;
    bill = widget.bill;
    user = await storage.getItem('user');
    contact = user['contact'];
    pincode = widget.pincode;
    print("1");
    await checkDeliveryServiceabilityStatus();

    await setState(() {
      orderAmount = bill["totalValue"] - bill["implicitDiscount"];
      print("products: $products");
      if (products != null && products.length > 0) {
        bill['totalCost'] -= bill['logistic'];
        bill['logistic'] = int.parse(_deliveryServiceabilityStatus['rate']);
        priceData['finalLogistic'] =
            bill['logistic'] - priceData['logisticsSaving'];
        bill['totalCost'] += bill['logistic'];
      }

      price = [
        {
          "title": "Total Value",
          "value": bill['totalValue'],
          "isDiscount": false
        },
        {
          "title": "Discount",
          "value": bill['implicitDiscount'],
          "isDiscount": true
        },
        {
          "title": "Coupon Discount",
          "value": bill['couponDiscount'],
          "isDiscount": true
        },
        {
          "title": "Price After Discount",
          "value": bill['priceAfterDiscount'],
          "isDiscount": false
        },
        {"title": "GST", "value": bill['gst'], "isDiscount": false},
        {
          "title": "Logistics Cost",
          "value": bill['logistic'],
          "isDiscount": false
        },
      ];

      priceData['savings'] = bill['implicitDiscount'] + bill['couponDiscount'];
      priceData['totalCost'] = bill['totalCost'];

      loading = false;
    });
  }

  Future recalculateBill() async {
    if (_coupons == null) {
      return;
    }
    if (_coupons.length == 0) {
      return;
    }

    setState(() {
      loadingBill = true;
      logisticsSaving = 0;
      bill["couponsApplied"] = [];
      bill["couponDiscount"] = 0;
      for (dynamic coupon in _coupons) {
        bill["couponsApplied"].add(coupon["code"]);
        bill["couponDiscount"] += coupon["amount"];

        if (coupon["type"].contains("Logistics")) {
          logisticsSaving += coupon["amount"];
        }
      }
      bill["priceAfterDiscount"] -= bill["couponDiscount"];
      bill["totalCost"] -= bill["couponDiscount"];
      priceData['finalLogistic'] = bill['logistic'] - logisticsSaving;
      priceData['totalCost'] = bill['totalCost'];
      priceData['logisticsSaving'] = logisticsSaving;
      price = [
        {
          "title": "Total Value",
          "value": bill['totalValue'],
          "isDiscount": false
        },
        {
          "title": "Discount",
          "value": bill['implicitDiscount'],
          "isDiscount": true
        },
        {
          "title": "Coupon Discount",
          "value": bill['couponDiscount'],
          "isDiscount": true
        },
        {
          "title": "Price After Discount",
          "value": bill['priceAfterDiscount'],
          "isDiscount": false
        },
        {"title": "GST", "value": bill['gst'], "isDiscount": false},
        {
          "title": "Logistics Cost",
          "value": bill['logistic'],
          "isDiscount": false
        },
      ];
      priceData['savings'] = bill['implicitDiscount'] + bill['couponDiscount'];
      loadingBill = false;
    });
  }

  Future applyCoupons() async {
    var coupons = await CouponApi().getCoupons(contact, orderAmount);

    setState(() {
      _coupons = coupons;
    });
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CouponsDialog(coupons: _coupons);
      },
    );
    setState(() {
      loadingBill = true;
    });
    await recalculateBill();
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: (products == null || products.length == 0)
          ? Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  "No items to show",
                  style: textStyle1(
                    18,
                    Colors.black45,
                    FontWeight.w700,
                  ),
                ),
              ),
            )
          : Column(
              children: <Widget>[
                loading
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
                    : CrateProductList(products: products),

                SizedBox(height: 20),

                /// Price DETAILS

                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: loading
                          ? Container(
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.3),
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
                          : (products == null || products.length == 0)
                              ? Container()
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: new TextFormField(
                                      initialValue: pincode,
                                      onChanged: (val) async {
                                        setState(() {
                                          if (val.length == 6) {
                                            pincode = val;
                                            widget.setPincode(pincode);
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
                                        await checkDeliveryServiceabilityStatus();
                                      },
                                      decoration: new InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        contentPadding:
                                            new EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                          vertical: 10,
                                        ),
                                        labelText: "Pincode*",
                                        labelStyle: new TextStyle(
                                          color: Colors.black54,
                                        ),
                                        prefixStyle: new TextStyle(
                                          color: Colors.black,
                                        ),
                                        hintText: "Pincode",
                                        hintStyle: textStyle1(13,
                                            Colors.black45, FontWeight.w500),
                                      ),
                                      style: textStyle1(
                                          13, Colors.black, FontWeight.w500),
                                    ),
                                  ),
                                ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: loading
                          ? Container(
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.3),
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
                          : (products == null || products.length == 0)
                              ? Container()
                              : (pincode != null && pincode.length == 6)
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
                                            (_deliveryServiceabilityStatus[
                                                            "etd"]
                                                        .length ==
                                                    0)
                                                ? Text(
                                                    _deliveryServiceabilityStatus[
                                                        "title"],
                                                    style: textStyle1(
                                                      13,
                                                      Colors.black54,
                                                      FontWeight.normal,
                                                    ),
                                                  )
                                                : SizedBox(height: 0),
                                            Text(
                                              "Estimated Time: " +
                                                  _deliveryServiceabilityStatus[
                                                      "etd"],
                                              style: textStyle1(
                                                12,
                                                Colors.black54,
                                                FontWeight.normal,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ))
                                  : SizedBox(height: 5),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Container(
                  margin: EdgeInsets.all(10),
                  color: Colors.grey[200],
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(
                          "Price Details:",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      (loading && loadingBill)
                          ? Text("Loading bill")
                          : DetailPriceList(
                              bill: price,
                              priceData: priceData,
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 2),

                ////  ApplyCoupon

                ElevatedButton(
                  onPressed: applyCoupons,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[200],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Apply Coupons",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                ////// PROCEED

                GestureDetector(
                  onTap: () async {
                    dynamic res = await CrateApi().getCrateItems();
                    dynamic cbill = res.item2.toMap();
                    print("${cbill['totalValue']} ${bill['totalValue']}");
                    if (cbill['totalValue'] != bill['totalValue']) {
                      await Helpers().showPriceChangeAlert(context);
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/crate');
                      return;
                    }
                    if (products.length > 0) {
                      setState(() {
                        widget.pageController.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOut);
                        CratePage().addressStatus = !CratePage().addressStatus;
                      });
                    } else {
                      Toast().notifyInfo("Add some items to crate to proceed");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                          color: (products.length > 0)
                              ? Color(0xFF811111)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400],
                              offset: Offset(3, 4),
                              // spreadRadius: 5,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: Text(
                          "Next",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: (products.length > 0)
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
                SizedBox(height: 40),
              ],
            ),
    );
  }
}

class DetailPriceList extends StatefulWidget {
  const DetailPriceList({this.bill, this.priceData});
  final dynamic bill, priceData;

  @override
  _DetailPriceListState createState() => _DetailPriceListState();
}

class _DetailPriceListState extends State<DetailPriceList> {
  bool loading = true;

  void loadPrice() {
    setState(() {
      loading = false;
    });
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadPrice();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text("Loading")
        : Column(
            children: <Widget>[
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.bill.length,
                padding: EdgeInsets.all(10),
                itemBuilder: (BuildContext context, int index) {
                  return PriceRow(
                    title: widget.bill[index]['title'],
                    value: (((widget.bill[index]["isDiscount"] == true)
                                ? "-"
                                : "") +
                            "₹" +
                            (widget.bill[index]['value']).toString())
                        .toString(),
                    logisticsSaving: widget.priceData['logisticsSaving'],
                    finalLogistic: widget.priceData['finalLogistic'],
                  );
                },
              ),
              Dash(
                length: MediaQuery.of(context).size.width * 0.8,
                dashColor: Colors.grey[700],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: PriceRow(
                  title: "Total Cost",
                  value: loading
                      ? "Calculating..."
                      : widget.priceData['totalCost'].toString(),
                  logisticsSaving: widget.priceData['logisticsSaving'],
                  finalLogistic: widget.priceData['finalLogistic'],
                ),
              ),
              Dash(
                length: MediaQuery.of(context).size.width * 0.8,
                dashColor: Colors.grey[700],
              ),
              SizedBox(height: 10),
              Text(
                ("You saved ₹" +
                        widget.priceData['savings'].toString() +
                        " on this order")
                    .toString(),
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
  }
}

class PriceRow extends StatefulWidget {
  const PriceRow(
      {this.title, this.value, this.logisticsSaving, this.finalLogistic});
  final String title, value;
  final num logisticsSaving, finalLogistic;
  @override
  _PriceRowState createState() => _PriceRowState();
}

class _PriceRowState extends State<PriceRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            widget.title,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        (widget.title == "Logistics Cost")
            ? ((widget.logisticsSaving > 0)
                ? Row(
                    children: <Widget>[
                      Text(
                        "₹" + widget.value.toString(),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Color(0xFF5B0D1B),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 3,
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      Text(
                        "₹" + widget.finalLogistic.toString(),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Color(0xFF5B0D1B),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    "₹" + widget.finalLogistic.toString(),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Color(0xFF5B0D1B),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
            : Text(
                widget.value.toString(),
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Color(0xFF5B0D1B),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ],
    );
  }
}

class CrateProductList extends StatefulWidget {
  const CrateProductList({this.products});
  final dynamic products;
  @override
  _CrateProductListState createState() => _CrateProductListState();
}

class _CrateProductListState extends State<CrateProductList> {
  List products = [];
  bool loading = true;

  void loadProducts() async {
    var pro = widget.products;
    setState(() {
      products = pro;
      loading = false;
    });
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
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
        : (products.length > 0)
            ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return CrateProductTile(
                      product: products[index], index: index);
                },
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.center,
                child: Text(
                  "No Items to show",
                  style: textStyle(15, Colors.grey[400]),
                ),
              );
  }
}
