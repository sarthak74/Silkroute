import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class EditAccountDetailsBottomSheet extends StatefulWidget {
  const EditAccountDetailsBottomSheet({Key key}) : super(key: key);

  @override
  _EditAccountDetailsBottomSheetState createState() =>
      _EditAccountDetailsBottomSheetState();
}

class _EditAccountDetailsBottomSheetState
    extends State<EditAccountDetailsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: SizedBox(width: 0)),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Please update your account details ",
                style: textStyle1(
                  13,
                  Colors.black,
                  FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/merchant_acc_details');
                },
                child: Text(
                  "HERE",
                  style: textStyle1(
                    13,
                    Color(0xFF811111),
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
