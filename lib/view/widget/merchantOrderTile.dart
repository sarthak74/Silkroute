import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:silkroute/methods/payment_methods.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/MerchantApi.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/model/services/PaymentGatewayService.dart';
import 'package:silkroute/view/pages/merchant/merchant_order_detail.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
// import 'package:silkroute/view/pages/reseller/order_page.dart';
// import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/pages/reseller/product.dart';

class MerchantOrderTile extends StatefulWidget {
  const MerchantOrderTile({Key key, this.orders}) : super(key: key);
  final dynamic orders;

  @override
  _MerchantOrderTileState createState() => _MerchantOrderTileState();
}

class _MerchantOrderTileState extends State<MerchantOrderTile> {
  bool loading = true;
  List<dynamic> orders = [], _status;
  Icon icon;
  dynamic user;
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
        // todo:

        if (user == null) {
          user = await Methods().getUser();
        }

        // relese onhold from item
        await PaymentGatewayService()
            .releaseHold(widget.orders[index].razorpayItemId);

        // dynamic data = {
        //   "account": user['razorpay']['accountId'],
        //   "amount": widget.orders[index].mrp,
        //   "currency": 'INR'
        // };

        // await PaymentGatewayService().directTransfer(data);
      }
    } else {
      Toast().notifyErr("Error Occurred, Please try again");
    }
  }

  void loadVars() {
    print("order list item ${widget.orders}");
    setState(() {
      for (var order in widget.orders) {
        orders.add({
          "invoiceNumber": order["invoiceNumber"],
          "createdDate": order["createdDate"],
          "bill": order["bill"],
          "items": order["items"].map((item) => item.toMap()).toList()
        });
        isExpanded.add(false);
      }
      _status = [
        "By accepting this, you confirm that you have seen order and started working on it. You can't undo this action!",
        "By accepting this, you confirm that your order is completed and ready to be shipped. You can't undo this action!"
      ];
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
        ? Center(
            widthFactor: 1,
            heightFactor: 1,
            child: CircularProgressIndicator(
              color: Color(0xFF811111),
              strokeWidth: 2,
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: 5,
                ),

                // constraints: BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  // border: Border(
                  //   left: BorderSide(
                  //     width: 15,
                  //     color: Color(0xFF811111),
                  //   ),
                  // ),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 20,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Color(0xFF811111),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    // SizedBox(width: 15),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 59,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Order No:",
                                  style: textStyle1(
                                    13,
                                    Colors.black,
                                    FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  widget.orders[i]['invoiceNumber'].toString(),
                                  style: textStyle1(
                                    13,
                                    Colors.black,
                                    FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Date:",
                                      style: textStyle1(
                                        13,
                                        Colors.black,
                                        FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      widget.orders[i]['createdDate']
                                          .toString(),
                                      style: textStyle1(
                                        13,
                                        Colors.black,
                                        FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF811111),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "Schedule Pickup",
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

                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MerchantOrderDetail(
                                  order: orders[i],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 70,
                            color: Color.fromRGBO(250, 210, 110, 1),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  void showConfirmationAlert(int i, dynamic body, int status) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          _status[status],
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Color(0xFF5B0D1B),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Text(
              "Confirm",
              style: textStyle1(15, Color(0xFF5B0D1B), FontWeight.bold),
            ),
            onTap: () async {
              await confirmOrder(i, body);
              Navigator.of(context).pop();
            },
          ),
          SizedBox(width: 20),
          GestureDetector(
            child: Text(
              "Cancel",
              style: textStyle1(15, Color(0xFF5B0D1B), FontWeight.bold),
            ),
            onTap: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

/*

Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                  id: (orders[i]['productId']).toString()),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/1.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                        id: (orders[i]['productId'])
                                            .toString()),
                                  ),
                                );
                              },
                              child: Text(
                                orders[i]['title'],
                                style: textStyle(12, Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              width: 130,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: orders[i]['colors'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: 20,
                                    height: 20,
                                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          10,
                                        ),
                                      ),
                                      image: DecorationImage(
                                        // image: NetworkImage(Math().ip() +
                                        //     "/images/616ff5ab029b95081c237c89-color-0"),
                                        image: NetworkImage(
                                            "https://raw.githubusercontent.com/sarthak74/Yibrance-imgaes/master/category-Suit.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              "Quantity: ${orders[i]['quantity']}",
                              style: textStyle(12, Colors.grey45),
                            ),
                            Text(
                              "Order Date: ${orders[i]['createdDate']}",
                              style: textStyle(12, Colors.grey45),
                            ),
                            Text(
                              "Your Status: ${orders[i]['merchantStatus']}",
                              style: textStyle(12, Colors.grey45),
                            ),
                            Text(
                              "Pay Status: " +
                                  orders[i]['merchantPaymentStatus'],
                              style: textStyle(12, Colors.grey45),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (orders[i]['merchantStatus'] == "Not Seen") {
                            await showConfirmationAlert(
                                i, {'merchantStatus': 'Not Ready'}, 0);
                          } else if (orders[i]['merchantStatus'] ==
                              "Not Ready") {
                            await showConfirmationAlert(
                                i, {'merchantStatus': 'Ready'}, 1);
                          } else {
                            Toast().notifyInfo("Order already Confirmed");
                          }
                        },
                        icon: Icon((orders[i]['merchantStatus'] == "Not Seen")
                            ? Icons.check
                            : ((orders[i]['merchantStatus'] == "Not Ready")
                                ? Icons.check_box_outlined
                                : Icons.check_box)),
                      ),
                    ],
                  ),

*/

/*


// Expanded(
                    //   flex: 1,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => ProductPage(
                    //             id: (orders[i]['productId']).toString(),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //     child: Container(
                    //       constraints: BoxConstraints(
                    //         maxWidth: MediaQuery.of(context).size.width * 0.2,
                    //         maxHeight: 90,
                    //       ),
                    //       child: Image.asset(
                    //         "assets/images/1.png",
                    //         fit: BoxFit.contain,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Expanded(
                    //   flex: 4,
                    //   child: Container(
                    //     alignment: Alignment.topLeft,
                    //     margin: EdgeInsets.only(left: 5),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: <Widget>[
                    //         Row(
                    //           children: <Widget>[
                    //             Expanded(
                    //               flex: 7,
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.start,
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: <Widget>[
                    //                   Text(
                    //                     orders[i]["title"],
                    //                     maxLines: 2,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: textStyle1(
                    //                       12,
                    //                       Colors.black,
                    //                       FontWeight.w700,
                    //                     ),
                    //                   ),
                    //                   SizedBox(height: 5),
                    //                   Row(
                    //                     children: <Widget>[
                    //                       SingleChildScrollView(
                    //                         child: Scrollbar(
                    //                           child: Container(
                    //                             width: MediaQuery.of(context)
                    //                                     .size
                    //                                     .width *
                    //                                 0.5,
                    //                             height: 21,
                    //                             child: ListView.builder(
                    //                               shrinkWrap: true,
                    //                               scrollDirection:
                    //                                   Axis.horizontal,
                    //                               physics:
                    //                                   NeverScrollableScrollPhysics(),
                    //                               itemCount: orders[i]["colors"]
                    //                                   .length,
                    //                               itemBuilder:
                    //                                   (BuildContext context,
                    //                                       int i) {
                    //                                 return Container(
                    //                                   margin: EdgeInsets.only(
                    //                                       right: 5),
                    //                                   height: 20,
                    //                                   width: 20,
                    //                                   decoration: BoxDecoration(
                    //                                     color: Colors.grey,
                    //                                     borderRadius:
                    //                                         BorderRadius
                    //                                             .circular(10),
                    //                                   ),
                    //                                 );
                    //                               },
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       orders[i]['colors'].length * 25 >=
                    //                               MediaQuery.of(context)
                    //                                       .size
                    //                                       .width *
                    //                                   0.5
                    //                           ? Icon(
                    //                               Icons.arrow_forward_ios,
                    //                               size: 18,
                    //                             )
                    //                           : Container(),
                    //                     ],
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             Expanded(
                    //               flex: 2,
                    //               child: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.end,
                    //                 children: <Widget>[
                    //                   Text(
                    //                     "${orders[i]['createdDate']}",
                    //                     style: textStyle1(
                    //                       11,
                    //                       Colors.grey[700],
                    //                       FontWeight.w500,
                    //                     ),
                    //                   ),
                    //                   SizedBox(height: 5),
                    //                   GestureDetector(
                    //                     onTap: () async {
                    //                       if (orders[i]['merchantStatus'] ==
                    //                           "Not Seen") {
                    //                         await showConfirmationAlert(
                    //                             i,
                    //                             {'merchantStatus': 'Not Ready'},
                    //                             0);
                    //                       } else if (orders[i]
                    //                               ['merchantStatus'] ==
                    //                           "Not Ready") {
                    //                         await showConfirmationAlert(i,
                    //                             {'merchantStatus': 'Ready'}, 1);
                    //                       } else {
                    //                         Toast().notifyInfo(
                    //                             "Order already Confirmed");
                    //                       }
                    //                     },
                    //                     child: Icon(
                    //                       (orders[i]['merchantStatus'] ==
                    //                               "Not Seen")
                    //                           ? Icons.check
                    //                           : ((orders[i]['merchantStatus'] ==
                    //                                   "Not Ready")
                    //                               ? Icons.check_box_outlined
                    //                               : Icons.check_box),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(height: 5),
                    //         ExpansionPanelList(
                    //           expansionCallback: (int index, bool expanded) {
                    //             setState(() {
                    //               isExpanded[i] = !expanded;
                    //             });
                    //           },
                    //           expandedHeaderPadding: EdgeInsets.all(0),
                    //           animationDuration: Duration(milliseconds: 500),
                    //           elevation: 0,
                    //           children: [
                    //             ExpansionPanel(
                    //               canTapOnHeader: true,
                    //               isExpanded: isExpanded[i],
                    //               backgroundColor: Colors.grey[200],
                    //               headerBuilder:
                    //                   (BuildContext context, bool isExpanded) {
                    //                 return Column(
                    //                   children: <Widget>[
                    //                     Row(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.start,
                    //                       children: <Widget>[
                    //                         Text(
                    //                           "Prod Id: ",
                    //                           style: textStyle1(
                    //                             12,
                    //                             Colors.grey[700],
                    //                             FontWeight.w700,
                    //                           ),
                    //                         ),
                    //                         Expanded(
                    //                           child: Text(
                    //                             "${orders[i]['productId']}",
                    //                             style: textStyle1(
                    //                               11,
                    //                               Colors.grey[700],
                    //                               FontWeight.w500,
                    //                             ),
                    //                             maxLines: 2,
                    //                             overflow: TextOverflow.ellipsis,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     Row(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.start,
                    //                       children: <Widget>[
                    //                         Text(
                    //                           "Quantity: ",
                    //                           style: textStyle1(
                    //                             11,
                    //                             Colors.grey[700],
                    //                             FontWeight.w700,
                    //                           ),
                    //                         ),
                    //                         Expanded(
                    //                           child: Text(
                    //                             "${orders[i]['quantity']}",
                    //                             style: textStyle1(
                    //                               11,
                    //                               Colors.grey[700],
                    //                               FontWeight.w500,
                    //                             ),
                    //                             maxLines: 2,
                    //                             overflow: TextOverflow.ellipsis,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 );
                    //               },
                    //               body: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: <Widget>[
                    //                   Expanded(
                    //                     flex: 3,
                    //                     child: Column(
                    //                       children: <Widget>[
                    //                         Row(
                    //                           crossAxisAlignment:
                    //                               CrossAxisAlignment.start,
                    //                           children: <Widget>[
                    //                             Text(
                    //                               "Order Id: ",
                    //                               style: textStyle1(
                    //                                 11,
                    //                                 Colors.grey[700],
                    //                                 FontWeight.w700,
                    //                               ),
                    //                             ),
                    //                             Expanded(
                    //                               child: Text(
                    //                                 "${orders[i]['orderId']}",
                    //                                 style: textStyle1(
                    //                                   11,
                    //                                   Colors.grey[700],
                    //                                   FontWeight.w500,
                    //                                 ),
                    //                                 maxLines: 2,
                    //                                 overflow:
                    //                                     TextOverflow.ellipsis,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         Row(
                    //                           crossAxisAlignment:
                    //                               CrossAxisAlignment.start,
                    //                           children: <Widget>[
                    //                             Text(
                    //                               "Payment: ",
                    //                               style: textStyle1(
                    //                                 11,
                    //                                 Colors.grey[700],
                    //                                 FontWeight.w700,
                    //                               ),
                    //                             ),
                    //                             Expanded(
                    //                               child: Text(
                    //                                 "${orders[i]['merchantPaymentStatus']}",
                    //                                 style: textStyle1(
                    //                                   11,
                    //                                   Colors.grey[700],
                    //                                   FontWeight.w500,
                    //                                 ),
                    //                                 maxLines: 2,
                    //                                 overflow:
                    //                                     TextOverflow.ellipsis,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   Expanded(
                    //                     flex: 1,
                    //                     child: Column(
                    //                       children: <Widget>[
                    //                         Text(
                    //                           (orders[i]['refund'] != null &&
                    //                                   orders[i]['refund']
                    //                                       ['requested'])
                    //                               ? "Return Req"
                    //                               : "${orders[i]['merchantStatus']}",
                    //                           style: textStyle1(
                    //                             11,
                    //                             Colors.grey[700],
                    //                             FontWeight.w700,
                    //                           ),
                    //                         ),
                    //                         Text(
                    //                           "${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                    //                           style: textStyle1(
                    //                             11,
                    //                             Colors.grey[700],
                    //                             FontWeight.w500,
                    //                           ),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    */