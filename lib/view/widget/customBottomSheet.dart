import 'package:flutter/material.dart';
import 'package:silkroute/view/dialogBoxes/editAccountDetailsBottomsheet.dart';

class CustomBottomSheet {
  CustomBottomSheet({this.child});
  final dynamic child;
  void show(context, child) async {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      constraints: BoxConstraints(minHeight: 150),
      // isScrollControlled: true,
      builder: (BuildContext context) {
        return child;
      },
    );
  }
}
