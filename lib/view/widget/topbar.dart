import 'package:flutter/material.dart';
import 'package:silkroute/view/dialogBoxes/notifications.dart';
import 'package:silkroute/view/widget/show_dialog.dart';
import 'package:silkroute/view/widget/topIcon.dart';

class TopBar extends StatefulWidget {
  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  void showNotifications() {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return ShowDialog(NotificationDialogBox());
    //   },
    // );
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (context, _a1, _a2, _child) {
        return SlideTransition(
            child: _child,
            position: Tween<Offset>(end: Offset.zero, begin: Offset(1.0, 0.0))
                .animate(
                    CurvedAnimation(parent: _a1, curve: Curves.easeInCubic)));
      },
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, a1, a2) {
        return ShowDialog(
          NotificationDialogBox(),
          MediaQuery.of(context).size.width * 0.1 + 20,
        );
      },
    );
  }

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
                size: 25,
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
              size: 25,
              color: Colors.black87,
            ),
            margin: EdgeInsets.all(0),
            method: showNotifications,
          ),
        ],
      ),
    );
  }
}
