import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/methods/registerredirect.dart';
import 'package:silkroute/model/services/ExtraApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
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
  bool whatsapp = false;
  LocalStorage storage = LocalStorage('silkroute');
  String contact, userType = "Wholesale Buyer";

  Widget nullContact;

  Map<String, dynamic> data = {
    "name": "",
    "currAdd": {"address": "", "city": "", "state": "", "pincode": ""},
    "businessName": "",
    "anotherNumber": "",
    "contact": "",
    "gst": "",
    "adhaar": "",
    "pan": "",
    "userType": "Wholesale Buyer"
  };

  String street = "", city = "", pincode = "", state = "";

  List<String> reqFields;

  ////   SOME METHODS //////////

  bool validForm() {
    print("1");
    if (contact == null) {
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
    reqFields = [
      "name",
      "street",
      "city",
      "pincode",
      "state",
      "contact",
      "userType",
      "gst",
      "adhaar",
      "pan",
      "businessName"
    ];

    data["currAdd"] = {
      "address": street + ", " + city + ", " + state + ", " + pincode,
      "city": city,
      "state": state,
      "pincode": pincode,
      "country": "India"
    };

    for (String x in reqFields) {
      print("$x - ${data[x].toString()}");
      if ((data[x].toString()).length == 0) {
        return false;
      }
    }

    return (agreementCheck == true) && (whatsapp);
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
      data["userType"] = "Wholesale Buyer";
      if (businessName != null) data["businessName"] = businessName;
      if (currAdd != null) data["currAdd"] = currAdd;
      if (gst != null) data["gst"] = gst;
      if (anotherNumber != null) data["anotherNumber"] = anotherNumber;
      loading = false;
    });
  }

  List<String> states = [], cities = ["Select a State"];
  dynamic statesData;

  void getStatesData() async {
    var data = await ExtraApi().getStatesData();
    setState(() {
      statesData = data;

      cities = [];
      states = [];
      for (var x in statesData["states"]) {
        states.add(x.toString());
      }
    });
  }

  Future<List<String>> getStates(String cs) async {
    if (states.length == 0) {
      await getStatesData();
    }
    return states;
  }

  Future<List<String>> getCities(String cc) async {
    if (state.length == 0) {
      return ["Select a state"];
    }
    print(statesData["stateCity"][state]);
    cities = [];
    for (var x in statesData["stateCity"][state]) {
      cities.add(x.toString());
    }
    print("$cities");
    return cities;
  }

  @override
  void initState() {
    super.initState();
    getContact();
    // getStatesData();
  }

  void agreementCheckFunction(bool agreementCheckCurrent) {
    setState(() {
      agreementCheck = !agreementCheck;
    });
  }

  void whatsappFunction(bool agreementCheckCurrent) {
    setState(() {
      whatsapp = !whatsapp;
    });
  }

  void navigatorFuntion() async {
    if (!validForm()) {
      Fluttertoast.showToast(
        msg: "Invalid Form",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 13,
      );
      return;
    }
    print("\nRD--\n$data\n");
    var nextpage = "/enter_contact";
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
    } else {
      if (data["userType"] == "Wholesale Buyer") data["userType"] = "Reseller";
      data["whatsappNotifications"] = whatsapp;
      nextpage = "/register_detail";
      res = await AuthService().register(data);
      if (await storage.getItem('contact') != null) {
        await storage.deleteItem('contact');
      }

      if (res == true) {
        await storage.setItem('contact', data['contact']);
        await storage.setItem('isregistered', true);
        await storage.setItem('name', data['name']);
        await storage.setItem('businessName', data['businessName']);
        await storage.setItem('userType', data['userType']);
        // await storage.setItem('gst', data['gst']);

        // String nextpage = "/enter_contact";

        // print("object $nextpage");

        // Navigator.of(context).pop();

        // Navigator.of(context).pushNamed(nextpage);
        nextpage = "/manual_verification";
      }
    }
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(nextpage);
  }

  InputDecoration dropdownDecoration = InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20, 0, 10, 0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        width: 1,
        color: Colors.black45,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        width: 1,
        color: Colors.black45,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        width: 1,
        color: Colors.black12,
      ),
    ),
  );

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
      return Color(0xFF811111);
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
                    color: Color(0xff811111),
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

                      // new SizedBox(
                      //   height: 20.0,
                      // ),

                      // CustomTextField(
                      //   ("Adhaar*").toString(), // labeltext
                      //   "", // hinttext
                      //   false, // isPassword
                      //   (val) {
                      //     check();
                      //     // onChnaged
                      //     data["adhaar"] = val;
                      //   },
                      // ),

                      // new SizedBox(
                      //   height: 20.0,
                      // ),

                      // CustomTextField(
                      //   ("PAN*").toString(), // labeltext
                      //   "", // hinttext
                      //   false, // isPassword
                      //   (val) {
                      //     check();
                      //     // onChnaged
                      //     data["pan"] = val;
                      //   },
                      // ),

                      new SizedBox(
                        height: 10.0,
                      ),

                      CustomTextField(
                        ("Legal Name of business*").toString(), // labeltext
                        "", // hinttext
                        false, // isPassword
                        (val) {
                          check();
                          // onChnaged
                          setState(() {
                            data["businessName"] = val;
                          });
                        },
                      ),

                      new SizedBox(
                        height: 10.0,
                      ),

                      ///// GST ////////

                      CustomTextField(
                        "GSTIN/Aadhaar*", "",
                        false, // isPassword
                        (val) {
                          setState(() {
                            data["gst"] = val;
                            data["adhaar"] = val;
                            data["pan"] = val;
                          });
                        },
                      ),

                      new SizedBox(
                        height: 20.0,
                      ),

                      /////////////////////////////////////////////////////////

                      // Business Address

                      ///print newly selected country state and city in Text Widget

                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Business Address",
                          style: textStyle1(15, Colors.black, FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 10),

                      DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItems: true,
                        items: states,
                        // searchDelay: Duration(milliseconds: 200),
                        // showClearButton: true,
                        dropDownButton: Icon(Icons.arrow_downward),
                        // showSearchBox: true,
                        // selectedItem: states[0],

                        selectionListViewProps: SelectionListViewProps(
                          padding: EdgeInsets.symmetric(vertical: 0),
                        ),

                        dropdownBuilderSupportsNullItem: true,
                        dropdownSearchDecoration: dropdownDecoration,
                        label: "State",
                        onChanged: (value) async {
                          print(value);
                          setState(() {
                            if (value == null) {
                              value = "";
                            }
                            state = value;
                            city = "";
                            if (state == null) {
                              cities = [];
                              cities = ["Select a state"];
                            } else if (state.length == 0) {
                              cities = [];
                              cities = ["Select a state"];
                            } else {
                              cities = [];
                              for (var x in statesData["stateCity"][state]) {
                                cities.add(x.toString());
                              }
                            }
                          });
                        },
                        onFind: (String filter) => getStates(filter),
                        // showClearButton: true,
                      ),

                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: true,
                              items: cities,
                              enabled: (state == null)
                                  ? false
                                  : ((state.length == 0) ? false : true),
                              // searchDelay: Duration(milliseconds: 200),
                              // showClearButton: true,
                              dropDownButton: Icon(
                                Icons.arrow_downward,
                                color: (state == null)
                                    ? Colors.black12
                                    : ((state.length == 0)
                                        ? Colors.black12
                                        : Colors.black54),
                              ),
                              // showSearchBox: true,
                              // selectedItem: states[0],

                              selectionListViewProps: SelectionListViewProps(
                                padding: EdgeInsets.symmetric(vertical: 0),
                              ),

                              dropdownBuilderSupportsNullItem: true,
                              dropdownSearchDecoration: dropdownDecoration,
                              label: "District",
                              onChanged: (value) {
                                if (value == null) {
                                  value = "";
                                }
                                setState(() {
                                  city = value;
                                });
                              },
                              onFind: (String filter) => getCities(filter),
                              // showClearButton: true,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: CustomTextField(
                              "Pincode*", "",
                              false, // isPassword
                              (val) {
                                setState(() {
                                  pincode = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      CustomTextField(
                        "Street*", "",
                        false, // isPassword
                        (val) {
                          setState(() {
                            street = val;
                          });
                        },
                      ),

                      new SizedBox(
                        height: 20.0,
                      ),

                      // CustomTextField(
                      //   "Another Number", "",
                      //   false, // isPassword
                      //   (val) {
                      //     setState(() {
                      //       data["anotherNumber"] = val;
                      //     });
                      //   },
                      // ),

                      // new SizedBox(
                      //   height: 20.0,
                      // ),

                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Text("You are "),
                            SizedBox(width: 7),
                            Dropdown(
                              ["Wholesale Buyer", "Manufacturer"],
                              (val) async {
                                setState(() {
                                  data["userType"] = val;
                                });
                              },
                              data["userType"],
                            ),
                          ],
                        ),
                      ),

                      // Terms and Conditions

                      Container(
                        height: 100,
                        child: Column(
                          children: <Widget>[
                            Agreements(
                              agreementCheck,
                              agreementCheckFunction,
                              checkboxColor,
                              dialogFn: true,
                              userType: data['userType'],
                            ),
                            Transform.translate(
                              offset: Offset(0, -15),
                              child: Agreements(
                                whatsapp,
                                whatsappFunction,
                                checkboxColor,
                                title: "Get updates on Whatsapp",
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Agreements(agreementCheck,
                      //         agreementCheckFunction, checkboxColor),

                      // navigator

                      // new Align(
                      //   alignment: Alignment.topRight,
                      //   child: new Container(
                      //     width: 70,
                      //     height: 70,
                      //     margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.all(Radius.circular(70)),
                      //       gradient: LinearGradient(
                      //         begin: Alignment.topCenter,
                      //         end: Alignment.bottomCenter,
                      //         colors: [
                      //           Color(0xFF530000),
                      //           Color.fromRGBO(129, 20, 20, 1),
                      //         ],
                      //       ),
                      //     ),
                      //     child: new IconButton(
                      //       icon: Icon(
                      //         Icons.keyboard_arrow_right,
                      //         color: Colors.white,
                      //       ),
                      //       iconSize: 40.0,
                      //       onPressed: (validForm()) ? navigatorFuntion : null,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
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
                  onPressed: navigatorFuntion,
                ),
              ),
            ),
          );
  }
}
