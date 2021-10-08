import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:silkroute/view/widget/top_banner.dart';
import 'package:silkroute/model/services/authservice.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnterContactPage extends StatefulWidget {
  EnterContactState createState() => new EnterContactState();
}

class EnterContactState extends State<EnterContactPage> {
  bool sending = false;

  LocalStorage storage = new LocalStorage('silkroute');

  navigatorFunction() async {
    setState(() {
      sending = true;
    });

    String token, to;
    var res;

    res = await AuthService().auth(contact);
    // token = (str.split('"')[11]).toString(),

    if (res[0]) {
      token = res[1];

      storage.setItem('token', token);
      to = storage.getItem('token');

      Navigator.of(context).pushNamed("/otp_verification");
    }

    setState(() {
      sending = false;
    });
  }

  String contact = "", indicatorText = "";

  bool disabled = true;

  Color indicatorColor = Color(0xFF9E9E9E);

  @override
  void initState() {
    storage.clear();
    super.initState();

    storage.clear();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            TopBanner(
              AppLocalizations.of(context).createAFreeAccount,
              // "CreateAFreeAccount",
              // "Create account by filling details below",
              AppLocalizations.of(context).createAccountByFillingDetailsBelow,
              // Language().getString("Create account by filling details below"),
            ),
            new Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      height: 50.0,
                    ),

                    // Contact Field

                    new Theme(
                      data: new ThemeData(
                        primaryColor: Colors.black87,
                      ),
                      child: new TextField(
                        obscureText: false,
                        decoration: new InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          contentPadding: new EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          labelText: AppLocalizations.of(context).contact,
                          prefixStyle: new TextStyle(
                            color: Colors.black,
                          ),
                          prefixText: "+91 ",
                          hintText: AppLocalizations.of(context).phoneNumber,
                        ),
                        onChanged: (value) {
                          setState(() {
                            contact = value;
                            RegExp exp = RegExp(r'^[0-9]+$');
                            int len = contact.length;

                            if (len == 0) {
                              indicatorText =
                                  AppLocalizations.of(context).enterYourContact;

                              disabled = true;
                              indicatorColor = Colors.grey;
                            } else if (len != 10) {
                              indicatorText =
                                  AppLocalizations.of(context).invalidContact;

                              disabled = true;
                              indicatorColor = Colors.red;
                            } else if (len == 10 && !exp.hasMatch(contact)) {
                              indicatorText =
                                  AppLocalizations.of(context).invalidContact;

                              disabled = true;
                            } else {
                              indicatorText = "";
                              disabled = false;
                              indicatorColor = Colors.black;
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        indicatorText,
                        style: TextStyle(
                          color: indicatorColor,
                        ),
                      ),
                    ),

                    new SizedBox(
                      height: 20,
                    ),

                    new ElevatedButton(
                      onPressed: disabled ? null : navigatorFunction,
                      style: ElevatedButton.styleFrom(
                        primary: sending ? Colors.grey : Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text(
                          AppLocalizations.of(context).getOtp,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
