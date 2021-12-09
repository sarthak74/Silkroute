import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationDialogBox extends StatefulWidget {
  NotificationDialogBoxState createState() => new NotificationDialogBoxState();
}

class NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF5B0D1B),
            width: 5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                "Notifications",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
