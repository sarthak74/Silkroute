import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/registerredirect.dart';
import 'package:silkroute/model/services/authservice.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/liscenseAndAgreements.dart';
import 'package:silkroute/view/widget/text_field.dart';

class BankAccountDialog extends StatefulWidget {
  const BankAccountDialog({Key key}) : super(key: key);

  @override
  BankAccountDialogState createState() => BankAccountDialogState();
}

class BankAccountDialogState extends State<BankAccountDialog> {
  String contact, businessAdd = "";
  dynamic data = {
        "bankAccountNo": "",
        "ifsc": "",
        "accountHolderName": "",
      },
      user;
  bool loading = true, agreementCheck = false;
  LocalStorage storage = LocalStorage('silkroute');

  TextEditingController pickupController = new TextEditingController();

  List<String> reqFields = [
    "bankAccountNo",
    "ifsc",
    "accountHolderName",
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: SingleChildScrollView(
          child: loading
              ? Text("Loading...")
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close),
                      ),
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
                      initialValue: data["bankAccountNo"],
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
                          data["accountHolderName"] = val;
                        });
                      },
                      initialValue: data["accountHolderName"],
                    ),
                    SizedBox(height: 20),

                    // navigator

                    Align(
                      alignment: Alignment.topRight,
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
                          onPressed: () async {
                            if (await validForm()) await navigatorFuntion();
                          },
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
