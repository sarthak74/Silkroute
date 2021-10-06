import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/widget/footer.dart';
import 'package:silkroute/widget/navbar.dart';
import 'package:silkroute/widget/topbar.dart';

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
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              // OrderPageTitle
                              OrderPageTitle(id: widget.id),
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

class OrderPageTitle extends StatefulWidget {
  OrderPageTitle({this.id});
  final String id;
  @override
  _OrderPageTitleState createState() => _OrderPageTitleState();
}

class _OrderPageTitleState extends State<OrderPageTitle> {
  dynamic orderDetails, loading = true, moreColor = true;

  void loadOrder() {
    setState(() {
      orderDetails = {
        "title": "Kanjeevaram Silk Saree",
        "quantity": 6,
        "color": [
          0xFFC80D0D,
          0xFFE3740C,
          0xFF1DDADA,
          0xFF5451C7,
          0xFF127D2A,
          0xFF9E9B9B,
          0xFFC1C5C5
        ],
        "status": "Out for Delivery"
      };

      loading = false;
    });
  }

  void initState() {
    super.initState();
    loadOrder();
  }

  @override
  Widget build(BuildContext context) {
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
