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
    "accountHolderName": ""
  };
  bool loading = true, agreementCheck = false;
  LocalStorage storage = LocalStorage('silkroute');

  TextEditingController pickupController = new TextEditingController();

  List<String> reqFields;

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
    reqFields = ["bankAccountNo", "ifsc", "pickupAdd", "accountHolderName"];
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
        msg: "You have to accept terms and conditions",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[100],
        textColor: Colors.red[800],
        fontSize: 10,
      );
    }
    print("validation: $agreementCheck");
    return (agreementCheck == true);
  }

  void check() {
    if (contact == null) {
      Methods().redirectToRegister(contact, context);
      return;
    }
  }

  void loadVars() async {
    var user = await storage.getItem('user');
    var ct = user["contact"];
    businessAdd = user["currAdd"]["address"];
    if (ct == null) {
      contact = null;
      check();
      return;
    }
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
                                margin: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.05),
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CustomTextField(
                                      "Enter Account Number",
                                      "Account Number",
                                      false,
                                      (val) async {
                                        setState(() {
                                          data["bankAccountNo"] = val;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    CustomTextField(
                                      "Enter IFSC Code",
                                      "IFSC Code",
                                      false,
                                      (val) async {
                                        setState(() {
                                          data["ifsc"] = val;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    CustomTextField(
                                      "Enter Account Holder Name",
                                      "Account Holder",
                                      false,
                                      (val) async {
                                        setState(() {
                                          data["accountHolderName"] = val;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 20),

                                    ///// PICKUPP ADDRESS

                                    new Theme(
                                      data: new ThemeData(
                                        primaryColor: Colors.black87,
                                      ),
                                      child: new TextFormField(
                                        initialValue: null,
                                        obscureText: false,
                                        onChanged: (val) async {
                                          setState(() {
                                            data["pickupAdd"] =
                                                pickupController.text;
                                          });
                                        },
                                        decoration: new InputDecoration(
                                          isDense: true,
                                          border: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                          ),
                                          contentPadding:
                                              new EdgeInsets.symmetric(
                                            horizontal: 20.0,
                                            vertical: 10,
                                          ),
                                          labelText: "Enter Pickup Address",
                                          prefixStyle: new TextStyle(
                                            color: Colors.black,
                                          ),
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
                                          pickupController.text = businessAdd;
                                          data["pickupAdd"] = businessAdd;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF5B0D1B),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(20, 5, 20, 5),
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

                                    // Terms and Conditions

                                    Agreements(agreementCheck,
                                        agreementCheckFunction, checkboxColor),

                                    // navigator

                                    Align(
                                      alignment: Alignment.topRight,
                                      child: new Container(
                                        width: 70,
                                        height: 70,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 0, 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(70)),
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
                                          onPressed: () async {
                                            if (await validForm())
                                              await navigatorFuntion();
                                          },
                                        ),
                                      ),
                                    ),
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
