import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class CategoryHead extends StatefulWidget {
  const CategoryHead({this.icon, this.title});
  final dynamic icon;
  final String title;

  @override
  _CategoryHeadState createState() => _CategoryHeadState();
}

class _CategoryHeadState extends State<CategoryHead> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      // margin: EdgeInsets.symmetric(
      //   horizontal: MediaQuery.of(context).size.width * 0.15,
      // ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent, width: 0),
        borderRadius: BorderRadius.all(Radius.circular(35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          (widget.icon == null) ? SizedBox(width: 0) : widget.icon,
          SizedBox(width: 10),
          Text(
            widget.title,
            style: textStyle1(
              (widget.icon == null) ? 18 : 25,
              Color(0xFF811111),
              FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
