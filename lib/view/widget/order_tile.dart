import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:silkroute/view/pages/reseller/order_page.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class OrderTile extends StatefulWidget {
  const OrderTile(this.order);
  final dynamic order;

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  @override
  void initState() {
    print("uuu ${widget.order}");
    super.initState();
  }

  Map<String, Color> statusColor = {
    "Order Placed": Color(0xFF811111),
    "Processing": Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    dynamic date = widget.order['createdDate'].toString().substring(0, 10);
    date = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Color(0xFF811111),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        // height: 120,

        decoration: BoxDecoration(
          color: Color(0xfff6f6f6),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Order ID: ",
                        style: textStyle1(12, Colors.black, FontWeight.bold),
                      ),
                      Text(
                        "${widget.order['id']}",
                        style: textStyle1(12, Colors.black, FontWeight.normal),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Date: ",
                        style: textStyle1(12, Colors.black54, FontWeight.bold),
                      ),
                      Text(
                        date.toString(),
                        style:
                            textStyle1(12, Colors.black54, FontWeight.normal),
                      ),
                    ],
                  ),
                  // Text(
                  //   "Status: ${widget.order['status']}",
                  //   style: textStyle(12, Colors.grey[500]),
                  // ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.black87,
                    // size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderPage(order: widget.order),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
