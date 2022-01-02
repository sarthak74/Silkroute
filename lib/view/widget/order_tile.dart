import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/view/pages/reseller/order_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      // height: 120,
      constraints: BoxConstraints(maxHeight: 100),
      color: Colors.grey[200],
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Image.asset(
              "assets/images/1.png",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Order ID: ${widget.order['id']}",
                  style: textStyle(12, Colors.black),
                ),
                Text(
                  "Date: ${widget.order['createdDate'].toString().substring(0, 10)}",
                  style: textStyle(12, Colors.grey[500]),
                ),
                Text(
                  "Status: ${widget.order['status']}",
                  style: textStyle(12, Colors.grey[500]),
                ),
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
    );
  }
}
