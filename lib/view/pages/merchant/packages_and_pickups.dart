import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/merchant/packages.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/my_circular_progress.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

class PackagesAndPickups extends StatefulWidget {
  const PackagesAndPickups({Key key}) : super(key: key);

  @override
  _PackagesAndPickupsState createState() => _PackagesAndPickupsState();
}

class _PackagesAndPickupsState extends State<PackagesAndPickups> {
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
                    ? MyCircularProgress(marginTop: 50)
                    : CustomScrollView(slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
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
                                      primary: (page == 0)
                                          ? Color(0xFFF0E7DA)
                                          : Colors.white,
                                      side: BorderSide(
                                        width: 2,
                                        color: Color(0xFF811111),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                    ),
                                    child: Text(
                                      "Packages",
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
                                      primary: (page == 1)
                                          ? Color(0xFFF0E7DA)
                                          : Colors.white,
                                      side: BorderSide(
                                        width: 2,
                                        color: Color(0xFF811111),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: Text(
                                      "Pickups",
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
                              height: MediaQuery.of(context).size.height * 0.67,
                              child: PageView(
                                controller: pageController,
                                children: [
                                  Packages(),
                                  Packages(),
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
