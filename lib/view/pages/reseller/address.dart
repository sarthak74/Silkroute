import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/view/pages/reseller/crate.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/text_field.dart';
import 'package:silkroute/view/widget/topbar.dart';

class AddressPage extends StatefulWidget {
  AddressPage({this.pageController});
  final PageController pageController;
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  LocalStorage storage = LocalStorage('silkroute');
  bool loading = true, _addressSave = false;
  var data = {
    "fullName": "",
    "contact": "",
    "pincode": "",
    "state": "",
    "city": "",
    "addLine1": "",
    "addLine2": ""
  };
  var titleOf = {
    "fullName": "Full Name",
    "contact": "Phone Number",
    "pincode": "Pin Code",
    "state": "State",
    "city": "City",
    "addLine1": "Address Line 1"
  };
  var fields = [
    "fullName",
    "contact",
    "pincode",
    "state",
    "city",
    "addLine1",
    "addLine2"
  ];
  Future<bool> addressSaveHandler() async {
    setState(() {
      _addressSave = true;
    });
    var req = ["fullName", "contact", "pincode", "state", "city", "addLine1"];
    for (String x in req) {
      if (data[x].length < 1) {
        Toast().notifyErr(titleOf[x] + " is required");
        setState(() {
          _addressSave = false;
        });
        return false;
      }
    }
    await storage.setItem('address', data);
    setState(() {
      _addressSave = false;
    });
    return true;
  }

  void loadVars() async {
    var preAdd = await storage.getItem('address');
    setState(() {
      if (preAdd != null) {
        for (var x in fields) {
          if (preAdd[x] != null) {
            data[x] = preAdd[x];
          }
        }
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
    return loading
        ? Text("Loading")
        : SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: <Widget>[
                  //// FULL NAME
                  SizedBox(height: 20),
                  CustomTextField(
                    "Full Name*",
                    "Full Name",
                    false,
                    (val) {
                      setState(() {
                        data['fullName'] = val.toString();
                      });
                    },
                    initialValue: data["fullName"],
                  ),

                  //// PHONE NUMBER
                  SizedBox(height: 20),
                  CustomTextField(
                    "Phone Number*",
                    "Phone Number",
                    false,
                    (val) {
                      setState(() {
                        data['contact'] = val.toString();
                      });
                    },
                    initialValue: data["contact"],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //// PinCode

                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.only(top: 20),
                        child: CustomTextField(
                          "Pincode*",
                          "Pincode",
                          false,
                          (val) {
                            setState(() {
                              data['pincode'] = val.toString();
                            });
                          },
                          initialValue: data["pincode"],
                        ),
                      ),

                      //// Use My Location

                      GestureDetector(
                        onTap: null,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF5B0D1B),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.location_city,
                                size: 15,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Use My Location",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //// PinCode

                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.only(top: 20),
                        child: CustomTextField(
                          "State*",
                          "State",
                          false,
                          (val) {
                            setState(() {
                              data['state'] = val.toString();
                            });
                          },
                          initialValue: data["state"],
                        ),
                      ),
                      //// PinCode

                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.only(top: 20),
                        child: CustomTextField(
                          "City*",
                          "City",
                          false,
                          (val) {
                            setState(() {
                              data['city'] = val.toString();
                            });
                          },
                          initialValue: data["city"],
                        ),
                      ),
                    ],
                  ),

                  /////  AddLine1
                  SizedBox(height: 20),
                  CustomTextField(
                    "Address Line 1*",
                    "Address Line 1",
                    false,
                    (val) {
                      setState(() {
                        data['addLine1'] = val.toString();
                      });
                    },
                    initialValue: data["addLine1"],
                  ),

                  /////  AddLine2
                  SizedBox(height: 20),
                  CustomTextField(
                    "Address Line 2",
                    "Address Line 2",
                    false,
                    (val) {
                      setState(() {
                        data['addLine2'] = val.toString();
                      });
                    },
                    initialValue: data["addLine2"],
                  ),

                  //// SAVE
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      var res = await addressSaveHandler();
                      if (res) {
                        setState(() {
                          widget.pageController.animateToPage(2,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut);
                          CratePage().addressStatus =
                              !CratePage().addressStatus;
                        });
                      }
                    },
                    child: _addressSave
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.05,
                            height: MediaQuery.of(context).size.width * 0.05,
                            child: CircularProgressIndicator(
                              color: Color(0xFF5B0D1B),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF5B0D1B),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
  }
}
