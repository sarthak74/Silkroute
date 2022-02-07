import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/checkAccountDetails.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/notification_service.dart';
import 'package:silkroute/methods/showdailog.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/services/MerchantHomeAPI.dart';
import 'package:silkroute/model/services/ResellerHomeApi.dart';
import 'package:silkroute/model/services/firebase.dart';
import 'package:silkroute/provider/ProductListProvider.dart';
import 'package:silkroute/view/dialogBoxes/editAccountDetailsBottomsheet.dart';
import 'package:silkroute/view/pages/reseller/order_page.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/carousel_indicator.dart';
import 'package:silkroute/view/widget/product_tile.dart';
import 'package:silkroute/view/widget/customBottomSheet.dart';
import 'package:silkroute/view/widget/topSelling.dart';
import 'package:silkroute/view/widget2/allProducts.dart';
import 'package:silkroute/view/widget2/footer.dart';
import 'package:silkroute/view/widget/horizontal_list_view.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topIcon.dart';
import 'package:silkroute/view/widget/top_picks.dart';
import 'package:silkroute/view/widget/topbar.dart';

class MerchantHome extends StatefulWidget {
  static dynamic categoriess, tags;
  @override
  _MerchantHomeState createState() => _MerchantHomeState();
}

class _MerchantHomeState extends State<MerchantHome> {
  bool loading = true;

  List<dynamic> adList = [];

  List<dynamic> categories = [];

  void loadVars() async {
    MerchantHome.categoriess = await ResellerHomeApi().getCategories();
    List<dynamic> adLists = await ResellerHomeApi().getOffers();
    String token = await FirebaseService().getToken();

    print("token $token");

    setState(() {
      categories = MerchantHome.categoriess;
      adList = adLists;
      loading = false;
    });
  }

  void init() async {
    var isAuth = await Methods().isAuthenticated();
    if (!isAuth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NotRegisteredDialogMethod().check(context);
      });
    }
  }

  void awesomeNotifications() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Deny",
                  style: textStyle1(15, Colors.grey, FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {
                  AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context));
                },
                child: Text(
                  'Allow',
                  style: textStyle1(15, Color(0xFF811111), FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    });

    AwesomeNotifications().createdStream.listen((event) {
      print("awsm notif create event $event");
    });

    AwesomeNotifications().actionStream.listen((event) {
      print('awsm notif action event $event');
      print(event.toMap().toString());
      Navigator.pushNamed(context, '/merchant_orders');
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
    awesomeNotifications();
    init();
  }

  @override
  Widget build(BuildContext context) {
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
                child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      //////////////////////////////
                      ///                        ///
                      ///   Categories Section   ///
                      ///                        ///
                      //////////////////////////////

                      loading
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF5B0D1B),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : HorizontalListView("CATEGORIES", categories),

                      SizedBox(height: 10),
                      // ElevatedButton(
                      //     onPressed: () =>
                      //         Navigator.of(context).pushNamed('/temp'),
                      //     child: Text("Temp")),

                      SizedBox(height: 20),

                      // TopSelling(),

                      AllProducts(),
                    ]),
                  ),
                  SliverFillRemaining(hasScrollBody: false, child: Container()),
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
        // bottomNavigationBar: Footer(),
      ),
    );
  }
}
