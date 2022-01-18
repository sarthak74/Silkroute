import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/flutter_dash.dart';

class RequestReturnDialog extends StatefulWidget {
  const RequestReturnDialog(this.orderDetails, this.selected, {Key key})
      : super(key: key);
  final dynamic orderDetails, selected;

  @override
  _RequestReturnDialogState createState() => _RequestReturnDialogState();
}

class _RequestReturnDialogState extends State<RequestReturnDialog> {
  bool loading = true;
  dynamic items = [], bill = {}, price = [];

  void loadVars() {
    setState(() {
      bill['totalValue'] = 0;
      for (int i = 0; i < widget.selected.length; i++) {
        if (widget.selected[i]) {
          items.add(widget.orderDetails['items'][i]);
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
        padding: EdgeInsets.all(20),
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Request Return",
                    style: textStyle1(
                      14,
                      Colors.black,
                      FontWeight.w500,
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
                        OrderItems(items),
                        SizedBox(height: 20),
                        OrderPriceDetailsList(price, bill['totalCost']),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
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
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
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

class OrderItems extends StatefulWidget {
  const OrderItems(this.items, {Key key}) : super(key: key);
  final dynamic items;

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, item_i) {
        return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 8),
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
                flex: 5,
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
                          FontWeight.w700,
                        ),
                      ),
                      Container(
                        height: 22,
                        child: ListView.builder(
                          itemCount: widget.items[item_i]['colors'].length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int color_i) {
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
                      Text(
                        "${widget.items[item_i]["mrp"]}",
                        style:
                            textStyle1(11, Color(0xFF811111), FontWeight.w700),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Quantity: ${widget.items[item_i]["quantity"]}",
                          style: textStyle1(
                              11, Color(0xFF811111), FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
