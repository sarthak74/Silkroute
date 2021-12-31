import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class PriceChangeAlertDialog extends StatefulWidget {
  const PriceChangeAlertDialog({Key key}) : super(key: key);

  @override
  _PriceChangeAlertDialogState createState() => _PriceChangeAlertDialogState();
}

class _PriceChangeAlertDialogState extends State<PriceChangeAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      elevation: 16,
      title: Container(
        // height: MediaQuery.of(context).size.height * 0.5,
        // padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      size: 25,
                      color: Color(0xFF811111),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Alert",
                      style: textStyle1(18, Colors.black, FontWeight.normal),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close, size: 25),
                  borderRadius: BorderRadius.circular(12.5),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Looks like price of some products in crate were changed.\nClose this dialog to see changes!",
              style: textStyle(14, Colors.black),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
