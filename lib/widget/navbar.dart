import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool isAuth;
  Icon log;
  String nextRoute;
  String name;
  LocalStorage storage = LocalStorage('silkroute');

  var navBarList = [
    {"name": "Profile", "url": "/dashboard"},
    {"name": "Orders", "url": "/orders"},
    {"name": "FAQs", "url": "/faqs"},
    {"name": "Contact Us", "url": "/contact_us"},
    {"name": "Change Language", "url": "/"}
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      name = storage.getItem('name');
    });
    isAuth = Methods().isAuthenticated();
    log = isAuth ? Icon(Icons.logout) : Icon(Icons.login);
    nextRoute = isAuth ? "/localization_page" : "/enter_contact";
  }

  @override
  Widget build(BuildContext context) {
    double fw = MediaQuery.of(context).size.width;
    double fh = MediaQuery.of(context).size.height;
    print("UT - ${storage.getItem('userType')}");
    return Drawer(
      elevation: 5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.12,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Image.network(
                          'https://static.thenounproject.com/png/3237155-200.png',
                          height: MediaQuery.of(context).size.height * 0.12,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                (name == null) ? "name" : name.split(" ")[0],
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            GestureDetector(
                              onTap: () => {
                                Methods().logout(context),
                                Navigator.of(context)
                                    .pushNamed('/localization_page'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 5),
                      Text(
                        "LEVEL: ",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                        ),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.black87,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.black54,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.black54,
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
                itemCount: navBarList.length,
                itemBuilder: (context, index) {
                  Color brc =
                      index % 2 == 1 ? Color(0xFFDCD7D7) : Color(0xFFFFFFFF);
                  Color bgc =
                      index % 2 == 0 ? Color(0xFFEFE9E1) : Color(0xFFFFFFFF);
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(navBarList[index]["url"]);
                    },
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
                          fw * 0.1, fh * 0.025, 0, fh * 0.025),
                      child: Text(navBarList[index]["name"]),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
