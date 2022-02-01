import 'package:silkroute/constants/values.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/view/widget/timeline_builder.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class ResellerReturnOrders extends StatefulWidget {
  const ResellerReturnOrders({Key key, this.orders}) : super(key: key);
  final dynamic orders;

  @override
  _ResellerReturnOrdersState createState() => _ResellerReturnOrdersState();
}

class _ResellerReturnOrdersState extends State<ResellerReturnOrders> {
  List _orders = [];
  bool loading = true;

  void loadVars() async {
    _orders = await OrderApi().getResellerReturnOrders();
    setState(() {
      loading = false;
    });
  }

  // void sortFunction() {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: "",
  //     transitionBuilder: (context, _a1, _a2, _child) {
  //       return ScaleTransition(
  //         child: _child,
  //         scale: CurvedAnimation(parent: _a1, curve: Curves.bounceOut),
  //       );
  //     },
  //     transitionDuration: Duration(milliseconds: 800),
  //     pageBuilder: (context, a1, a2) {
  //       return ShowDialog(MerchantorderSortDialogBox(), 0);
  //     },
  //   );
  //   setState(() {
  //     _sortShow = true;
  //   });
  // }

  // void refreshList() async {
  //   setState(() {
  //     _btnShow = false;
  //   });
  //   FocusScopeNode currentFocus = FocusScope.of(context);

  //   if (!currentFocus.hasPrimaryFocus) {
  //     currentFocus.unfocus();
  //   }
  //   setState(() {
  //     _orders = [];
  //     _resellerReturnOrderProvider.productApiResult(null);
  //   });
  //   await _resellerReturnOrderProvider.setProductListStream(0);
  //   // flag 0 for orderType(coming or return)
  //   await _resellerReturnOrderProvider.search();
  //   setState(() {
  //     _btnShow = true;
  //   });
  // }

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
              strokeWidth: 3,
              color: Color(0xFF811111),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ResellerReturnOrderList(_orders),
              ],
            ),
          );
  }
}

class ResellerReturnOrderList extends StatefulWidget {
  const ResellerReturnOrderList(this.orders, {Key key}) : super(key: key);
  final dynamic orders;

  @override
  _ResellerReturnOrderListState createState() =>
      _ResellerReturnOrderListState();
}

class _ResellerReturnOrderListState extends State<ResellerReturnOrderList> {
  bool loading = true;
  List<dynamic> orders = [];
  Icon icon;
  List<bool> isExpanded = [];

  void loadVars() {
    // print("order list item ${widget.orders}");
    setState(() {
      orders = widget.orders;
      print("--$orders");
      for (var order in orders) {
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
        ? Center(
            widthFactor: 1,
            heightFactor: 1,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Color(0xFF811111),
            ),
          )
        : (orders.length > 0)
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int order_i) {
                  return ReturnOrderItem(orders[order_i]);
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
  // item = order[i] = {id: invoiceNumber, bill: {..}, ... items: [...]}
  @override
  _ReturnOrderItemState createState() => _ReturnOrderItemState();
}

class _ReturnOrderItemState extends State<ReturnOrderItem> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      decoration: BoxDecoration(
        color: Color(0xFF811111),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
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
                              widget.item['id'].toString(),
                              style: textStyle1(
                                11,
                                Colors.black,
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
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
                              widget.item['createdDate'].toString(),
                              style: textStyle1(
                                10,
                                Colors.black54,
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
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
                  title: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: TimelineBuilder(
                              list: [
                                "Return Requested",
                                "Pickup Successfull",
                                "Refund Successfull"
                              ],
                              currentStatus: widget.item['customerStatus'],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Helpers().showRequestReturn(
                                    context, false,
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
                    ],
                  ),
                ),
                isExpanded: isExpanded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
