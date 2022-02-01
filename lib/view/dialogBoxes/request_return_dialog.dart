import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/constants/values.dart';
import 'package:silkroute/main.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/flutter_dash.dart';
import 'package:silkroute/view/widget/text_field.dart';

class RequestReturnDialog extends StatefulWidget {
  const RequestReturnDialog(this.orderDetails, this.selected,
      this.enterQuantity, // enterQuantity; // a flag to know whether we have to take input of quantity or just show it
      {Key key})
      : super(key: key);
  final bool
      enterQuantity; // a flag to know whether we have to take input of quantity or just show it
  final dynamic orderDetails, selected;

  @override
  _RequestReturnDialogState createState() => _RequestReturnDialogState();
}

class _RequestReturnDialogState extends State<RequestReturnDialog> {
  bool loading = true, requesting = false;
  dynamic items = [], bill = {}, price = [], quantity = [];

  void loadVars() {
    setState(() {
      bill['totalValue'] = 0;
      for (int i = 0; i < widget.selected.length; i++) {
        if (widget.selected[i]) {
          items.add(widget.orderDetails['items'][i]);
          quantity.add(int.parse(
              widget.orderDetails['items'][i]['quantity'].toString()));
          bill['totalValue'] +=
              (widget.orderDetails['items'][i]['mrp']).floor();
        }
      }
      bill['gst'] = (widget.orderDetails['bill']['gst'] ?? 0).floor();
      bill['couponDiscount'] =
          (widget.orderDetails['bill']['couponDiscount'] ?? 0).floor();
      bill['logistic'] = (widget.orderDetails['bill']['logistic'] ?? 0).floor();
      bill['totalCost'] =
          bill['totalValue'] + bill['gst'] - bill['couponDiscount'];
      List title = ["Total Value", "GST", "Coupon Discount", "Logistic"];
      List keys = ["totalValue", "gst", "couponDiscount", "logistic"];
      for (int i = 0; i < title.length; i++) {
        price.add({"title": title[i], "value": bill[keys[i]]});
      }
      loading = false;
    });
  }

  dynamic dimensions = {"l": 0.0, "b": 0.0, "h": 0.0};

  Future requestReturnHandler() async {
    setState(() {
      requesting = true;
    });
    dynamic data = {
      "orderId": widget.orderDetails['invoiceNumber'],
      "itemIds": [],
      "l": dimensions["l"],
      "b": dimensions["b"],
      "h": dimensions["h"],
    };
    for (String x in ["l", "b", "h"]) {
      if (dimensions[x] < 0.5) {
        Toast().notifyErr("Dimensions can not be less that 0.5cm");
        return;
      }
    }
    print("ret data: $data");

    for (int i = 0; i < items.length; i++) {
      print(items[i]["quantity"]);
      if (quantity[i] <= 0 || items[i]['quantity'] < quantity[i]) {
        Toast().notifyErr("1 or more quantity is invalid");
      }
      data["itemIds"].add({"id": items[i]["id"], "quantity": quantity[i]});
    }
    // print(data);
    // return;
    dynamic return_res = await OrderApi().resellerRequestReturn(data);
    setState(() {
      requesting = false;
    });
    Navigator.of(context).popUntil(ModalRoute.withName("/orders"));
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),

      // contentPadding: EdgeInsets.all(20),

