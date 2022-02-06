import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:silkroute/view/dialogBoxes/agreementsDialogBox.dart';
import 'package:silkroute/view/dialogBoxes/sortDialogBox.dart';
import 'package:silkroute/view/widget/show_dialog.dart';

class Agreements extends StatefulWidget {
  Agreements(
      this.agreementCheck, this.agreementCheckFunction, this.checkboxColor,
      {this.title, this.dialogFn, this.userType});
  final bool agreementCheck;
  final agreementCheckFunction;
  final checkboxColor;
  final title;
  final dialogFn;
  final userType;
  @override
  _AgreementsState createState() => _AgreementsState();
}

class _AgreementsState extends State<Agreements> {
  Future showTermsAndConditions(context) async {
    return await showGeneralDialog(
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
        return ShowDialog(AgreementsDialogBox(userType: widget.userType), 0);
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
        GestureDetector(
          onTap: (widget.dialogFn == true)
              ? () async {
                  await showTermsAndConditions(context);
                }
              : () {},
          child: new Text(
            (widget.title ?? "Terms and Conditions"),
            style: TextStyle(
              fontSize: 13.0,
              color: Color(0xFF811111),
            ),
          ),
        ),
      ],
    );
  }
}
