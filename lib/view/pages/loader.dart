import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/model/services/firebase.dart';
import 'package:new_version/new_version.dart';

class MainLoader extends StatefulWidget {
  @override
  _MainLoaderState createState() => _MainLoaderState();
}

class _MainLoaderState extends State<MainLoader> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  bool loading = true;

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      if (status.storeVersion.toString() != status.localVersion.toString()) {
        await newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: 'Update',
          dialogText: 'New update available. Update Now!',
          updateButtonText: 'Update',
          allowDismissal: false,
        );
      } else {
        init();
      }
    } else {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      }
    }
  }

  void init() async {
    Future.delayed(const Duration(seconds: 2), () async {
      LocalStorage storage = await LocalStorage('silkroute');
      // await storage.clear();
      // String token = await FirebaseService().getToken();
      var usr = await storage.getItem('user');
      var auth = usr == null ? false : true;
      var reg = (usr != null) ? usr["registered"] : null;
      var ut = (usr != null) ? usr["userType"] : null;
      print("aut-- $auth $ut $usr");
      dynamic nextpage = "";
      if (auth && (usr != null) && (reg != null) && (reg == true)) {
        if (usr['fcmtoken'] == null) {
          usr['fcmtoken'] = await FirebaseService().getToken();
          await storage.setItem('user', usr);
        }
        if (ut == "Manufacturer") {
          if (usr["verified"] == true) {
            if (usr["bankAccountNo"] != null &&
                usr["bankAccountNo"].length > 0) {
              nextpage = "/merchant_home"; // todo: merchant home
            } else {
              nextpage = "/merchant_acc_details";
            }
          } else {
            nextpage = "/manual_verification";
          }
        } else {
          if (usr["verified"] == true) {
            nextpage = "/reseller_home"; // todo: reseller home
          } else {
            nextpage = "/manual_verification";
          }
        }
      } else {
        nextpage = "/enter_contact";
      }

      // Navigator.of(context).pop();
      Navigator.of(context).popAndPushNamed(nextpage);
    });
  }

  @override
  void initState() {
    super.initState();

    final newVersion = NewVersion(
      // iOSId: 'com.google.Vespa',
      androidId: 'com.yibrance.app',
    );

    // You can let the plugin handle fetching the status and showing a dialog,
    // or you can fetch the status and display your own dialog, or no dialog.
    const simpleBehavior = false;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      advancedStatusCheck(newVersion);
    }

    controller = new AnimationController(
      duration: new Duration(seconds: 10),
      vsync: this,
    );
    animation = new CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );
    animation.addListener(() {
      this.setState(() {});
    });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

// (x * w/2 + w/2, y * h/2 + h/2)
//background: radial-gradient(50% 50% at 50% 50%, #811111 57.71%, #530000 100%);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, 0),
            radius: 0.671,
            colors: [
              Color.fromRGBO(129, 20, 20, 1),
              Color.fromRGBO(129, 20, 20, 1),
              Color(0xFF530000),
            ],
          ),
        ),
        child: Center(
          child: Stack(
            children: <Widget>[
              new RotationTransition(
                turns: new AlwaysStoppedAnimation(
                    (animation != null) ? animation.value : 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo_back.png'),
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: 1.15,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo_front.png'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
