import 'package:flutter/material.dart';

class NextPageButton extends StatelessWidget {
  NextPageButton(this.nextPage);
  final String nextPage;

  @override
  Widget build(BuildContext context) {
    return new Align(
      alignment: Alignment.topRight,
      child: new Container(
        width: 70,
        height: 70,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(70)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff55ce23),
              Color(0xffbefd32),
            ],
          ),
        ),
        child: new IconButton(
          icon: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
          ),
          iconSize: 40.0,
          onPressed: () {
            Navigator.of(context).pushNamed(nextPage);
          },
        ),
      ),
    );
  }
}
