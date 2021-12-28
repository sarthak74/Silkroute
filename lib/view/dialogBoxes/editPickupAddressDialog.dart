// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:silkroute/model/services/authservice.dart';
import 'package:silkroute/view/pages/reseller/order_page.dart';

class EditPickupAddressDialog extends StatefulWidget {
  const EditPickupAddressDialog({Key key, this.info}) : super(key: key);

  final String info;

  @override
  _EditPickupAddressDialogState createState() =>
      _EditPickupAddressDialogState();
}

class _EditPickupAddressDialogState extends State<EditPickupAddressDialog> {
  bool editing = false;
  dynamic user;
  String currentInfo;

  TextEditingController controller = new TextEditingController();

  Widget editingInfo, nonEditingInfo;

  loadVars() {
    currentInfo = widget.info.toString();

    editingInfo = Theme(
      data: new ThemeData(
        primaryColor: Colors.black87,
      ),
      child: new TextField(
        controller: controller,
        style: textStyle(13, Colors.black87),
        decoration: new InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintStyle: textStyle(13, Colors.black54),
          disabledBorder: outlineInputBorder(Colors.black54),
          focusedBorder: outlineInputBorder(Colors.black87),
          enabledBorder: outlineInputBorder(Colors.black54),
          border: outlineInputBorder(Colors.black54),
          contentPadding: new EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          prefixStyle: new TextStyle(
            color: Colors.black,
          ),
          hintText: controller.text.length > 0 ? "" : "Enter Pickup Address",
        ),
      ),
    );
  }

  OutlineInputBorder outlineInputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: color,
      ),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    );
  }

  LocalStorage storage = LocalStorage('silkroute');

  @override
  void initState() {
    super.initState();
    controller.text = widget.info.toString();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: editing
          ? editingInfo
          : Text(
              currentInfo.toString(),
              style: textStyle(15, Colors.black),
            ),
      actionsPadding: EdgeInsets.all(10),
      actions: <Widget>[
        GestureDetector(
          child: Text(
            editing ? "Save" : "Edit",
            style: textStyle(12, Color(0xFF5B0D1B)),
          ),
          onTap: !editing
              ? () {
                  setState(() {
                    editing = true;
                  });
                }
              : () async {
                  user = await Methods().getUser();
                  user['pickupAdd'] = controller.text.toString();
                  await storage.deleteItem('user');
                  await storage.setItem('user', user);
                  await AuthService().updateUser(
                    user['contact'],
                    {"pickupAdd": controller.text.toString()},
                  );
                  setState(() {
                    currentInfo = controller.text.toString();
                    editing = false;
                  });
                },
        ),
        SizedBox(width: 20),
        GestureDetector(
          child: Text(
            "Close",
            style: textStyle(12, Color(0xFF5B0D1B)),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
