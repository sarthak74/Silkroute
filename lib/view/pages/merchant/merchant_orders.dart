import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/MerchantOrderItem.dart';

import 'package:silkroute/provider/Merchantorderprovider.dart';
import 'package:silkroute/view/dialogBoxes/merchantOrderSortDialogBox.dart';
import 'package:silkroute/view/pages/merchant/comingOrders.dart';
import 'package:silkroute/view/pages/merchant/returnOrders.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/merchantOrderTile.dart';
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
  bool loading = true;

  void loadVars() {
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  PageController pageController = new PageController();
  int page = 0;
  TextStyle activePageTextStyle =
      textStyle1(13, Color(0xFF5B0D1B), FontWeight.bold);
  TextStyle inActivePageTextStyle =
      textStyle1(13, Colors.black, FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    pageController.addListener(() {
      setState(() {
        page = pageController.page.floor();
      });
    });
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
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      pageController.animateToPage(0,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeOut);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xFFF0E7DA),
                                      side: BorderSide(
                                        width: 2,
                                        color: Color(0xFF811111),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      "Incoming Orders",
                                      style: (page == 0)
                                          ? activePageTextStyle
                                          : inActivePageTextStyle,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      pageController.animateToPage(1,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeOut);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xFFF0E7DA),
                                      side: BorderSide(
                                        width: 2,
                                        color: Color(0xFF811111),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      "Return Orders",
                                      style: (page == 1)
                                          ? activePageTextStyle
                                          : inActivePageTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.59,
                              child: PageView(
                                controller: pageController,
                                children: [
                                  ComingOrders(),
                                  ReturnOrders(),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                          ]),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(),
                        ),
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
