import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class ConfirmationDialog extends StatefulWidget {
  const ConfirmationDialog({Key key, this.title, this.description})
      : super(key: key);
  final String title, description;

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 15,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.title,
            style: textStyle1(
              13,
              Colors.black,
              FontWeight.w500,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              size: 15,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      content: Text(
        widget.description,
        style: textStyle1(
          11,
          Colors.black54,
          FontWeight.normal,
        ),
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Text(
                    "NO",
                    style: textStyle(12, Color(0xFF5B0D1B)),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, false);
                },
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Text(
                    "YES",
                    style: textStyle(12, Color(0xFF5B0D1B)),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
