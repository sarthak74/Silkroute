import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';

import 'package:silkroute/methods/math.dart';
import 'package:silkroute/view/widget/flutter_dash.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

TextStyle textStyle(num size, Color color) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      color: color,
      fontSize: size.toDouble(),
      fontWeight: FontWeight.bold,
    ),
  );
}

class OrderPage extends StatefulWidget {
  const OrderPage({this.id});
  final String id;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  dynamic orderDetails;
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
    });
  }

  void loadOrder() {
    setState(() {
      orderDetails = {
        "title": "Kanjeevaram Silk Saree",
        "quantity": 5,
        "color": [
          0xFFC80D0D,
          0xFFE3740C,
          0xFF1DDADA,
          0xFF5451C7,
          0xFF127D2A,
          0xFF9E9B9B,
          0xFFC1C5C5
        ],
        "status": "Out for Delivery",
        "rating": 3
      };
    });
    loadPrice();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadOrder();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Navbar(),
        primary: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/1.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: <Widget>[
              //////////////////////////////
              ///                        ///
              ///         TopBar         ///
              ///                        ///
              //////////////////////////////

              TopBar(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    color: Colors.white,
                  ),
                  child: CustomScrollView(slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        loading
                            ? Text("Loading")
                            : SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    // OrderPageTitle
                                    OrderPageTitle(orderDetails: orderDetails),
                                    OrderStatus(orderDetails: orderDetails),
                                    StarRating(orderDetails: orderDetails),
                                    OrderPriceDetails(
                                        price: price, savings: savings),
                                  ],
                                ),
                              ),
                      ]),
                    ),
                    SliverFillRemaining(
                        hasScrollBody: false, child: Container()),
                  ]),
                ),
              ),

              //////////////////////////////
              ///                        ///
              ///         Footer         ///
              ///                        ///
              //////////////////////////////
              Footer(),
            ],
          ),
        ),
        // bottomNavigationBar: Footer(),
      ),
    );
  }
}

class OrderPriceDetails extends StatefulWidget {
  OrderPriceDetails({this.price, this.savings});
  final dynamic price;
  final int savings;
  @override
  _OrderPriceDetailsState createState() => _OrderPriceDetailsState();
}

class _OrderPriceDetailsState extends State<OrderPriceDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
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
          OrderPriceDetailsList(price: widget.price),
        ],
      ),
    );
  }
}

class OrderPriceDetailsList extends StatefulWidget {
  OrderPriceDetailsList({this.price, this.savings});
  final dynamic price;
  final int savings;
  @override
  _OrderPriceDetailsListState createState() => _OrderPriceDetailsListState();
}

class _OrderPriceDetailsListState extends State<OrderPriceDetailsList> {
  dynamic price;
  int savings = 0;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    price = widget.price;
    savings = widget.savings;
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

class StarRating extends StatefulWidget {
  StarRating({this.orderDetails});
  final dynamic orderDetails;

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  dynamic orderDetails;
  @override
  Widget build(BuildContext context) {
    orderDetails = widget.orderDetails;
    orderDetails['rating'] *= 1.0;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: 15,
      ),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SmoothStarRating(
            starCount: 5,
            rating: orderDetails['rating'],
            color: Colors.orange,
            borderColor: Colors.black,
          ),
        ],
      ),
    );
  }
}

class OrderStatus extends StatefulWidget {
  const OrderStatus({this.orderDetails});
  final dynamic orderDetails;

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  bool isProfileExpanded = false;

  @override
  Widget build(BuildContext context) {
    dynamic orderDetails = widget.orderDetails;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03),
      decoration: BoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              isProfileExpanded = !isExpanded;
            });
          },
          expandedHeaderPadding: EdgeInsets.all(0),
          animationDuration: Duration(milliseconds: 500),
          children: [
            ExpansionPanel(
              backgroundColor: Colors.grey[200],
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.radio_button_checked,
                          size: 20, color: Colors.black54),
                      SizedBox(width: 10),
                      Text(
                        orderDetails['status'],
                        style: textStyle(15, Colors.grey[700]),
                      ),
                    ],
                  ),
                );
              },
              body: ListTile(
                title: Row(
                  children: <Widget>[
                    Container(
                      width: 70,
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                      height: 240,
                      child: IconStepper(
                        enableNextPreviousButtons: false,
                        enableStepTapping: false,
                        stepColor: Colors.grey[400],
                        direction: Axis.vertical,
                        activeStepBorderColor: Colors.green,
                        activeStepBorderWidth: 1,
                        activeStepBorderPadding: 2.0,
                        lineLength: 35,
                        activeStep: 2,
                        lineDotRadius: 2,
                        activeStepColor: Colors.green,
                        stepPadding: 0.0,
                        lineColor: Colors.grey[400],
                        stepRadius: 13,
                        icons: [
                          Icon(Icons.check),
                          Icon(Icons.check),
                          Icon(Icons.radio_button_checked, color: Colors.white),
                          Icon(Icons.radio_button_checked),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                      height: 240,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text("Order Places",
                              style: textStyle(12, Colors.black54)),
                          SizedBox(height: 45),
                          Text("Dispatched from Source",
                              style: textStyle(12, Colors.black54)),
                          SizedBox(height: 45),
                          Text("Out for Delivery",
                              style: textStyle(12, Colors.black54)),
                          SizedBox(height: 45),
                          Text("Delivered",
                              style: textStyle(12, Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isExpanded: isProfileExpanded,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderPageTitle extends StatefulWidget {
  OrderPageTitle({this.orderDetails});
  final dynamic orderDetails;
  @override
  _OrderPageTitleState createState() => _OrderPageTitleState();
}

class _OrderPageTitleState extends State<OrderPageTitle> {
  dynamic orderDetails, moreColor = true;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    orderDetails = widget.orderDetails;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: 15,
      ),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/1.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  orderDetails['title'],
                  style: textStyle(12, Colors.black),
                ),
                Text(
                  ("Quantity: " + orderDetails['quantity'].toString())
                      .toString(),
                  style: textStyle(12, Colors.black),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 130,
                      height: 20,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Math().min(orderDetails['color'].length, 5),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 20,
                            height: 20,
                            margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color(orderDetails['color'][index]),
                            ),
                          );
                        },
                      ),
                    ),
                    // moreColor
                    //     ?
                    Container(
                      width: 25,
                      height: 25,
                      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12.5)),
                        border: Border.all(width: 2, color: Colors.grey[500]),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "+" + (orderDetails['color'].length - 5).toString(),
                        style: textStyle(10, Colors.grey[500]),
                      ),
                    )
                    // : SizedBox(width: 1),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}