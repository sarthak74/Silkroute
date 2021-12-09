import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:silkroute/view/dialogBoxes/agreementsDialogBox.dart';
import 'package:silkroute/view/dialogBoxes/sortDialogBox.dart';
import 'package:silkroute/view/widget/show_dialog.dart';

class Agreements extends StatefulWidget {
  Agreements(
      this.agreementCheck, this.agreementCheckFunction, this.checkboxColor);
  final bool agreementCheck;
  final agreementCheckFunction;
  final checkboxColor;
  @override
  _AgreementsState createState() => _AgreementsState();
}

class _AgreementsState extends State<Agreements> {
  void showTermsAndConditions() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (context, _a1, _a2, _child) {
        return ScaleTransition(
          child: _child,
          scale: CurvedAnimation(parent: _a1, curve: Curves.bounceOut),
        );
      },
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, a1, a2) {
        return ShowDialog(AgreementsDialogBox(), 0);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Checkbox(
          value: widget.agreementCheck,
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(widget.checkboxColor),
          onChanged: widget.agreementCheckFunction,
        ),
        new Padding(
          padding: EdgeInsets.only(right: 10.0),
        ),
        GestureDetector(
          onTap: () {
            showTermsAndConditions();
          },
          child: new Text(
            "Terms and Conditions",
            style: TextStyle(
              fontSize: 15.0,
              color: Color(0xFF530000),
            ),
          ),
        ),
      ],
    );
  }
}
