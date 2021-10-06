import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/pages/reseller/crate.dart';
import 'package:silkroute/widget/crate_product_tile.dart';
import 'package:silkroute/widget/flutter_dash.dart';

class CratePage1 extends StatefulWidget {
  CratePage1({this.pageController});
  final PageController pageController;
  @override
  _CratePage1State createState() => _CratePage1State();
}

class _CratePage1State extends State<CratePage1> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CrateProductList(),

          SizedBox(height: 20),

          ////  ApplyCoupon

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Color(0xFF5B0D1B),
                      width: 2,
                    )),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Apply Coupons",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 15,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
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
                DetailPriceList(),
              ],
            ),
          ),
          SizedBox(height: 30),

          ////// PROCEED

          GestureDetector(
            onTap: () {
              setState(() {
                widget.pageController.animateToPage(1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut);
                CratePage().addressStatus = !CratePage().addressStatus;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF5B0D1B),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Text(
                    "Proceed",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
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
  @override
  _DetailPriceListState createState() => _DetailPriceListState();
}

class _DetailPriceListState extends State<DetailPriceList> {
  List products = [];
  bool loading = true;
  dynamic price;
  int savings = 0;

  void loadPrice() {
    setState(() {
      price = [
        {"title": "Total Value", "value": 40000},
        {"title": "Discount", "value": 28002},
        {"title": "Coupon Discount", "value": 1000},
        {"title": "Price After Discount", "value": 10998},
        {"title": "GST", "value": 549.9},
        {"title": "Logistics Cost", "value": 1043},
      ];

      for (int i = 0; i < price.length; i++) {
        var x = price[i]['title'].split(' ');
        if (x[0] == 'Discount' || x[0] == 'Coupon') {
          savings += price[i]['value'];
        }
      }

      loading = false;
    });
  }

  void initState() {
    super.initState();
    loadPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 6,
          padding: EdgeInsets.all(10),
          itemBuilder: (BuildContext context, int index) {
            return PriceRow(
              title: price[index]['title'],
              value: ("₹" + (price[index]['value']).toString()).toString(),
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
            value: "₹12590",
          ),
        ),
        Dash(
          length: MediaQuery.of(context).size.width * 0.8,
          dashColor: Colors.grey[700],
        ),
        SizedBox(height: 10),
        Text(
          ("You saved ₹" + savings.toString() + " on this order").toString(),
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
  const PriceRow({this.title, this.value});
  final String title, value;
  @override
  _PriceRowState createState() => _PriceRowState();
}

class _PriceRowState extends State<PriceRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          widget.title,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
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
  @override
  _CrateProductListState createState() => _CrateProductListState();
}

class _CrateProductListState extends State<CrateProductList> {
  List products = [];
  bool loading = true;
  dynamic product = {
    "id": 1,
    "title": "Kanjeevaram Silk Saree",
    "discount": true,
    "mrp": 20000.0,
    "discountValue": 70.0,
    "quantity": 5,
    "stock": 7,
  };

  void loadProducts() {
    for (int i = 0; i < 3; i++) {
      dynamic data = product;
      products.add(data);
    }
    setState(() {
      loading = false;
    });
  }

  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text("Loading Loading")
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return CrateProductTile(product: products[index]);
            });
  }
}
