import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:silkroute/methods/registerredirect.dart';
import 'package:silkroute/widget/profile_pic_picker.dart';
import 'package:localstorage/localstorage.dart';

import 'package:silkroute/services/authservice.dart';
import 'package:silkroute/widget/dropdown.dart';
import 'package:silkroute/widget/liscenseAndAgreements.dart';

import 'package:silkroute/widget/text_field.dart';
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
    "anotherNumber": "",
    "contact": "",
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
    reqFields = ["name", "currAdd", "contact", "userType"];
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

  @override
  void initState() {
    super.initState();
    setState(() {
      contact = storage.getItem('contact');
      data["contact"] = contact;
    });
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
      Fluttertoast.showToast(
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
      if (storage.getItem('contact') != null) {
        storage.deleteItem('contact');
      }

      if (res == false) {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("/enter_contact");
      } else {
        storage.setItem('contact', data['contact']);
        storage.setItem('isregistered', true);
        storage.setItem('name', data['name']);
        storage.setItem('userType', data['userType']);

        String nextpage =
            (userType == "Reseller") ? "/reseller_home" : "/manufacturer_home";

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
      return Colors.teal;
    }

    return new Scaffold(
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
                  (AppLocalizations.of(context).name + "*")
                      .toString(), // labeltext
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
                  (AppLocalizations.of(context).currAdd + "*").toString(), "",
                  false, // isPassword
                  (val) {
                    data["currAdd"] = val;
                  },
                ),

                new SizedBox(
                  height: 30.0,
                ),

                CustomTextField(
                  (AppLocalizations.of(context).anotherNumber), "",
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
                      (val) {
                        setState(() {
                          data["userType"] = val;
                        });
                      },
                      userType,
                    ),
                    new SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),

                // Terms and Conditions

                Agreements(
                    agreementCheck, agreementCheckFunction, checkboxColor),

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
                          Colors.teal,
                          Colors.teal[200],
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
