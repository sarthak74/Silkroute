import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/flutter_dash.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';
import 'package:silkroute/view/widget2/footer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class MerchantOrderDetail extends StatefulWidget {
  const MerchantOrderDetail({Key key, this.order}) : super(key: key);
  final dynamic order;

  @override
  _MerchantOrderDetailState createState() => _MerchantOrderDetailState();
}

class _MerchantOrderDetailState extends State<MerchantOrderDetail> {
  dynamic orderDetails, bill;
  bool loading = true;

  dynamic price;
  int savings = 0, totalCost = 0;

  void loadPrice() {
    print("order: ${widget.order}");
    setState(() {
      bill = widget.order['bill'];
      price = [
        {"title": "Total Value", "value": bill['totalValue']},
        {"title": "Discount", "value": bill['implicitDiscount']},
        {"title": "Coupon Discount", "value": bill['couponDiscount']},
        {"title": "Price After Discount", "value": bill['priceAfterDiscount']},
        {"title": "GST", "value": bill['gst']},
        {"title": "Logistics Cost", "value": bill['logistic']},
      ];

      totalCost = int.parse(bill['totalCost'].toString());

      savings = int.parse(
          ((bill['totalValue'] - bill['priceAfterDiscount']).toString())
              .toString());
      loading = false;
    });
  }

  void loadOrder() {
    print("order: ${widget.order}");
    setState(() {
      orderDetails = widget.order;
    });
    loadPrice();
  }

  var pickups = {
    'id': 'dmy_XH51JG78B',
    'dispatchDate': '12-11-21',
    'weight': '5Kg',
    'labelUrl': 'asjcn',
    'length': '10',
    'breadth': '10',
    'height': '10',
    'invoice': 'jdowie'
  };

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
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.3),
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
                            : SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    // OrderPageTitle
                                    OrderPageTitle(orderDetails: orderDetails),
                                    // OrderStatus(orderDetails: {
                                    //   "status": widget.order["status"]
                                    // }),

                                    SizedBox(height: 10),

                                    OrderPickups(pickups: pickups),

                                    SizedBox(height: 10),

                                    OrderPriceDetails(
                                      invoiceNumber:
                                          orderDetails['invoiceNumber'],
                                      price: price,
                                      savings: savings,
                                      totalCost: totalCost,
                                    ),
                                    // CancelOrder(order: widget.order),
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

class OrderPickups extends StatefulWidget {
  const OrderPickups({Key key, this.pickups}) : super(key: key);
  final dynamic pickups;

  @override
  _OrderPickupsState createState() => _OrderPickupsState();
}

class _OrderPickupsState extends State<OrderPickups> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "PICKUPS:",
            style: textStyle1(
              13,
              Color(0xFF811111),
              FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          (widget.pickups == null)
              ? Center(
                  child: Text(
                    "No pickups scheduled",
                    style: textStyle1(
                      15,
                      Colors.grey,
                      FontWeight.w500,
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Shipment ID: ",
                                style: textStyle1(
                                    11, Colors.black, FontWeight.w500),
                              ),
                              Text(
                                widget.pickups['id'],
                                style: textStyle1(
                                    10, Colors.black, FontWeight.normal),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Dispatched: ",
                                style: textStyle1(
                                    9, Colors.black87, FontWeight.w500),
                              ),
                              Text(
                                widget.pickups['dispatchDate'],
                                style: textStyle1(
                                    9, Colors.black87, FontWeight.normal),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Weight: ",
                                style: textStyle1(
                                    11, Colors.black87, FontWeight.w500),
                              ),
                              Text(
                                widget.pickups['weight'],
                                style: textStyle1(
                                    11, Colors.black87, FontWeight.normal),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Label ",
                                  style: textStyle1(
                                      11, Color(0xFF811111), FontWeight.w500),
                                ),
                                Icon(Icons.download,
                                    color: Color(0xFF811111), size: 15),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Size: ",
                                style: textStyle1(
                                    11, Colors.black87, FontWeight.w500),
                              ),
                              Text(
                                "${widget.pickups['length']} x ${widget.pickups['breadth']} x ${widget.pickups['height']}",
                                style: textStyle1(
                                    11, Colors.black87, FontWeight.normal),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Invoice ",
                                  style: textStyle1(
                                      11, Color(0xFF811111), FontWeight.w500),
                                ),
                                Icon(Icons.download,
                                    color: Color(0xFF811111), size: 15),
                              ],
                            ),
                          ),
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

