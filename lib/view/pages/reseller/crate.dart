import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/model/core/CrateListItem.dart';
import 'package:silkroute/model/services/CrateApi.dart';
import 'package:silkroute/view/pages/reseller/address.dart';
import 'package:silkroute/view/pages/reseller/crate_page1.dart';
import 'package:silkroute/view/pages/reseller/payment.dart';
import 'package:silkroute/view/widget/crate_product_tile.dart';
import 'package:silkroute/view/widget/flutter_dash.dart';
import 'package:silkroute/view/widget/subcategory_head.dart';
import 'package:silkroute/view/widget/product_tile.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

class CratePage extends StatefulWidget {
  CratePage({this.category});

  final String category;
  bool addressStatus = false, paymentStatus = false;

  @override
  _CratePageState createState() => _CratePageState();
}

class _CratePageState extends State<CratePage> {
  bool addressStatus = CratePage().addressStatus,
      paymentStatus = CratePage().paymentStatus;
  List<CrateListItem> _crateList;
  List products = [];
  bool loading = true;
  dynamic bill;

  void loadProducts() async {
    dynamic res = await CrateApi().getCrateItems();
    _crateList = res.item1;
    print("crate_pr: $_crateList");
    for (var x in _crateList) {
      var data = x.toMap();
      setState(() {
        products.add(data);
      });
    }
    setState(() {
      bill = res.item2.toMap();
      loading = false;
    });
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProducts();
    });
    super.initState();
  }

  TextStyle textStyle(num size, Color color) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    pageController.addListener(() {
      // print("\nPage -- ${pageController.page.floor()}\n");
      int val = pageController.page.floor();

      setState(() {
        if (val == 0) {
          // print("\nPage -- 0\n");
          addressStatus = false;
          paymentStatus = false;
          CratePage().addressStatus = false;
          CratePage().paymentStatus = false;
        } else if (val == 1) {
          // print("\nPage -- 1\n");
          addressStatus = true;
          paymentStatus = false;
          CratePage().addressStatus = true;
          CratePage().paymentStatus = false;
        } else {
          // print("\nPage -- 2\n");
          addressStatus = true;
          paymentStatus = true;
          CratePage().addressStatus = true;
          CratePage().paymentStatus = true;
        }
      });
    });
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
      child: Scaffold(
        drawer: Navbar(),
        primary: false,
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/1.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: loading
                ? Text("Loading")
                : Column(
                    children: <Widget>[
                      //////////////////////////////
                      ///                        ///
                      ///         TopBar         ///
                      ///                        ///
                      //////////////////////////////

                      TopBar(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15),

                      Expanded(
                        child: CustomScrollView(slivers: [
                          SliverList(
                            delegate: SliverChildListDelegate([
                              ////////////////////////
                              ///  Top BreadCrumb  ///
                              ////////////////////////

                              Container(
                                padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width * 0.15,
                                  0,
                                  MediaQuery.of(context).size.width * 0.15,
                                  0,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        /////  Left Connector
                                        Positioned(
                                          bottom: 11,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.36,
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: addressStatus
                                                    ? Color(0xFF5B0D1B)
                                                    : Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                        ),

                                        /////  Right Connector
                                        Positioned(
                                          bottom: 11,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.34,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.36,
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: paymentStatus
                                                    ? Color(0xFF5B0D1B)
                                                    : Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            /// Crate Status
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5B0D1B),
                                            ),

                                            /// Address Status
                                            Icon(
                                              Icons.circle,
                                              color: addressStatus
                                                  ? Color(0xFF5B0D1B)
                                                  : Colors.grey[400],
                                            ),

                                            /// Payment Status
                                            Icon(
                                              Icons.circle,
                                              color: paymentStatus
                                                  ? Color(0xFF5B0D1B)
                                                  : Colors.grey[400],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Crate",
                                            style: textStyle(
                                                12.0, Color(0xFF5B0D1B))),
                                        Text("Address",
                                            style: textStyle(
                                                12.0,
                                                addressStatus
                                                    ? Color(0xFF5B0D1B)
                                                    : Colors.grey[400])),
                                        Text("Payment",
                                            style: textStyle(
                                                12.0,
                                                paymentStatus
                                                    ? Color(0xFF5B0D1B)
                                                    : Colors.grey[400])),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.05),

                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.55,
                                child: PageView(
                                  controller: pageController,
                                  children: [
                                    CratePage1(
                                      pageController: pageController,
                                      products: products,
                                      bill: bill,
                                    ),
                                    AddressPage(pageController: pageController),
                                    PaymentPage(
                                      pageController: pageController,
                                      crateList: _crateList,
                                      bill: bill,
                                    ),
                                  ],
                                ),
                              ),
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
        // bottomNavigationBar: Footer(),
      ),
    );
  }
}
