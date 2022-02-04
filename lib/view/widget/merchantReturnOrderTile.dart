import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:silkroute/constants/values.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/methods/payment_methods.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/MerchantApi.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
// import 'package:silkroute/view/pages/reseller/order_page.dart';
// import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/pages/reseller/product.dart';
import 'package:silkroute/view/widget/timeline_builder.dart';

class MerchantReturnOrderTile extends StatefulWidget {
  const MerchantReturnOrderTile({Key key, this.orders}) : super(key: key);
  final dynamic orders;

  @override
  _MerchantOrderTileState createState() => _MerchantOrderTileState();
}

class _MerchantOrderTileState extends State<MerchantReturnOrderTile> {
  bool loading = true;
  List<dynamic> orders = [];
  Icon icon;
  List<bool> isExpanded = [];

  Future<void> confirmOrder(int index, dynamic body) async {
    var res = await OrderApi().updateOrderItem(
        widget.orders[index].orderId, widget.orders[index].productId, body);

    // ignore: todo
    //TODO: createShipRocketOrder

    if (res['success'] == true) {
      if (orders[index]['merchantStatus'] == "Not Seen") {
        setState(() {
          orders[index]['merchantStatus'] = "Not Ready";
        });
      } else {
        setState(() {
          orders[index]['merchantStatus'] = "Ready";
        });
      }
    } else {
      Toast().notifyErr("Error Occurred, Please try again");
    }
  }

  void loadVars() {
    print("order list item ${widget.orders}");
    setState(() {
      orders = widget.orders;
      for (var order in widget.orders) {
        isExpanded.add(false);
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
    return loading
        ? Text("Loading")
        : (orders.length > 0)
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int i) {
                  // print("order-i$i : ${orders[i]}");
                  // dynamic date = orders[i]['return']['requestedDate']
                  //     .toString()
                  //     .split(":");
                  // print(date);
                  // dynamic left = date[0].split("T");
                  // dynamic reqDate = left[0] + " " + left[1] + ":" + date[1];
                  // orders[i]['return']['requestedDate'] = reqDate.toString();
                  return ReturnOrderItem(orders[i]);
                },
              )
            : Text(
                "No return items",
                style: textStyle1(
                  12,
                  Colors.black54,
                  FontWeight.w500,
                ),
              );
  }
}

class ReturnOrderItem extends StatefulWidget {
  const ReturnOrderItem(this.item, {Key key}) : super(key: key);
  final dynamic item;

  @override
  _ReturnOrderItemState createState() => _ReturnOrderItemState();
}

class _ReturnOrderItemState extends State<ReturnOrderItem> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        child: ExpansionPanelList(
          expansionCallback: (int index, bool exp) {
            setState(() {
              isExpanded = !exp;
            });
          },
          expandedHeaderPadding: EdgeInsets.all(0),
          animationDuration: Duration(milliseconds: 500),
          children: [
            ExpansionPanel(
              backgroundColor: Colors.grey[200],
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "ID: ",
                            style: textStyle1(
                              11,
                              Colors.black,
                              FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.item['invoiceNumber'].toString(),
                            style: textStyle1(
                              11,
                              Colors.black,
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Text(
                            "Date: ",
                            style: textStyle1(
                              10,
                              Colors.black54,
                              FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.item['items'][0]['return']['requestedDate']
                                .toString(),
                            style: textStyle1(
                              10,
                              Colors.black54,
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Text(
                            "Refund Amount: ",
                            style: textStyle1(
                              10,
                              Color(0xFF811111),
                              FontWeight.bold,
                            ),
                          ),
                          Text(
                            ConstantValues().rupee() +
                                widget.item['refundAmount'].toString(),
                            style: textStyle1(
                              10,
                              Color(0xFF811111),
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              body: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: TimelineBuilder(
                        list: [
                          "Return Requested",
                          "Warehouse",
                          "On the way",
                          "Delivered"
                        ],
                        currentStatus: widget.item['items'][0]
                            ['merchantStatus'],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          // if 2nd argument false, then it acts as return details
                          await Helpers().showRequestReturn(context, false,
                              orderDetails: widget.item);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF811111),
                          padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Details",
                              style: textStyle1(
                                10,
                                Colors.white,
                                FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              CupertinoIcons.right_chevron,
                              size: 13,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isExpanded: isExpanded,
            ),
          ],
        ),
      ),
    );
  }
}
