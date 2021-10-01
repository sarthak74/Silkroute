import 'package:flutter/material.dart';

class ShowDialog extends StatefulWidget {
  ShowDialog(this.child);
  final Widget child;
  ShowDialogState createState() => new ShowDialogState();
}

class ShowDialogState extends State<ShowDialog> {
  @override
  Widget build(BuildContext context) {
    return new Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 16,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.height * 0.8,
        child: widget.child,
      ),
    );
  }
}
