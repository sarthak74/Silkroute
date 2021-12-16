import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/CrateApi.dart';
import 'package:silkroute/model/services/couponApi.dart';
import 'package:silkroute/provider/CrateProvider.dart';
import 'package:silkroute/view/dialogBoxes/CouponDialogBox.dart';
import 'package:silkroute/view/pages/reseller/crate.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/crate_product_tile.dart';
import 'package:silkroute/view/widget/flutter_dash.dart';
import 'package:silkroute/view/widget/show_dialog.dart';

class CratePage1 extends StatefulWidget {
  CratePage1({this.pageController, this.products, this.bill});
  final PageController pageController;
  final dynamic products, bill;
  @override
  _CratePage1State createState() => _CratePage1State();
}

class _CratePage1State extends State<CratePage1> {
  List products = [];
  bool loading = true, loadingBill = true;
  dynamic bill,
      _coupons,
      orderAmount,
      price,
      priceData = {
        'logisticsSaving': 0,
        'finalLogistic': 0,
        'totalCost': 0,
        'savings': 0,
      };
  String contact;
  LocalStorage storage = LocalStorage('silkroute');
  num logisticsSaving = 0, finalLogistic = 0;

  void loadProducts() async {
    contact = await storage.getItem('contact');

    setState(() {
      products = widget.products;
      bill = widget.bill;
      orderAmount = bill["totalValue"] - bill["implicitDiscount"];
      price = [
        {"title": "Total Value", "value": bill['totalValue']},
        {"title": "Discount", "value": bill['implicitDiscount']},
        {"title": "Coupon Discount", "value": bill['couponDiscount']},
        {"title": "Price After Discount", "value": bill['priceAfterDiscount']},
        {"title": "GST", "value": bill['gst']},
        {"title": "Logistics Cost", "value": bill['logistic']},
      ];
      priceData['totalCost'] = bill['totalCost'];
      priceData['savings'] = bill['totalValue'] - bill['totalCost'];
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
        {"title": "Total Value", "value": bill['totalValue']},
        {"title": "Discount", "value": bill['implicitDiscount']},
        {"title": "Coupon Discount", "value": bill['couponDiscount']},
        {"title": "Price After Discount", "value": bill['priceAfterDiscount']},
        {"title": "GST", "value": bill['gst']},
        {"title": "Logistics Cost", "value": bill['logistic']},
      ];
      priceData['savings'] = bill['totalValue'] - bill['totalCost'];
      loadingBill = false;
    });
  }

  Future applyCoupons() async {
    var coupons = await CouponApi().getCoupons(contact, orderAmount);
    print("coupons $coupons");
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
      child: Column(
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

          ////  ApplyCoupon

          ElevatedButton(
            onPressed: applyCoupons,
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[200],
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  width: 2,
                  color: Color(0xFF811111),
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 10, 15, 7),
            ),
            child: Wrap(
              children: <Widget>[
                Text(
                  "Apply Coupons",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                )
              ],
            ),
          ),

          SizedBox(height: 20),

          /// Price DETAILS

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
                SizedBox(height: 20),
                (loading && loadingBill)
                    ? Text("Loading bill")
                    : DetailPriceList(
                        bill: price,
                        priceData: priceData,
                      ),
              ],
            ),
          ),
          SizedBox(height: 30),

          ////// PROCEED

          GestureDetector(
            onTap: () {
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
                        ? Color(0xFF5B0D1B)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Text(
                    "Proceed",
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
                    value: ("₹" + (widget.bill[index]['value']).toString())
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
                        "₹" + widget.value,
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
                widget.value,
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
