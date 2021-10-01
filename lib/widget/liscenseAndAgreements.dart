import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        new Text(
          AppLocalizations.of(context).termsConditions,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }
}
