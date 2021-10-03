import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:silkroute/l10n/l10n.dart';
import 'package:silkroute/pages/category.dart';
import 'package:silkroute/pages/enter_contact.dart';
import 'package:silkroute/pages/localization_app_page.dart';
import 'package:silkroute/pages/manufacturer/manufacturer_home.dart';
import 'package:silkroute/pages/otp-verification.dart';
import 'package:silkroute/pages/register_detail_page.dart';
import 'package:silkroute/pages/reseller_home.dart';
import 'package:silkroute/provider/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

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
            home: LocalizationAppPage(),
            routes: <String, WidgetBuilder>{
              "/localization_page": (BuildContext context) =>
                  LocalizationAppPage(),
              "/enter_contact": (BuildContext context) => EnterContactPage(),
              "/otp_verification": (BuildContext context) =>
                  OtpVerificationPage(),
              "/register_detail": (BuildContext context) =>
                  RegisterDetailPage(),
              "/reseller_home": (BuildContext context) => ResellerHome(),
              "/manufacturer_home": (BuildContext context) =>
                  ManufacturerHome(),
            },
          );
        },
      );
}
