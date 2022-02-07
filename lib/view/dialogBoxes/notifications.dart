import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:silkroute/model/services/NotificationApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

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
            color: Color(0xFF811111),
            width: 0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 30, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Notifications",
                    style: textStyle1(
                      15,
                      Color(0xff5b0d1b),
                      FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            NotificationList(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class NotificationList extends StatefulWidget {
  const NotificationList({Key key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  bool loading = true;
  dynamic notificationList;

  Future loadVars() async {
    try {
      dynamic list = await NotificationApi().getNotifications();
      print("$list");
      print("${list[0]["title"] ?? list[0]["data"]["title"]}");
      setState(() {
        notificationList = list;
        loading = false;
      });
    } catch (e) {
      print("loadVars err $e");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Color(0xFF5B0D1B),
                  ),
                ),
              ],
            ),
          )
        : ((notificationList == null || notificationList == [])
            ? Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "No Notifications",
                      style: textStyle(15, Colors.black54),
                    ),
                  ],
                ),
              )
            : Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: notificationList.length,
                    itemBuilder: (_, int i) {
                      return NotificationItem(
                        title: notificationList[i]["title"] ??
                            notificationList[i]["data"]["title"] ??
                            "",
                        body: notificationList[i]["body"] ??
                            notificationList[i]["data"]["body"] ??
                            "",
                        sentTime: notificationList[i]["sentTime"] ??
                            notificationList[i]["data"]["sentTime"] ??
                            "",
                        index: i,
                      );
                    },
                  ),
                ),
              ));
  }
}

class NotificationItem extends StatefulWidget {
  const NotificationItem(
      {Key key, this.title, this.body, this.sentTime, this.index})
      : super(key: key);
  final String title, body, sentTime;
  final int index;

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
      padding: EdgeInsets.fromLTRB(15, 8, 40, 8),
      // height: 60,
      constraints: BoxConstraints(maxHeight: 100, minHeight: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 3, color: Color(0xFFEFE9E1)),
        color: widget.index % 2 == 0 ? Color(0xFFEFE9E1) : Colors.white,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.body,
        style: textStyle1(12, Colors.black54, FontWeight.w500),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
