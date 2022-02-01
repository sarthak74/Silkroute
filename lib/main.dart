import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:silkroute/l10n/l10n.dart';
import 'package:silkroute/model/services/firebase.dart';
import 'package:silkroute/provider/PackageProvider.dart';
import 'package:silkroute/view/pages/coming_soon.dart';
import 'package:silkroute/view/pages/loader.dart';
import 'package:silkroute/view/pages/manual_verification.dart';
import 'package:silkroute/view/pages/merchant/add_new_product_page.dart';
import 'package:silkroute/view/pages/merchant/dashboard.dart';
import 'package:silkroute/view/pages/merchant/merchant_acc_details.dart';
import 'package:silkroute/view/pages/merchant/merchant_orders.dart';
import 'package:silkroute/view/pages/merchant/merchant_profile.dart';
import 'package:silkroute/view/pages/merchant/packages.dart';
import 'package:silkroute/view/pages/merchant/packages_and_pickups.dart';
import 'package:silkroute/view/pages/reseller/category.dart';
import 'package:silkroute/view/pages/reseller/crate.dart';
import 'package:silkroute/view/pages/enter_contact.dart';
import 'package:silkroute/view/pages/merchant/merchant_home.dart';
import 'package:silkroute/view/pages/otp-verification.dart';
import 'package:silkroute/view/pages/register_detail_page.dart';
import 'package:silkroute/view/pages/reseller/faqs.dart';
import 'package:silkroute/view/pages/reseller/main_order.page.dart';
import 'package:silkroute/view/pages/reseller/reseller_home.dart';
import 'package:silkroute/view/pages/reseller/reseller_profile.dart';
import 'package:silkroute/view/pages/reseller/search.dart';
import 'package:silkroute/view/pages/reseller/wishlist.dart';
import 'package:silkroute/provider/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:silkroute/methods/notification_service.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

Future<void> secureScreen() async {
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebasePushHandler);

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'key1',
      channelName: 'notificationtest',
      channelDescription: 'ex',
      importance: NotificationImportance.High,
      channelShowBadge: true,
      playSound: true,
    ),
  ]);

  LocalStorage storage = await LocalStorage('silkroute');

  FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
    await storage.setItem('fcmtoken', token);
    await FirebaseService().saveToken(token);
  });

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // secureScreen();

  void runapp() {
    storage.ready.then((res) {
      runApp(MyApp());
    });
  }

  runapp();
}

class MyApp extends StatelessWidget {
  final String title = 'Silk Route';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            locale: provider.locale,
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: MainLoader(),
            routes: <String, WidgetBuilder>{
              // "/": (BuildContext context) => MainLoader(),
              "/localization_page": (BuildContext context) => MainLoader(),
              "/enter_contact": (BuildContext context) => EnterContactPage(),
              "/otp_verification": (BuildContext context) =>
                  OtpVerificationPage(),
              "/register_detail": (BuildContext context) =>
                  RegisterDetailPage(),
              "/reseller_home": (BuildContext context) => ResellerHome(),
              "/reseller_profile": (BuildContext context) => ResellerProfile(),
              "/merchant_home": (BuildContext context) => MerchantHome(),
              "/categories": (BuildContext context) =>
                  CategoryPage(category: "saree"),
              "/search": (BuildContext context) => SearchPage(),
              "/wishlist": (BuildContext context) => WishlistPage(),
              "/crate": (BuildContext context) => CratePage(),
              "/orders": (BuildContext context) => MainOrders(),
              "/faqs": (BuildContext context) => Faqs(),
              "/merchant_dashboard": (BuildContext context) =>
                  MerchantDashboard(),
              "/merchant_profile": (BuildContext context) => MerchantProfile(),
              "/merchant_packages": (BuildContext context) =>
                  ChangeNotifierProvider(
                    create: (context) => PackageProvider(),
                    child: PackagesAndPickups(),
                  ),
              "/add_new_product_page": (BuildContext context) =>
                  AddNewProductPage(),
              "/merchant_orders": (BuildContext context) => MerchantOrders(),
              "/manual_verification": (BuildContext context) =>
                  ManualVerification(),
              "/merchant_acc_details": (BuildContext context) =>
                  MechantAccountDetails(),
              "/coming_soon": (BuildContext context) => ComingSoon(),
              // "/reseller_home": (BuildContext context) => ComingSoon(),
              // "/reseller_profile": (BuildContext context) => ComingSoon(),
              // "/merchant_home": (BuildContext context) => ComingSoon(),
              // "/categories": (BuildContext context) => ComingSoon(),
              // "/search": (BuildContext context) => ComingSoon(),
              // "/wishlist": (BuildContext context) => ComingSoon(),
              // "/crate": (BuildContext context) => ComingSoon(),
              // "/orders": (BuildContext context) => ComingSoon(),
              // "/faqs": (BuildContext context) => ComingSoon(),
              // "/merchant_dashboard": (BuildContext context) => ComingSoon(),
              // "/merchant_profile": (BuildContext context) => ComingSoon(),
              // "/add_new_product_page": (BuildContext context) => ComingSoon(),
              // "/merchant_orders": (BuildContext context) => ComingSoon(),
              // "/merchant_acc_details":
            },
          );
        },
      );
}

Future<void> _firebasePushHandler(RemoteMessage message) async {
  print("Notififcation data: ${message.data}");
  RemoteNotification not = message.notification;
  print("Notififcation: $not");
  var notificationData = {
    "title": not.title,
    "body": not.body,
    "data": message.data,
    "messageId": message.messageId,
    "sentTime": message.sentTime.toString()
  };

  await NotificationService().Notify(notificationData);
}
