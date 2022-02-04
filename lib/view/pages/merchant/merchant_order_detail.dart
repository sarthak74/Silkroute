import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:silkroute/constants/values.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/core/package.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/model/services/packagesApi.dart';
import 'package:silkroute/provider/PackageProvider.dart';
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
        {"title": "GST", "value": bill['gst']},
      ];

      totalCost = int.parse(bill['totalValue'].toString()) +
          int.parse(bill['gst'].toString());

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

                                    // OrderPickups(pickups: pickups),

                                    OrderPriceDetails(
                                      invoiceNumber:
                                          orderDetails['invoiceNumber'],
                                      price: price,
                                      savings: savings,
                                      totalCost: totalCost,
                                    ),

                                    OrderPaymentStatus(
                                      paymentStatus: orderDetails['items'][0]
                                          ['merchantPaymentStatus'],
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

class OrderPaymentStatus extends StatefulWidget {
  const OrderPaymentStatus({Key key, this.paymentStatus}) : super(key: key);
  final dynamic paymentStatus;

  @override
  _OrderPaymentStatusState createState() => _OrderPaymentStatusState();
}

class _OrderPaymentStatusState extends State<OrderPaymentStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Payment:",
                style: textStyle1(
                  13,
                  Color(0xFF811111),
                  FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xfff6f6f6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: <Widget>[
                Text(
                  "Payment: ",
                  style: textStyle1(11, Colors.black, FontWeight.w500),
                ),
                Text(
                  "${widget.paymentStatus}",
                  style: textStyle1(11, Colors.black, FontWeight.normal),
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
  OrderPriceDetails({
    this.price,
    this.savings,
    this.totalCost,
    this.invoiceNumber,
  });
  final dynamic price;
  final num savings, totalCost;
  final String invoiceNumber;
  @override
  _OrderPriceDetailsState createState() => _OrderPriceDetailsState();
}

class _OrderPriceDetailsState extends State<OrderPriceDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "BILL:",
              style: textStyle1(
                13,
                Color(0xFF811111),
                FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03),
          decoration: BoxDecoration(
            color: Color(0xfff6f6f6),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 1),
              OrderPriceDetailsList(
                price: widget.price,
                savings: widget.savings,
                totalCost: widget.totalCost,
              ),
            ],
          ),
        ),
      ],
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
          itemCount: 2,
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
            title: "Amount",
            value: "₹" + widget.totalCost.toString(),
          ),
        ),
        Dash(
          length: MediaQuery.of(context).size.width * 0.8,
          dashColor: Colors.grey[700],
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
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          widget.value,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Color(0xFF811111),
              fontSize: 12,
              fontWeight: FontWeight.w500,
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
  List<bool> selected = [];
  int count = 0;

  void loadVars() {
    setState(() {
      loading = true;
      orderDetails = widget.orderDetails;
      for (var x in orderDetails['items']) {
        selected.add(false);
      }
      loading = false;
    });
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVars();
    });
    super.initState();
  }

  void addToPackageHandler() async {
    Package package = await Helpers().singleSelectPackageDialog(context);
    print("package-- $package");
    if (package == null) return;
    dynamic items = [];
    setState(() {
      loading = true;
    });
    for (int i = 0; i < selected.length; i++) {
      if (!selected[i]) continue;
      items.add({
        "orderId": orderDetails['invoiceNumber'],
        "productId": orderDetails['items'][i]['productId']
      });
      widget.orderDetails['items'][i]['package'] = package.name;
    }
    print("items: $items");
    await PackagesApi().addItem(package.id, items);

    count = 0;
    for (int i = 0; i < selected.length; i++) selected[i] = false;
    setState(() {
      loading = false;
    });
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
        : Column(
            children: <Widget>[
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "PRODUCTS:",
                        style: textStyle1(
                          13,
                          Color(0xFF811111),
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      "*Press & hold items to add to package",
                      style: textStyle1(
                        10,
                        Colors.black54,
                        FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 5),
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: orderDetails['items'].length,
                itemBuilder: (BuildContext context, int item_i) {
                  // if(orderDetails['items'][i]['returnPeriod'])
                  // implement add period to delivery return
                  var titleStatus;
                  titleStatus =
                      (orderDetails["items"][item_i]['package'] == "Not Added"
                          ? " --- "
                          : orderDetails["items"][item_i]['package']
                              .toString()
                              .toUpperCase());
                  if (orderDetails["items"][item_i]["merchantStatus"] !=
                      "Processing") {
                    titleStatus =
                        orderDetails["items"][item_i]["merchantStatus"];
                  }
                  return InkWell(
                    onLongPress: () {
                      if (orderDetails['items'][item_i]['package'] !=
                          "Not Added") {
                        return;
                      }
                      if (count > 0) {
                        return;
                      }
                      setState(() {
                        selected[item_i] =
                            (selected[item_i] == true) ? false : true;
                        if (selected[item_i])
                          count++;
                        else
                          count--;
                      });
                    },
                    onTap: () {
                      if (orderDetails['items'][item_i]['package'] !=
                          "Not Added") {
                        return;
                      }
                      if (count == 0) {
                        return;
                      }
                      setState(() {
                        selected[item_i] =
                            (selected[item_i] == true) ? false : true;
                        if (selected[item_i])
                          count++;
                        else
                          count--;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 8),
                      decoration: BoxDecoration(
                        color: (selected.length > item_i && selected[item_i])
                            ? Colors.grey[400]
                            : Color(0xFFF6F6F6),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    orderDetails["items"][item_i]['title'],
                                    style: textStyle1(
                                      12,
                                      Colors.black,
                                      FontWeight.w500,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Container(
                                      height: 22,
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: ListView.builder(
                                        itemCount: orderDetails["items"][item_i]
                                                ['colors']
                                            .length,
                                        // shrinkWrap: true,
                                        // physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (BuildContext context,
                                            int color_i) {
                                          return Container(
                                            margin: EdgeInsets.only(right: 5),
                                            height: 20,
                                            width: 20,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Prod ID: ",
                                        style: textStyle1(
                                          10,
                                          Colors.black,
                                          FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        orderDetails["items"][item_i]
                                            ["reference"],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: textStyle1(
                                          10,
                                          Color(0xFF646464),
                                          FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Status: ",
                                        style: textStyle1(
                                          10,
                                          Colors.black,
                                          FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        "$titleStatus",
                                        style: textStyle1(
                                          10,
                                          Color(0xFF646464),
                                          FontWeight.normal,
                                        ),
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
                                  style: textStyle1(
                                    10,
                                    Colors.black,
                                    FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "${ConstantValues().rupee()}${orderDetails["items"][item_i]["mrp"]}",
                                  style: textStyle1(
                                    10,
                                    Color(0xFF811111),
                                    FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              (count > 0)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: addToPackageHandler,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              color: Color(0xFF811111),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Add to Package",
                              style: textStyle1(
                                12,
                                Colors.white,
                                FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              count = 0;
                              for (int i = 0; i < selected.length; i++) {
                                selected[i] = false;
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 22,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(height: 0),
              SizedBox(height: 1),
            ],
          );
  }
}
