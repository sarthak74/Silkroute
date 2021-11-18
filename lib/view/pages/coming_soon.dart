import 'package:flutter/material.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

class ComingSoon extends StatefulWidget {
  @override
  _ComingSoonState createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
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
                        Container(
                          // color: Colors.yellow,
                          height: MediaQuery.of(context).size.height * 0.75,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 1),
                              Text(
                                "Coming Soon",
                                style: textStyle(25, Colors.black),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Follow us and stay tuned!",
                                    style: textStyle1(
                                        15, Colors.black45, FontWeight.w500),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.59,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () async {
                                            const url =
                                                'https://wa.me/+917007135430';
                                            Helpers().launchURLBrowser(url);
                                          },
                                          child: Image.network(
                                            "https://github.com/yibrance/yibrance.github.io/blob/master/assets/images/whatsapp.png?raw=true",
                                            height: 70,
                                            width: 70,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            const url =
                                                "https://www.instagram.com/yibrance";
                                            Helpers().launchURLBrowser(url);
                                          },
                                          child: Image.network(
                                            "https://github.com/yibrance/yibrance.github.io/blob/master/assets/images/contact_insta.png?raw=true",
                                            height: 80,
                                            width: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            const url =
                                                "https://www.facebook.com/yibrance";
                                            Helpers().launchURLBrowser(url);
                                          },
                                          child: Image.network(
                                            "https://github.com/yibrance/yibrance.github.io/blob/master/assets/images/contact_fb.png?raw=true",
                                            height: 70,
                                            width: 70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
