import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:silkroute/methods/registerredirect.dart';
import 'package:silkroute/view/widget/profile_pic_picker.dart';
import 'package:localstorage/localstorage.dart';

import 'package:silkroute/model/services/authservice.dart';
import 'package:silkroute/view/widget/dropdown.dart';
import 'package:silkroute/view/widget/liscenseAndAgreements.dart';

import 'package:silkroute/view/widget/text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterDetailPage extends StatefulWidget {
  RegisterDetailPageState createState() => new RegisterDetailPageState();
}

class RegisterDetailPageState extends State<RegisterDetailPage> {
  bool agreementCheck = false;

  LocalStorage storage = LocalStorage('silkroute');
  String contact, userType = "Reseller";

  Widget nullContact;

  var data = {
    "name": "",
    "currAdd": "",
    "businessName": "",
    "anotherNumber": "",
    "contact": "",
    "gst": "",
    "userType": ""
  };

  List<String> reqFields;

  ////   SOME METHODS //////////

  bool validForm() {
    print("1");
    if (storage.getItem('contact') == null) {
      Fluttertoast.showToast(
        msg: "You have to register your number first",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red[800],
        fontSize: 10,
      );
      return false;
    }
    reqFields = ["name", "currAdd", "contact", "userType", "gst"];
    for (String x in reqFields) {
      print("$x - ${data[x].toString()}");
      if ((data[x].toString()).length == 0) {
        Fluttertoast.showToast(
          msg: "Invalid Form",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[100],
          textColor: Colors.red[800],
          fontSize: 10,
        );
        return false;
      }
    }

    if (agreementCheck == false) {
      Fluttertoast.showToast(
        msg: "Invalid Form",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red[800],
        fontSize: 10,
      );
    }
    return (agreementCheck == true);
  }

  void check() {
    if (contact == null) {
      Methods().redirectToRegister(contact, context);
    }
  }

  bool loading = true;

  void getContact() async {
    var contact1 = await storage.getItem('contact');
    var businessName = await storage.getItem('businessName');
    var currAdd = await storage.getItem('currAdd');
    var gst = await storage.getItem('gst');
    var anotherNumber = await storage.getItem('anotherNumber');
    setState(() {
      contact = contact1;
      data["contact"] = contact;
      data["userType"] = "Reseller";
      if (businessName != null) data["businessName"] = businessName;
      if (currAdd != null) data["currAdd"] = currAdd;
      if (gst != null) data["gst"] = gst;
      if (anotherNumber != null) data["anotherNumber"] = anotherNumber;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getContact();
  }

  void agreementCheckFunction(bool agreementCheckCurrent) {
    setState(() {
      agreementCheck = !agreementCheck;
    });
  }

  void navigatorFuntion() async {
    print("\nRD--\n$data\n");
    var res;
    if (contact == null) {
      await Fluttertoast.showToast(
        msg: "Verify your Contact in previous step",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red[800],
        fontSize: 10,
      );
      Navigator.of(context).pushNamed("/enter_contact");
    } else {
      res = await AuthService().register(data);
      if (await storage.getItem('contact') != null) {
        await storage.deleteItem('contact');
      }

      if (res == false) {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("/enter_contact");
      } else {
        await storage.setItem('contact', data['contact']);
        await storage.setItem('isregistered', true);
        await storage.setItem('name', data['name']);
        await storage.setItem('businessName', data['businessName']);
        await storage.setItem('userType', data['userType']);
        // await storage.setItem('gst', data['gst']);

        String nextpage = "/enter_contact";

        print("object $nextpage");

        Navigator.of(context).pop();

        Navigator.of(context).pushNamed(nextpage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color checkboxColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.black;
      }
      return Color(0xFF530000);
    }

    return loading
        ? Container(
            height: MediaQuery.of(context).size.height * 0.2,
            margin: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.height * 0.2, 0, 0),
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
        : new Scaffold(
            body: new SingleChildScrollView(
              child: new Container(
                margin: new EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: new Center(
                  child: new Column(
                    children: <Widget>[
                      // Navbar(),
                      new SizedBox(
                        height: 50,
                      ),

                      // Add Profile Picture
                      ProfilePic(contact),
                      new SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),

                      // Name of User

                      CustomTextField(
                        ("Name*").toString(), // labeltext
                        "", // hinttext
                        false, // isPassword
                        (val) {
                          check();
                          // onChnaged
                          data["name"] = val;
                        },
                      ),

                      new SizedBox(
                        height: 30.0,
                      ),

                      CustomTextField(
                        ("Legal Name of business*").toString(), // labeltext
                        "", // hinttext
                        false, // isPassword
                        (val) {
                          check();
                          // onChnaged
                          data["businessName"] = val;
                        },
                      ),

                      new SizedBox(
                        height: 30.0,
                      ),

                      CustomTextField(
                        "Business Address", "",
                        false, // isPassword
                        (val) {
                          data["currAdd"] = val;
                        },
                      ),

                      new SizedBox(
                        height: 30.0,
                      ),

                      CustomTextField(
                        "GSTIN", "",
                        false, // isPassword
                        (val) {
                          data["gst"] = val;
                        },
                      ),

                      new SizedBox(
                        height: 30.0,
                      ),

                      CustomTextField(
                        "Another Number", "",
                        false, // isPassword
                        (val) {
                          data["anotherNumber"] = val;
                        },
                      ),

                      new SizedBox(
                        height: 30.0,
                      ),

                      Row(
                        children: <Widget>[
                          Text("You are "),
                          SizedBox(width: 10),
                          Dropdown(
                            ["Reseller", "Manufacturer"],
                            (val) async {
                              setState(() {
                                data["userType"] = val;
                              });
                            },
                            data["userType"],
                          ),
                          new SizedBox(
                            height: 30.0,
                          ),
                        ],
                      ),

                      // Terms and Conditions

                      Agreements(agreementCheck, agreementCheckFunction,
                          checkboxColor),

                      // navigator

                      new Align(
                        alignment: Alignment.topRight,
                        child: new Container(
                          width: 70,
                          height: 70,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(70)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF530000),
                                Color.fromRGBO(129, 20, 20, 1),
                              ],
                            ),
                          ),
                          child: new IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                            ),
                            iconSize: 40.0,
                            onPressed: (validForm()) ? navigatorFuntion : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
