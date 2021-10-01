import 'package:flutter/material.dart';

class CategoryHead extends StatefulWidget {
  const CategoryHead({this.title});

  final String title;

  @override
  _CategoryHeadState createState() => _CategoryHeadState();
}

class _CategoryHeadState extends State<CategoryHead> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.15,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.15,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF5B0D1B), width: 4),
        borderRadius: BorderRadius.all(Radius.circular(35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Image.asset(
            "assets/images/1.png",
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Text(
            widget.title,
            style: TextStyle(
              color: Color(0xFF5B0D1B),
              fontSize: 45,
            ),
          ),
        ],
      ),
    );
  }
}
