import 'package:flutter/material.dart';
import 'package:silkroute/view/widget/topIcon.dart';

class TopBar extends StatefulWidget {
  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Builder(
            builder: (context) => TopIcon(
              icon: Icon(
                Icons.menu,
                size: 35,
                color: Colors.black87,
              ),
              margin: EdgeInsets.all(0),
              method: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          TopIcon(
            icon: Icon(
              Icons.notifications,
              size: 35,
              color: Colors.black87,
            ),
            margin: EdgeInsets.all(0),
            method: null,
          ),
        ],
      ),
    );
  }
}
