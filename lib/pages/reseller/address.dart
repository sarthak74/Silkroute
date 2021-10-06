import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/pages/reseller/crate.dart';
import 'package:silkroute/widget/navbar.dart';
import 'package:silkroute/widget/text_field.dart';
import 'package:silkroute/widget/topbar.dart';

class AddressPage extends StatefulWidget {
  AddressPage({this.pageController});
  final PageController pageController;
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  var data = {
    "fullName": "",
    "phoneNumber": "",
    "pincode": "",
    "state": "",
    "city": "",
    "addLine1": "",
    "addLine2": ""
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: <Widget>[
            //// FULL NAME
            SizedBox(height: 20),
            CustomTextField("Full Name", "Full Name", false, (val) {
              setState(() {
                data['fullName'] = val.toString();
              });
            }),

            //// PHONE NUMBER
            SizedBox(height: 20),
            CustomTextField("Phone Number", "Phone Number", false, (val) {
              setState(() {
                data['phoneNumber'] = val.toString();
              });
            }),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //// PinCode

                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: EdgeInsets.only(top: 20),
                  child: CustomTextField("Pincode", "Pincode", false, (val) {
                    setState(() {
                      data['pincode'] = val.toString();
                    });
                  }),
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
                  child: CustomTextField("State", "State", false, (val) {
                    setState(() {
                      data['state'] = val.toString();
                    });
                  }),
                ),
                //// PinCode

                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: EdgeInsets.only(top: 20),
                  child: CustomTextField("City", "City", false, (val) {
                    setState(() {
                      data['city'] = val.toString();
                    });
                  }),
                ),
              ],
            ),

            /////  AddLine1
            SizedBox(height: 20),
            CustomTextField("Address Line 1", "Address Line 1", false, (val) {
              setState(() {
                data['addLine1'] = val.toString();
              });
            }),

            /////  AddLine2
            SizedBox(height: 20),
            CustomTextField("Address Line 2", "Address Line 2", false, (val) {
              setState(() {
                data['addLine2'] = val.toString();
              });
            }),

            //// SAVE
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.pageController.animateToPage(2,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut);
                  CratePage().addressStatus = !CratePage().addressStatus;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF5B0D1B),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
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
