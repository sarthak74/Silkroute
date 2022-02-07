import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/registerredirect.dart';
import 'package:silkroute/model/services/authservice.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/liscenseAndAgreements.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/text_field.dart';
import 'package:silkroute/view/widget/topbar.dart';

class MechantAccountDetails extends StatefulWidget {
  @override
  _MechantAccountDetailsState createState() => _MechantAccountDetailsState();
}

class _MechantAccountDetailsState extends State<MechantAccountDetails> {
  String contact, businessAdd = "";
  dynamic data = {
        "bankAccountNo": "",
        "ifsc": "",
        "pickupAdd": "",
        "accountHolderName": "",
        "email": ""
      },
      user;
  bool loading = true, agreementCheck = false;
  LocalStorage storage = LocalStorage('silkroute');

  TextEditingController pickupController = new TextEditingController();

  List<String> reqFields = [
    "bankAccountNo",
    "ifsc",
    "pickupAdd",
    "accountHolderName",
    "email"
  ];

  ////   SOME METHODS //////////

  bool validForm() {
    print("validating");
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

    print("validation: $agreementCheck");
    return true;
  }

  void check() {
    if (contact == null) {
      Methods().redirectToRegister(contact, context);
      return;
    }
  }

  void loadVars() async {
    user = await storage.getItem('user');
    var ct = user["contact"];
    if (ct == null) {
      contact = null;
      check();
      return;
    }
    for (var x in reqFields) {
      if (user[x] == null) {
        continue;
      }
      if (user[x].length == 0) {
        continue;
      }
      data[x] = user[x];
    }
    print("user: $user");
    businessAdd = (user["currAdd"]["address"] ?? '');
    setState(() {
      pickupController.text = user['pickupAdd'] ?? '';
      data['pickupAdd'] = user['pickupAdd'] ?? '';
    });
    print("${user['pickupAdd']}\n${pickupController.text}");

    setState(() {
      contact = ct;
      loading = false;
    });
  }

  void agreementCheckFunction(bool agreementCheckCurrent) {
    setState(() {
      agreementCheck = !agreementCheck;
    });
  }

  void navigatorFuntion() async {
    print("\nRD--\n$data\n");

    if (contact == null) {
      await Fluttertoast.showToast(
        msg: "Verify your Contact in previous step",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red[800],
        fontSize: 10,
      );
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed("/enter_contact");
    } else {
      var res = await AuthService().updateUser(contact, data);

      // add fund account in razorpay

      print("res: $res");
      if (res != null) {
        // var user = await storage.getItem('user');
        await storage.deleteItem('user');
        // user["verified"] = true;
        await storage.setItem('user', res);
        Navigator.of(context).pop();
        Navigator.of(context)
            .pushNamed("/merchant_home"); // todo: merchant_home
      } else {
        await Fluttertoast.showToast(
          msg:
              "Please try again after sometime, if problem persists, contact the owner",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[100],
          textColor: Colors.red[800],
          fontSize: 10,
        );
      }
    }
  }

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

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
      child: Scaffold(
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
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    color: Colors.white,
                  ),
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
                                    0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                              : SingleChildScrollView(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 20),
                                              CustomTextField(
                                                "Email",
                                                "Email",
                                                false,
                                                (val) async {
                                                  setState(() {
                                                    data["email"] = val;
                                                  });
                                                },
                                                initialValue: data["email"],
                                              ),
                                              SizedBox(height: 20),
                                              CustomTextField(
                                                "Account Number",
                                                "Account Number",
                                                false,
                                                (val) async {
                                                  setState(() {
                                                    data["bankAccountNo"] = val;
                                                  });
                                                },
                                                initialValue:
                                                    data["bankAccountNo"],
                                              ),
                                              SizedBox(height: 20),
                                              CustomTextField(
                                                "IFSC Code",
                                                "IFSC Code",
                                                false,
                                                (val) async {
                                                  setState(() {
                                                    data["ifsc"] = val;
                                                  });
                                                },
                                                initialValue: data["ifsc"],
                                              ),
                                              SizedBox(height: 20),
                                              CustomTextField(
                                                "Account Holder Name",
                                                "Account Holder",
                                                false,
                                                (val) async {
                                                  setState(() {
                                                    data["accountHolderName"] =
                                                        val;
                                                  });
                                                },
                                                initialValue:
                                                    data["accountHolderName"],
                                              ),
                                              SizedBox(height: 20),

                                              ///// PICKUPP ADDRESS

                                              new Theme(
                                                data: new ThemeData(
                                                  primaryColor: Colors.black87,
                                                ),
                                                child: new TextFormField(
                                                  obscureText: false,
                                                  onChanged: (val) async {
                                                    setState(() {
                                                      data["pickupAdd"] =
                                                          pickupController.text;
                                                    });
                                                  },
                                                  decoration:
                                                      new InputDecoration(
                                                    isDense: true,
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30)),
                                                    ),
                                                    contentPadding:
                                                        new EdgeInsets
                                                            .symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10,
                                                    ),
                                                    labelText: "Pickup Address",
                                                    labelStyle: textStyle1(
                                                        13,
                                                        Colors.black54,
                                                        FontWeight.w500),
                                                    prefixStyle: textStyle1(
                                                        13,
                                                        Colors.black,
                                                        FontWeight.w500),
                                                    hintStyle: textStyle1(
                                                        13,
                                                        Colors.black45,
                                                        FontWeight.w500),
                                                    hintText: "Pickup Address",
                                                  ),
                                                  controller: pickupController,
                                                ),
                                              ),

                                              SizedBox(height: 10),

                                              GestureDetector(
                                                onTap: () async {
                                                  // print("clicked");
                                                  setState(() {
                                                    pickupController.text =
                                                        businessAdd;
                                                    data["pickupAdd"] =
                                                        businessAdd;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF5B0D1B),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  padding: EdgeInsets.fromLTRB(
                                                      20, 5, 20, 5),
                                                  child: Text(
                                                    "Same as business Address?",
                                                    style: textStyle1(
                                                      14,
                                                      Colors.white,
                                                      FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: 20),
                                            ],
                                          ),
                                        ),

                                        // navigator

                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            "/merchant_home");
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 5, 20, 5),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      "Skip",
                                                      style: textStyle(
                                                          13, Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                new Container(
                                                  width: 70,
                                                  height: 70,
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                70)),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Color(0xFF530000),
                                                        Color.fromRGBO(
                                                            129, 20, 20, 1),
                                                      ],
                                                    ),
                                                  ),
                                                  child: new IconButton(
                                                    icon: Icon(
                                                      Icons
                                                          .keyboard_arrow_right,
                                                      color: Colors.white,
                                                    ),
                                                    iconSize: 40.0,
                                                    onPressed: () async {
                                                      if (await validForm())
                                                        await navigatorFuntion();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(
                                        //     bottom: MediaQuery.of(context)
                                        //         .viewInsets
                                        //         .bottom,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                        ]),
                      ),
                      SliverFillRemaining(
                          hasScrollBody: false, child: Container()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
