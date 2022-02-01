import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/view/widget/profile_pic_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool isAuth, loading = true;
  Icon log;
  String nextRoute;
  dynamic user;
  String name;
  String userType;
  String contact;
  LocalStorage storage = LocalStorage('silkroute');

  dynamic navBarList;

  openwhatsapp() async {
    var whatsapp = "+917007135430";
    var whatsappURl_android = "whatsapp://send?phone=" + whatsapp + "&text=";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  void loadVars() async {
    user = await Methods().getUser();
    setState(() {
      isAuth = user != null;
      userType = user["userType"];
      name = user["name"];

      log = isAuth ? Icon(Icons.logout) : Icon(Icons.login);
      nextRoute = isAuth
          ? ((userType == "Reseller") ? "/reseller_home" : "/merchant_home")
          : "/enter_contact";

      var profileUrl =
          (userType == "Reseller") ? "/reseller_profile" : "/merchant_profile";
      var orderUrl = (userType == "Reseller") ? "/orders" : "/merchant_orders";
      navBarList = [
        {
          "name": "Profile",
          "url": () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(profileUrl);
          }
        },
        {
          "name": "Orders",
          "url": () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(orderUrl);
          }
        },
        {"name": "FAQs", "url": openwhatsapp},
        {"name": "Contact Us", "url": openwhatsapp}
      ];

      if (userType == "Manufacturer") {
        navBarList.add({
          "name": "Packages",
          "url": () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed("/merchant_packages");
          }
        });
      }

      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    // double fw = MediaQuery.of(context).size.width;
    // double fh = MediaQuery.of(context).size.height;
    return Drawer(
      elevation: 5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.12,
              child: loading
                  ? Text("Loading")
                  : Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ProfilePic(contact),
                            Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      (name == null)
                                          ? "User"
                                          : name.split(" ")[0],
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () async {
                                      await Methods().logout(context);
                                    },
                                    child: Text(
                                      "Log Out",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            // decoration: BoxDecoration(
            //   color: Colors.grey,
            //   image: DecorationImage(
            //     fit: BoxFit.none,
            //     image: NetworkImage(
            //       'https://static.thenounproject.com/png/3237155-200.png',
            //     ),
            //   ),
            // ),
          ),
          loading
              ? Text("Loading")
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                    itemCount: navBarList.length,
                    itemBuilder: (context, index) {
                      Color brc = index % 2 == 1
                          ? Color(0xFFDCD7D7)
                          : Color(0xFFFFFFFF);
                      Color bgc = index % 2 == 0
                          ? Color(0xFFEFE9E1)
                          : Color(0xFFFFFFFF);
                      return GestureDetector(
                        onTap: navBarList[index]["url"],
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                            border: Border.all(
                              color: brc,
                              width: 3,
                            ),
                            color: bgc,
                          ),
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.1,
                              MediaQuery.of(context).size.height * 0.025,
                              0,
                              MediaQuery.of(context).size.height * 0.025),
                          child: Text(navBarList[index]["name"]),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
