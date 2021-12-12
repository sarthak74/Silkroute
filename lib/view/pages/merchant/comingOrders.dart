import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/model/core/MerchantOrderItem.dart';
import 'package:silkroute/provider/Merchantorderprovider.dart';
import 'package:silkroute/view/dialogBoxes/merchantOrderSortDialogBox.dart';
import 'package:silkroute/view/pages/reseller/product.dart';
import 'package:silkroute/view/widget/merchantOrderTile.dart';
import 'package:silkroute/view/widget/show_dialog.dart';

class ComingOrders extends StatefulWidget {
  const ComingOrders({Key key}) : super(key: key);

  @override
  _ComingOrdersState createState() => _ComingOrdersState();
}

class _ComingOrdersState extends State<ComingOrders> {
  List _orders = [];
  bool loading = true;
  bool _btnShow = false;
  bool _sortShow = false;
  bool _filterShow = false;

  dynamic _merchantOrderProvider = new MerchantOrderProvider();

  void loadVars() async {
    // List orderss = await MerchantOrderProvider().getTwentyOrders();
    setState(() {
      // orders = orderss;
      _btnShow = false;
      loading = false;
    });
  }

  void sortFunction() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (context, _a1, _a2, _child) {
        return ScaleTransition(
          child: _child,
          scale: CurvedAnimation(parent: _a1, curve: Curves.bounceOut),
        );
      },
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, a1, a2) {
        return ShowDialog(MerchantorderSortDialogBox(), 0);
      },
    );
    setState(() {
      _sortShow = true;
    });
  }

  void refreshList() async {
    setState(() {
      _btnShow = false;
    });
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      _orders = [];
      _merchantOrderProvider.productApiResult(null);
    });
    await _merchantOrderProvider.setProductListStream(0);
    await _merchantOrderProvider.search();
    setState(() {
      _btnShow = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
    _merchantOrderProvider.search();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // Container(
          //   margin: EdgeInsets.symmetric(
          //       vertical: 2,
          //       horizontal: MediaQuery.of(context).size.width * 0.05),
          //   height: 30,
          //   width: MediaQuery.of(context).size.width,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: <Widget>[
          //       GestureDetector(
          //         onTap: () {
          //           sortFunction();
          //         },
          //         child: Row(
          //           children: [
          //             Icon(Icons.sort, size: 25),
          //             Text(
          //               " Sort",
          //               style: textStyle(13, Colors.black),
          //             )
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // SizedBox(height: 20),

          //// ORDER LIST

          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
            ),
            height: MediaQuery.of(context).size.height * 0.58,
            child: SingleChildScrollView(
              child: StreamBuilder<List<MerchantOrderItem>>(
                stream: _merchantOrderProvider.productListStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return Text("Fetched");
                  } else if (snapshot.hasError) {
                    return Text("Error");
                  } else {
                    if (snapshot.data != null) {
                      _orders.addAll(snapshot.data);
                      print("_orders ${_orders.length} $_orders");
                      return MerchantOrderTile(orders: _orders);
                    } else {
                      return Text("No more data to show");
                    }
                  }
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _sortShow
                  ? GestureDetector(
                      onTap: () {
                        refreshList();
                        setState(() {
                          _sortShow = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Apply Sort",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(width: 10),
              _btnShow
                  ? GestureDetector(
                      onTap: () => _merchantOrderProvider.loadMore(),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Load More",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(width: 10),
              _filterShow
                  ? GestureDetector(
                      onTap: () {
                        refreshList();

                        _filterShow = false;
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Apply Filters",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
