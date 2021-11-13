import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:silkroute/l10n/l10n.dart';
import 'package:silkroute/view/pages/loader.dart';
import 'package:silkroute/view/pages/merchant/add_new.dart';
import 'package:silkroute/view/pages/merchant/add_new_product_page.dart';
import 'package:silkroute/view/pages/merchant/dashboard.dart';
import 'package:silkroute/view/pages/merchant/merchant_orders.dart';
import 'package:silkroute/view/pages/merchant/merchant_profile.dart';
import 'package:silkroute/view/pages/reseller/category.dart';
import 'package:silkroute/view/pages/reseller/crate.dart';
import 'package:silkroute/view/pages/enter_contact.dart';
import 'package:silkroute/view/pages/localization_app_page.dart';
import 'package:silkroute/view/pages/merchant/merchant_home.dart';
import 'package:silkroute/view/pages/otp-verification.dart';
import 'package:silkroute/view/pages/register_detail_page.dart';
import 'package:silkroute/view/pages/reseller/faqs.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/pages/reseller/reseller_home.dart';
import 'package:silkroute/view/pages/reseller/reseller_profile.dart';
import 'package:silkroute/view/pages/reseller/search.dart';
import 'package:silkroute/view/pages/reseller/wishlist.dart';
import 'package:silkroute/provider/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:silkroute/methods/notification_service.dart';

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
      defaultColor: Colors.blue,
      ledColor: Colors.white,
      playSound: true,
      enableLights: true,
      enableVibration: true,
    )
  ]);

  LocalStorage storage = LocalStorage('silkroute');

  void runapp() {
    storage.ready.then((res) {
      runApp(MyApp());
    });
  }

  runapp();
}

class MyApp extends StatelessWidget {
  static final String title = 'Silk Route';

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
              "/orders": (BuildContext context) => Orders(),
              "/faqs": (BuildContext context) => Faqs(),
              "/merchant_dashboard": (BuildContext context) =>
                  MerchantDashboard(),
              "/merchant_profile": (BuildContext context) => MerchantProfile(),
              "/add_new_product_page": (BuildContext context) =>
                  AddNewProductPage(),
              "/merchant_orders": (BuildContext context) => MerchantOrders(),
            },
          );
        },
      );
}

Future<void> _firebasePushHandler(RemoteMessage message) async {
  print("Notififcation: ${message.data}");
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}
