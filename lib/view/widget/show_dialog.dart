import 'package:flutter/material.dart';

class ShowDialog extends StatefulWidget {
  ShowDialog(this.child, this.margin);
  final Widget child;
  final double margin;
  ShowDialogState createState() => new ShowDialogState();
}

class ShowDialogState extends State<ShowDialog> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          // right: 0,
          top: 0,
          right: -widget.margin,
          left: widget.margin,
          bottom: 0,
          child: new Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 16,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.height * 0.8,
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}
