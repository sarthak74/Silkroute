import 'package:flutter/material.dart';

class MyCircularProgress extends StatefulWidget {
  const MyCircularProgress(
      {Key key,
      this.height,
      this.width,
      this.color,
      this.strokeWidth,
      this.marginTop})
      : super(key: key);
  final num height, width, strokeWidth, marginTop;
  final dynamic color;
  @override
  _MyCircularProgressState createState() => _MyCircularProgressState();
}

class _MyCircularProgressState extends State<MyCircularProgress> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: double.parse((widget.marginTop ?? 0.0).toString()) ?? 50.0,
      ),
      height: double.parse((widget.height ?? 25.0).toString()) ?? 25.0,
      width: double.parse((widget.width ?? 25.0).toString()) ?? 25.0,
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: CircularProgressIndicator(
          strokeWidth:
              double.parse((widget.strokeWidth ?? 3.0).toString()) ?? 3.0,
          color: widget.color ?? Color(0xff811111),
        ),
      ),
    );
  }
}
