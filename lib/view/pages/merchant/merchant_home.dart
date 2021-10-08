import 'package:flutter/material.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:silkroute/methods/showdailog.dart';
import 'package:silkroute/widget2/footer.dart';
import 'package:silkroute/view/widget/horizontal_list_view.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

class MerchantHome extends StatefulWidget {
  @override
  _MerchantHomeState createState() => _MerchantHomeState();
}

class _MerchantHomeState extends State<MerchantHome> {
  void initState() {
    if (!Methods().isAuthenticated()) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => NotRegisteredDialogMethod().check(context));
    }
    super.initState();
  }

  List<String> adList = [
    'https://codecanyon.img.customer.envatousercontent.com/files/201787761/banner%20intro.jpg?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=70a1c7c1e090863e2ea624db76295a0f',
    'https://mk0adespressoj4m2p68.kinstacdn.com/wp-content/uploads/2019/07/facebook-offer-ads.jpg',
    'https://assets.keap.com/image/upload/v1547580346/Blog%20thumbnail%20images/Screen_Shot_2019-01-15_at_12.25.23_PM.png',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuX7EvcOkWOCYRFGR78Dxa2oNQb2OPCI7uqg&usqp=CAU'
  ];

  List<Map<String, String>> products = [
    {
      "title": "Saree",
      "url":
          'https://codecanyon.img.customer.envatousercontent.com/files/201787761/banner%20intro.jpg?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=70a1c7c1e090863e2ea624db76295a0f',
    },
    {
      "title": "Bridal",
      "url":
          'https://mk0adespressoj4m2p68.kinstacdn.com/wp-content/uploads/2019/07/facebook-offer-ads.jpg',
    },
    {
      "title": "Suits",
      "url":
          'https://assets.keap.com/image/upload/v1547580346/Blog%20thumbnail%20images/Screen_Shot_2019-01-15_at_12.25.23_PM.png',
    },
    {
      "title": "Shawl",
      "url":
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuX7EvcOkWOCYRFGR78Dxa2oNQb2OPCI7uqg&usqp=CAU'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
      child: Scaffold(
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

                      HorizontalListView("CATEGORIES", products),

                      SizedBox(height: 20),
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
