import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class PickupDetailsDialog extends StatefulWidget {
  const PickupDetailsDialog({Key key, this.orders, this.docs, this.wt})
      : super(key: key);
  final dynamic orders, docs, wt;

  @override
  _PickupDetailsDialogState createState() => _PickupDetailsDialogState();
}

class _PickupDetailsDialogState extends State<PickupDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    var docs = widget.docs;
    print("docs $docs");
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
                      "Pickup Details",
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
                          size: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Weight: ",
                      style: textStyle1(
                        10,
                        Colors.black54,
                        FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${widget.wt.toString()} kg",
                      style: textStyle1(
                        10,
                        Colors.black54,
                        FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Label: ",
                          style: textStyle1(
                            11,
                            Colors.black,
                            FontWeight.w500,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.download,
                            color: Color(0xff811111),
                            size: 17,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "Manifest: ",
                          style: textStyle1(
                            11,
                            Colors.black,
                            FontWeight.w500,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.download,
                            color: Color(0xff811111),
                            size: 17,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "Invoice: ",
                          style: textStyle1(
                            11,
                            Colors.black,
                            FontWeight.w500,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.download,
                            color: Color(0xff811111),
                            size: 17,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              PickupOrders(orders: widget.orders),
            ],
          ),
        ),
      ),
    );
  }
}

class PickupOrders extends StatefulWidget {
  const PickupOrders({Key key, this.orders}) : super(key: key);
  final dynamic orders;

  @override
  _PickupOrdersState createState() => _PickupOrdersState();
}

class _PickupOrdersState extends State<PickupOrders> {
  @override
  Widget build(BuildContext context) {
    var orders = widget.orders;
    var orderIds = orders.keys.toList();
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: orderIds.length,
      itemBuilder: (BuildContext context, int i) {
        return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
          decoration: BoxDecoration(
            color: Color(0xfff6f6f6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Order ID: ",
                    style: textStyle1(
                      11,
                      Colors.black,
                      FontWeight.w500,
                    ),
                  ),
                  Text(
                    orderIds[i],
                    style: textStyle1(
                      11,
                      Colors.black,
                      FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              PickupOrderItems(items: orders[orderIds[i]]),
            ],
          ),
        );
      },
    );
  }
}

class PickupOrderItems extends StatefulWidget {
  const PickupOrderItems({Key key, this.items}) : super(key: key);
  final dynamic items;

  @override
  _PickupOrderItemsState createState() => _PickupOrderItemsState();
}

class _PickupOrderItemsState extends State<PickupOrderItems> {
  @override
  Widget build(BuildContext context) {
    var items = widget.items;
    return ListView.builder(
      itemCount: items.length * 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
      itemBuilder: (BuildContext context, int item_i) {
        item_i %= 1;
        return Row(
          children: <Widget>[
            Text(
              "Item: ",
              style: textStyle1(
                10,
                Colors.black54,
                FontWeight.w500,
              ),
            ),
            Text(
              items[item_i]['reference'],
              style: textStyle1(
                10,
                Colors.black54,
                FontWeight.normal,
              ),
            ),
          ],
        );
      },
    );
  }
}