class OrderPriceDetails extends StatefulWidget {
  OrderPriceDetails(
      {this.price, this.savings, this.totalCost, this.invoiceNumber});
  final dynamic price;
  final num savings, totalCost;
  final String invoiceNumber;
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Id: ${widget.invoiceNumber}",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "View Invoice",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.transparent,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                        decorationColor: Colors.grey[700],
                        shadows: [
                          Shadow(color: Colors.grey[700], offset: Offset(0, -2))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          OrderPriceDetailsList(
              price: widget.price,
              savings: widget.savings,
              totalCost: widget.totalCost),
        ],
      ),
    );
  }
}

class OrderPriceDetailsList extends StatefulWidget {
  OrderPriceDetailsList({this.price, this.savings, this.totalCost});
  final dynamic price;
  final num savings;
  final num totalCost;
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
            value: "₹" + widget.totalCost.toString(),
          ),
        ),
        Dash(
          length: MediaQuery.of(context).size.width * 0.8,
          dashColor: Colors.grey[700],
        ),
        SizedBox(height: 10),
        (savings > 0)
            ? Text(
                ("You saved ₹" + savings.toString() + " on this order")
                    .toString(),
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Text(""),
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

class OrderPageTitle extends StatefulWidget {
  OrderPageTitle({this.orderDetails});
  final dynamic orderDetails;
  @override
  _OrderPageTitleState createState() => _OrderPageTitleState();
}

class _OrderPageTitleState extends State<OrderPageTitle> {
  dynamic orderDetails, moreColor = true, loading = true, showReturn = false;

  void loadVars() {
    setState(() {
      orderDetails = widget.orderDetails;
      loading = false;
    });
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVars();
    });
    super.initState();
  }

  TextStyle infoStyle = textStyle1(
    10,
    Colors.black87,
    FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            height: MediaQuery.of(context).size.height * 0.2,
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
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: orderDetails['items'].length,
            itemBuilder: (BuildContext context, int item_i) {
              // if(orderDetails['items'][i]['returnPeriod'])
              // implement add period to delivery return

              return ListTile(
                title: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: BoxConstraints(maxHeight: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          "assets/images/unnamed.png",
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                orderDetails["items"][item_i]['title'],
                                style: textStyle1(
                                  12,
                                  Colors.black,
                                  FontWeight.w700,
                                ),
                              ),
                              Container(
                                height: 22,
                                child: ListView.builder(
                                  itemCount: orderDetails["items"][item_i]
                                          ['colors']
                                      .length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int color_i) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 5),
                                      height: 20,
                                      width: 20,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          "assets/images/unnamed.png",
                                          fit: BoxFit.contain,
                                          width: 20,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text("Prod Id: ", style: infoStyle),
                                  Text(
                                    orderDetails["items"][item_i]["productId"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: infoStyle,
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text("Payment: ", style: infoStyle),
                                  Text(
                                    orderDetails["items"][item_i]
                                        ["merchantPaymentStatus"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: infoStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Quantity: ${orderDetails['items'][item_i]['quantity']}",
                              style: infoStyle,
                            ),
                            Text(
                              orderDetails["items"][item_i]["merchantStatus"],
                              style: infoStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
              /*
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03,
                      right: MediaQuery.of(context).size.width * 0.03,
                      top: 5,
                    ),
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 1),
                    constraints: BoxConstraints(maxHeight: 100),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.25,
                        Image.asset(
                          "assets/images/1.png",
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        // SizedBox(width: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                orderDetails['items'][i]['title'],
                                style: textStyle1(
                                  13,
                                  Colors.black,
                                  FontWeight.w500,
                                ),
                              ),
                              Text(
                                "MRP: ${orderDetails['items'][i]['mrp']}",
                                style: textStyle1(
                                  13,
                                  Colors.black,
                                  FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 20,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: orderDetails['items'][i]
                                              ['colors']
                                          .length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          width: 20,
                                          height: 20,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              image: DecorationImage(
                                                // image: NetworkImage(Math().ip() +
                                                //     "/images/616ff5ab029b95081c237c89-color-0"),
                                                image: NetworkImage(
                                                    "https://raw.githubusercontent.com/sarthak74/Yibrance-imgaes/master/category-Suit.png"),
                                                fit: BoxFit.fill,
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
              */
            },
          );
  }
}