      child: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Request Return",
                      style: textStyle1(
                        13,
                        Colors.black,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.black87,
                          size: 30,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              loading
                  ? Center(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: CircularProgressIndicator(
                        color: Color(0xFF811111),
                        strokeWidth: 3,
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        OrderItems(items, quantity, widget.enterQuantity),
                        SizedBox(height: 20),
                        if (widget.enterQuantity)
                          GetDimensions(dimensions: dimensions),
                        if (widget.enterQuantity) SizedBox(height: 20),
                        OrderPriceDetailsList(price, bill['totalCost']),
                        SizedBox(height: 10),
                        widget.enterQuantity
                            ? GestureDetector(
                                onTap: () async {
                                  await requestReturnHandler();
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF811111),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "Submit Request",
                                    style: textStyle1(
                                      11,
                                      Colors.white,
                                      FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(height: 5),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class GetDimensions extends StatefulWidget {
  const GetDimensions({Key key, this.dimensions}) : super(key: key);
  final dynamic dimensions;

  @override
  _GetDimensionsState createState() => _GetDimensionsState();
}

class _GetDimensionsState extends State<GetDimensions> {
  // Map<String, TextEditingController> controllers = {
  //   "l": new TextEditingController(),
  //   "b": new TextEditingController(),
  //   "h": new TextEditingController()
  // };
  List<String> dim = ["l", "b", "h"];
  List<String> name = ["Length", "Breadth", "Height"];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Package Dimensions (cm)",
            style: textStyle1(
              13,
              Colors.black,
              FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: name
                .map((dimension) => Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      // padding: EdgeInsets.only(
                      //     right: dimension != name[2]
                      //         ? MediaQuery.of(context).size.width * 0.08
                      //         : 0),
                      // width: MediaQuery.of(context).size.width * 0.15,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(
                              color: Color(0xFF811111),
                              width: 2,
                            ),
                            // borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          contentPadding: new EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 0,
                          ),
                          labelText: dimension,
                          labelStyle:
                              textStyle1(10, Colors.black45, FontWeight.bold),
                          prefixStyle: new TextStyle(
                            color: Colors.black,
                          ),
                          hintStyle:
                              textStyle1(10, Colors.black45, FontWeight.w500),
                          hintText: "Enter ${dimension}",
                        ),
                        style: textStyle1(12, Colors.black, FontWeight.w500),
                        onChanged: (val) {
                          print("${dimension}: $val");
                          widget.dimensions[dim[name.indexOf(dimension)]] =
                              double.parse(val.toString());
                        },
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class OrderPriceDetailsList extends StatefulWidget {
  OrderPriceDetailsList(this.price, this.totalCost);
  final dynamic price, totalCost;

  @override
  _OrderPriceDetailsListState createState() => _OrderPriceDetailsListState();
}

class _OrderPriceDetailsListState extends State<OrderPriceDetailsList> {
  dynamic price;
  int totalCost = 0;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    price = widget.price;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: price.length,
            padding: EdgeInsets.all(10),
            itemBuilder: (BuildContext context, int index) {
              return PriceRow(
                title: price[index]['title'],
                value: ("₹" + (price[index]['value']).toString()).toString(),
              );
            },
          ),
          Dash(
            length: MediaQuery.of(context).size.width * 0.58,
            dashColor: Colors.grey[700],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: PriceRow(
              title: "Refund Amount",
              value: "₹" + widget.totalCost.toString(),
              boldFlag: true,
            ),
          ),
          Dash(
            length: MediaQuery.of(context).size.width * 0.58,
            dashColor: Colors.grey[700],
          ),
        ],
      ),
    );
  }
}

class PriceRow extends StatefulWidget {
  const PriceRow({this.title, this.value, this.boldFlag});
  final String title, value;
  final bool boldFlag;
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
          widget.title.toString(),
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight:
                  (widget.boldFlag == true) ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
        Text(
          widget.value,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Color(0xFF811111),
              fontSize: 12,
              fontWeight:
                  (widget.boldFlag == true) ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class OrderItems extends StatefulWidget {
  const OrderItems(this.items, this.quantity, this.enterQuantity, {Key key})
      : super(key: key);
  final dynamic items, quantity, enterQuantity;
  // entrqty = flag;

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  List cost = [], upperQty = [];
  bool loading = true;
  List<TextEditingController> controllers = [];

  loadVars() {
    setState(() {
      loading = true;
    });
    upperQty = widget.quantity;
    for (var x in widget.items) {
      cost.add(x['mrp']);
    }
    for (var x in widget.quantity) {
      TextEditingController c = TextEditingController();
      c.text = x.toString();
      controllers.add(c);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            width: 20,
            height: 20,
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: CircularProgressIndicator(
                color: Color(0xFF811111),
                strokeWidth: 3,
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 10),
            itemCount: widget.items.length,
            itemBuilder: (context, item_i) {
              int mrp = int.parse(cost[item_i].toString());
              int qty = int.parse(widget.quantity[item_i].toString());
              int tc = mrp * qty;
              return Container(
                padding: EdgeInsets.all(10),
                // margin: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: BoxConstraints(maxHeight: 85),
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
                              widget.items[item_i]['title'],
                              style: textStyle1(
                                12,
                                Colors.black,
                                FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 2),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 22,
                              child: ListView.builder(
                                itemCount:
                                    widget.items[item_i]['colors'].length,
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
                            SizedBox(height: 2),
                            Text(
                              "${ConstantValues().rupee()}${tc.toString()}",
                              style: textStyle1(
                                  11, Color(0xFF811111), FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          !widget.enterQuantity
                              ? Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "Quantity: ${widget.items[item_i]["quantity"]}",
                                      style: textStyle1(10, Color(0xFF646464),
                                          FontWeight.w500),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: controllers[item_i],
                                      decoration: InputDecoration(
                                        isDense: true,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Color(0xFF811111),
                                            width: 2,
                                          ),
                                          // borderRadius: BorderRadius.all(Radius.circular(30)),
                                        ),
                                        contentPadding:
                                            new EdgeInsets.symmetric(
                                          horizontal: 0.0,
                                          vertical: 0,
                                        ),
                                        labelText: "Quantity",
                                        labelStyle: textStyle1(10,
                                            Colors.black45, FontWeight.bold),
                                        prefixStyle: new TextStyle(
                                          color: Colors.black,
                                        ),
                                        hintStyle: textStyle1(10,
                                            Colors.black45, FontWeight.w500),
                                        hintText: "Enter quantity",
                                      ),
                                      style: textStyle1(
                                          12, Colors.black, FontWeight.w500),
                                      onChanged: (val) {
                                        if (val.length == 0) {
                                          val = "0";
                                        }
                                        widget.quantity[item_i] =
                                            int.parse(val.toString());
                                        if (widget.quantity[item_i] >
                                            upperQty[item_i]) {
                                          widget.quantity[item_i] = Toast()
                                              .notifyErr(
                                                  "Entered Quantity is greater that bought quantity");
                                        }
                                        setState(() {
                                          cost[item_i] =
                                              widget.quantity[item_i] *
                                                  widget.items[item_i]["mrp"];
                                        });
                                      },
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
