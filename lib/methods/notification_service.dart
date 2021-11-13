import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  Future<void> _firebasePushHandler(RemoteMessage message) async {
    print("Notififcation: ${message.data}");
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }

  void Notify() async {
    // String _timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: "Notification Title",
        body: 'notification body',
        bigPicture: 'https://pub.dev/static/img/pub-dev-icon-cover-image.png',
        notificationLayout: NotificationLayout.BigPicture,
      ),
      // schedule: NotificationInterval(
      //   interval: 60,
      //   timeZone: _timezone,
      //   repeats: true,
      // ),
    );
  }

  get firebasePushHandler => _firebasePushHandler;
}
