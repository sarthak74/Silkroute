import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class AwesomeNotificationsService {
  void awesomeNotifications(context) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Deny",
                  style: textStyle1(15, Colors.grey, FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {
                  AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context));
                },
                child: Text(
                  'Allow',
                  style: textStyle1(15, Color(0xFF811111), FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    });

    // AwesomeNotifications().createdStream.listen((event) {
    //   print("awsm notif create event $event");
    // });

    // AwesomeNotifications().actionStream.listen((event) {
    //   print('awsm notif action event $event');
    //   print(event.toMap().toString());
    //   Navigator.pushNamed(context, '/merchant_orders');
    // });
  }
}
