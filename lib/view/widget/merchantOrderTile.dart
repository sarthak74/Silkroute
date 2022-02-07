import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:silkroute/methods/payment_methods.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/MerchantApi.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/model/services/PaymentGatewayService.dart';
import 'package:silkroute/model/services/shiprocketApi.dart';
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
        orders.add(order);
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
              return MerchantOrderListItem(order: widget.orders[i]);
            },
          );
  }
}

class MerchantOrderListItem extends StatefulWidget {
  const MerchantOrderListItem({Key key, this.order}) : super(key: key);
  final dynamic order;

  @override
  _MerchantOrderListItemState createState() => _MerchantOrderListItemState();
}

class _MerchantOrderListItemState extends State<MerchantOrderListItem> {
  bool shipping = false;
  @override
  Widget build(BuildContext context) {
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
                        "Order ID: ",
                        style: textStyle1(12, Colors.black, FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.order['invoiceNumber'].toString(),
                        style: textStyle1(12, Colors.black, FontWeight.normal),
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
                              10,
                              Colors.black54,
                              FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            widget.order['createdDate'].toString(),
                            style: textStyle1(
                              10,
                              Colors.black54,
                              FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      // InkWell(
                      //   onTap: () async {
                      //     // var dimensions =
                      //     //     await Helpers().showSchedulePickupDialog(context);

                      //     // setState(() {
                      //     //   shipping = true;
                      //     // });
                      //     // var shipres = await ShiprocketApi()
                      //     //     .createShiprocketOrder(widget.order);
                      //     // setState(() {
                      //     //   shipping = false;
                      //     // });
                      //     // if (shipres != null && shipres['success']) {
                      //     //   Navigator.popAndPushNamed(
                      //     //       context, "/merchant_orders");
                      //     // }
                      //   },
                      //   child: shipping
                      //       ? Container(
                      //           width: 20,
                      //           height: 20,
                      //           child: Center(
                      //             widthFactor: 1,
                      //             heightFactor: 1,
                      //             child: CircularProgressIndicator(
                      //               strokeWidth: 3,
                      //               color: Color(0xFF811111),
                      //             ),
                      //           ),
                      //         )
                      //       : Container(
                      //           padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      //           decoration: BoxDecoration(
                      //             color: Color(0xFF811111),
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           child: Text(
                      //             "Schedule Pickup",
                      //             style: textStyle1(
                      //               11,
                      //               Colors.white,
                      //               FontWeight.w500,
                      //             ),
                      //           ),
                      //         ),
                      // ),
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
                        order: widget.order,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 70,
                  color: Colors.transparent,
                  child: Icon(
                    Icons.double_arrow_rounded,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
