import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/OrderListItem.dart';
import 'package:silkroute/provider/Merchantorderprovider.dart';
import 'package:silkroute/view/dialogBoxes/merchantOrderSortDialogBox.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/show_dialog.dart';
import 'package:silkroute/view/widget/topbar.dart';
import 'package:silkroute/view/widget2/footer.dart';

class MerchantOrders extends StatefulWidget {
  const MerchantOrders({Key key}) : super(key: key);

  @override
  _MerchantOrdersState createState() => _MerchantOrdersState();
}

class _MerchantOrdersState extends State<MerchantOrders> {
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
    _orders = [];
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Navbar(),
        primary: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/1.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: <Widget>[
              //////////////////////////////
              ///                        ///
              ///         TopBar         ///
              ///                        ///
              //////////////////////////////

              TopBar(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),

              Expanded(
                child: loading
                    ? Text("Loading")
                    : CustomScrollView(slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Icon(
                              Icons.receipt_long,
                              size: MediaQuery.of(context).size.height * 0.1,
                            ),
                            SizedBox(height: 20),

                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.07),
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      sortFunction();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.sort, size: 25),
                                        Text(
                                          " Sort",
                                          style: textStyle(13, Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),

                            //// ORDER LIST

                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: StreamBuilder<List<OrderListItem>>(
                                stream:
                                    _merchantOrderProvider.productListStream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text("Loading");
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Text("Fetched");
                                  } else if (snapshot.hasError) {
                                    return Text("Error");
                                  } else {
                                    if (snapshot.data != null) {
                                      _orders.addAll(snapshot.data);
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _orders.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            margin: EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 120,
                                            color: Colors.grey[200],
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/1.png"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.59,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        _orders[i].title,
                                                        style: textStyle(
                                                            12, Colors.black),
                                                      ),
                                                      Text(
                                                        "Dispatch Date: " +
                                                            _orders[i]
                                                                .dispatchDate
                                                                .toString(),
                                                        style: textStyle(
                                                            12, Colors.black45),
                                                      ),
                                                      Text(
                                                        "Invoice No.: " +
                                                            _orders[i]
                                                                .invoiceNumber,
                                                        style: textStyle(
                                                            12, Colors.black45),
                                                      ),
                                                      Text(
                                                        "Payment Status: " +
                                                            _orders[i]
                                                                .paymentStatus,
                                                        style: textStyle(
                                                            12, Colors.black45),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return Text("No more data to show");
                                    }
                                  }
                                },
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
                                          padding:
                                              EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
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
                                        onTap: () =>
                                            _merchantOrderProvider.loadMore(),
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
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
                                          padding:
                                              EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
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
                            SizedBox(height: 30),
                          ]),
                        ),
                        SliverFillRemaining(
                            hasScrollBody: false, child: Container()),
                      ]),
              ),

              //////////////////////////////
              ///                        ///
              ///         Footer         ///
              ///                        ///
              //////////////////////////////
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

// class MerchantOrderList extends StatelessWidget {
//   const MerchantOrderList({
//     Key key,
//     @required this.orders,
//   }) : super(key: key);

//   final List orders;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: orders.length,
//       itemBuilder: (BuildContext context, int i) {
//         return Container(
//           padding: EdgeInsets.symmetric(vertical: 10),
//           margin: EdgeInsets.symmetric(
//               vertical: 10,
//               horizontal: MediaQuery.of(context).size.width * 0.05),
//           width: MediaQuery.of(context).size.width,
//           height: 100,
//           color: Colors.grey[200],
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/images/1.png"),
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.59,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       orders[i]["title"],
//                       style: textStyle(12, Colors.black),
//                     ),
//                     Text(
//                       "Dispatch Date: " + orders[i]["dispatchDate"],
//                       style: textStyle(12, Colors.black45),
//                     ),
//                     Text(
//                       "Invoice No.: " + orders[i]["invoiceNumber"],
//                       style: textStyle(12, Colors.black45),
//                     ),
//                     Text(
//                       "Payment Status: " + orders[i]["paymentStatus"],
//                       style: textStyle(12, Colors.black45),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
