import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget2/footer.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

class AddNewPage extends StatefulWidget {
  @override
  _AddNewPageState createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
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
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.568),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.21),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF5B0D1B),
                                offset: Offset(0.0, 0.0), //(x,y)
                                blurRadius: 0.0,
                                spreadRadius: 3.0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed("/add_new_product_page");
                                },
                                child: Text(
                                  "New",
                                  style: textStyle(18, Color(0xFF5B0D1B)),
                                ),
                              ),
                              Divider(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                color: Color(0xFF5B0D1B),
                              ),
                              GestureDetector(
                                onTap: null,
                                child: Text(
                                  "Draft",
                                  style: textStyle(18, Color(0xFF5B0D1B)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    SliverFillRemaining(
                        hasScrollBody: false, child: Container()),
                  ],
                ),
              ),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
