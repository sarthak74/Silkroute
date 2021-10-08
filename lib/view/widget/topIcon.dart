import 'package:flutter/material.dart';

class TopIcon extends StatefulWidget {
  TopIcon({
    this.icon,
    this.margin,
    this.method,
  });
  final Icon icon;
  final EdgeInsets margin;
  final Function method;
  @override
  _TopIconState createState() => _TopIconState();
}

class _TopIconState extends State<TopIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.topLeft,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xFF5B0D1B),
          width: 4,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -4,
            left: -4,
            child: IconButton(
              icon: widget.icon,
              onPressed: widget.method,
            ),
          )
        ],
      ),
    );
  }
}
