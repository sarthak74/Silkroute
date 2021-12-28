import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/NotificationApi.dart';

class NotificationService {
  void Notify(data) async {
    print("notify");
    // String _timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await NotificationApi().saveNotification(data);

    if (data["img"] == null) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: data['messageId'],
          channelKey: 'key1',
          title: data["title"],
          body: data["body"],
          wakeUpScreen: true,
        ),
        // schedule: NotificationInterval(
        //   interval: 60,
        //   timeZone: _timezone,
        //   repeats: true,
        // ),
      );
    } else {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: data['messageId'],
          channelKey: 'key1',
          title: data["title"],
          body: data["body"],
          bigPicture: data["data"]["img"],
          notificationLayout: NotificationLayout.BigPicture,
          wakeUpScreen: true,
        ),
        // schedule: NotificationInterval(
        //   interval: 60,
        //   timeZone: _timezone,
        //   repeats: true,
        // ),
      );
    }
  }
}
