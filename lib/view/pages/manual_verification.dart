import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/model/services/authservice.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/custom_network_image.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

class ManualVerification extends StatefulWidget {
  @override
  _ManualVerificationState createState() => _ManualVerificationState();
}

class _ManualVerificationState extends State<ManualVerification> {
  bool verified = false, loading = true;
  LocalStorage storage = LocalStorage('silkroute');
  void checkVerificationStatus() async {
    setState(() {
      loading = true;
    });

    bool flag = await AuthService().checkVerificationStatus();

    setState(() {
      verified = flag;
      loading = false;
    });

    if (verified == true) {
      String ut = await storage.getItem('userType');
      String nextpage =
          (ut == "Reseller") ? "/reseller_home" : "/merchant_acc_details";
      // Navigator.of(context).pop();
      Navigator.of(context).popAndPushNamed(nextpage);
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    checkVerificationStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // checkVerificationStatus();
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
                        loading
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                margin: EdgeInsets.fromLTRB(
                                    0,
                                    MediaQuery.of(context).size.height * 0.2,
                                    0,
                                    0),
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
                            : Container(
                                // color: Colors.yellow,
                                height:
                                    MediaQuery.of(context).size.height * 0.75,

                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 1),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Verification Pending",
                                          style: textStyle(22, Colors.black),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "We will contact you shortly on whatsapp",
                                          style: textStyle1(15, Colors.black45,
                                              FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Follow us and stay tuned!",
                                          style: textStyle1(15, Colors.black45,
                                              FontWeight.w500),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.59,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () async {
                                                  const url =
                                                      'https://wa.me/+917007135430';
                                                  Helpers()
                                                      .launchURLBrowser(url);
                                                },
                                                child: CustomNetworkImage(
                                                  url:
                                                      "https://github.com/yibrance/yibrance.github.io/blob/master/assets/images/whatsapp.png?raw=true",
                                                  height: 70,
                                                  width: 70,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  const url =
                                                      "https://www.instagram.com/yibrance";
                                                  Helpers()
                                                      .launchURLBrowser(url);
                                                },
                                                child: CustomNetworkImage(
                                                  url:
                                                      "https://github.com/yibrance/yibrance.github.io/blob/master/assets/images/contact_insta.png?raw=true",
                                                  height: 80,
                                                  width: 80,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  const url =
                                                      "https://www.facebook.com/yibrance";
                                                  Helpers()
                                                      .launchURLBrowser(url);
                                                },
                                                child: CustomNetworkImage(
                                                  url:
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
