import 'package:flutter/material.dart';
import 'package:silkroute/model/services/authservice.dart';
import 'package:silkroute/view/widget/next_page_button.dart';
import 'package:silkroute/view/widget/text_field.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/view/widget/top_banner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtpVerificationPage extends StatefulWidget {
  OtpVerificationPageState createState() => OtpVerificationPageState();
}

class OtpVerificationPageState extends State<OtpVerificationPage> {
  LocalStorage storage = new LocalStorage('silkroute');

  String token;
  @override
  void initState() {
    super.initState();
    // token =
    // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI2MGJhNjkyODIyYTE0MzNhZTQ4MWM4NDAiLCJjb250YWN0IjoiKzkxNzQwODE1OTg5OCIsIm5hbWUiOiJhYmNkIiwicmVnaXN0ZXJlZCI6ZmFsc2UsIl9fdiI6MCwib3RwIjoiNTE4OTY2NjcifQ.P_M-6v2VcZe5Vw-eui6E8CRguzMtanCZtUPxUCAoOys";
    token = storage.getItem('token');
  }

  String userOtp, nextpage;
  bool navigate = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          child: new Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // OTP Textfield
              TopBanner(
                  AppLocalizations.of(context).verification, "description"),

              SizedBox(height: 50),

              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                child: new Theme(
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
                      labelText: AppLocalizations.of(context).otp,
                      prefixStyle: new TextStyle(
                        color: Colors.black,
                      ),
                      hintText: AppLocalizations.of(context).enterOtp,
                    ),
                    onChanged: (value) {
                      setState(() {
                        userOtp = value;
                      });
                    },
                  ),
                ),
              ),

              SizedBox(height: 40),

              // Next page and verification button

              new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    AppLocalizations.of(context).verifyOTP,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                onPressed: () async {
                  String contact, name, userType;
                  List<String> list;
                  print("In Otp -- Token is $token");

                  await AuthService().verifyotp(userOtp, token).then(
                        (res) => {
                          list = res.split("-"),
                          print("\n--->\n $res\n"),
                          res = list[0],
                          contact = res.substring(2, 12),
                          print(
                              "Otp result --- $res $contact ${res.substring(12)}"),
                          if (res[0] == '1')
                            {
                              storage.clear(),
                              storage.setItem('contact', contact),
                              if (res[1] == '1')
                                {
                                  userType = list[1],
                                  print("\n--->\n $userType\n"),
                                  name = res.substring(12),
                                  userType = userType,
                                  storage.setItem('name', name),
                                  storage.setItem('userType', userType),
                                  nextpage = (userType == "Reseller")
                                      ? "/reseller_home"
                                      : "/manufacturer_home",
                                }
                              else
                                {nextpage = "/register_detail"},
                              navigate = true
                            }
                        },
                      );

                  navigate ? Navigator.of(context).pushNamed(nextpage) : null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
