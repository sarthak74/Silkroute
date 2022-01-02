import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:silkroute/methods/payment_methods.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/MerchantApi.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
// import 'package:silkroute/view/pages/reseller/order_page.dart';
// import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/pages/reseller/product.dart';

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
    // print("order list item ${widget.orders}");
    setState(() {
      for (var order in widget.orders) {
        orders.add(order.toMap());
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
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int i) {
              dynamic date =
                  orders[i]['refund']['requestedDate'].toString().split(":");
              print(date);
              dynamic left = date[0].split("T");
              dynamic reqDate = left[0] + " " + left[1] + ":" + date[1];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                margin: EdgeInsets.symmetric(
                  vertical: 5,
                ),

                // constraints: BoxConstraints(maxHeight: 120),
                color: Colors.grey[200],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                id: (orders[i]['productId']).toString(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.2,
                            maxHeight: 90,
                          ),
                          child: Image.asset(
                            "assets/images/1.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        orders[i]["title"],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: textStyle1(
                                          12,
                                          Colors.black,
                                          FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: <Widget>[
                                          SingleChildScrollView(
                                            child: Scrollbar(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                height: 21,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: orders[i]["colors"]
                                                      .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int i) {
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          orders[i]['colors'].length * 25 >=
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5
                                              ? Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 18,
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "${orders[i]['createdDate']}",
                                        style: textStyle1(
                                          11,
                                          Colors.grey[700],
                                          FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            ExpansionPanelList(
                              expansionCallback: (int index, bool expanded) {
                                setState(() {
                                  isExpanded[i] = !expanded;
                                });
                              },
                              expandedHeaderPadding: EdgeInsets.all(0),
                              animationDuration: Duration(milliseconds: 500),
                              elevation: 0,
                              children: [
                                ExpansionPanel(
                                  canTapOnHeader: true,
                                  isExpanded: isExpanded[i],
                                  backgroundColor: Colors.grey[200],
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return Column(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Prod Id: ",
                                              style: textStyle1(
                                                12,
                                                Colors.grey[700],
                                                FontWeight.w700,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${orders[i]['productId']}",
                                                style: textStyle1(
                                                  11,
                                                  Colors.grey[700],
                                                  FontWeight.w500,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Quantity: ",
                                              style: textStyle1(
                                                11,
                                                Colors.grey[700],
                                                FontWeight.w700,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${orders[i]['quantity']}",
                                                style: textStyle1(
                                                  11,
                                                  Colors.grey[700],
                                                  FontWeight.w500,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  body: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "Order Id: ",
                                                  style: textStyle1(
                                                    11,
                                                    Colors.grey[700],
                                                    FontWeight.w700,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${orders[i]['orderId']}",
                                                    style: textStyle1(
                                                      11,
                                                      Colors.grey[700],
                                                      FontWeight.w500,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "Payment: ",
                                                  style: textStyle1(
                                                    11,
                                                    Colors.grey[700],
                                                    FontWeight.w700,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${orders[i]['merchantPaymentStatus']}",
                                                    style: textStyle1(
                                                      11,
                                                      Colors.grey[700],
                                                      FontWeight.w500,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              (orders[i]['refund'] != null &&
                                                      orders[i]['refund']
                                                          ['requested'])
                                                  ? "Return Req"
                                                  : "${orders[i]['merchantStatus']}",
                                              style: textStyle1(
                                                11,
                                                Colors.grey[700],
                                                FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                                              style: textStyle1(
                                                11,
                                                Colors.grey[700],
                                                FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
