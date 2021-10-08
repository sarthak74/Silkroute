import 'package:flutter/material.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:silkroute/view/widget/language_picker_widget.dart';

class LocalizationAppPage extends StatefulWidget {
  @override
  _LocalizationAppPageState createState() => _LocalizationAppPageState();
}

class _LocalizationAppPageState extends State<LocalizationAppPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/1.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                new Text(
                  "Choose Your Language",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 10),
                new Text(
                  "अपनी भाषा चुनें",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.teal[300],
                  ),
                ),
                SizedBox(height: 32),
                LanguagePickerWidget(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                new Align(
                  alignment: Alignment.topRight,
                  child: new Container(
                    width: 70,
                    height: 70,
                    margin: EdgeInsets.fromLTRB(0, 0, 30, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(70)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.teal,
                          Colors.teal[200],
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
                        Methods().isAuthenticated()
                            ? Navigator.of(context).pushNamed("/reseller_home")
                            : Navigator.of(context).pushNamed("/enter_contact");
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
