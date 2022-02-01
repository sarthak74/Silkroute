import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:silkroute/model/services/CrateApi.dart';
import 'package:silkroute/model/services/couponApi.dart';
import 'package:silkroute/provider/PackageProvider.dart';
import 'package:silkroute/view/dialogBoxes/CouponDialogBox.dart';
import 'package:silkroute/view/dialogBoxes/colorImageDialog.dart';
import 'package:silkroute/view/dialogBoxes/confirmationDialog.dart';
import 'package:silkroute/view/dialogBoxes/editPickupAddressDialog.dart';
import 'package:silkroute/view/dialogBoxes/offline_bank_transfer_dialog.dart';
import 'package:silkroute/view/dialogBoxes/package_detail.dart';
import 'package:silkroute/view/dialogBoxes/price_change_alert_dialog.dart';
import 'package:silkroute/view/dialogBoxes/request_return_dialog.dart';
import 'package:silkroute/view/dialogBoxes/schedulePickupDialog.dart';
import 'package:silkroute/view/dialogBoxes/showBankAccountDialog.dart';
import 'package:silkroute/view/dialogBoxes/single_select_package_dialog.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/show_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers {
  launchURLBrowser(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<List<String>> getAgreements() {
    return [
      [
        "Mentioned stock must be available",
        "If stock decreases due to any external reason, immideately update it on app",
        "Do not enter false/ambiguous information of products",
        "85% Payment within 24 hrs, 15% Payment after 15 days (at the end of return policy)",
        "You have to keep your package ready within 2 hrs of getting order confirmation.",
        "There must not be anything else inside package, strict actions will be taken."
      ],
      [
        "If return request is made, we will notify you immideately & you can track the  package.",
        "You have to return the money within 7 days of return request.",
        "due to false information, you will pay logistic charges."
      ]
    ];
  }

  Future<ImageSource> getImageSource(context) async {
    ImageSource source;

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      constraints: BoxConstraints(minHeight: 100),
      // isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.fromLTRB(30, 1, 30, 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  source = ImageSource.camera;
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Camera",
                      style: textStyle(13, Colors.black),
                    ),
                  ],
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  source = ImageSource.gallery;
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.image,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Gallery",
                      style: textStyle(13, Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    return source;
  }

  Future showPickupAddressDialog(context) async {
    LocalStorage storage = LocalStorage('silkroute');
    var user = await storage.getItem('user');
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => EditPickupAddressDialog(
        info: user['pickupAdd'].toString(),
      ),
    );
  }

  Future showOfflineBankTransferDialog(context, orderId) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => OfflineBankTransferDialog(orderId),
    );
  }

  Future showBusinessAddressDialog(context, info) async {
    var user = await Methods().getUser();
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: Text(
          user["currAdd"]["address"].toString(),
          style: textStyle(15, Colors.black),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Text(
              "Close",
              style: textStyle(12, Color(0xFF5B0D1B)),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future showGstinDialog(context, info) async {
    var user = await Methods().getUser();
    var gst = user["gst"];
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: Text(
          (gst == null) ? "No gst added" : gst.toString(),
          style: textStyle(15, Colors.black),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Text(
              "Close",
              style: textStyle(12, Color(0xFF5B0D1B)),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future showBankAccountDialog(context) async {
    await showDialog(
      context: context,
      builder: (_) => BankAccountDialog(),
    );
  }

  Future showCoupons(context) async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CouponsDialog();
      },
    );
  }

  Future showColorImageDialog(context, images, selected, setSize) async {
    await showDialog(
      context: context,
      builder: (_) => ColorImageDialog(
        images: images,
        selected: selected,
        setSize: setSize,
      ),
    );
    return selected;
  }

  Future showPriceChangeAlert(context) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (context, _a1, _a2, _child) {
        return ScaleTransition(
          child: _child,
          scale: CurvedAnimation(parent: _a1, curve: Curves.bounceOut),
        );
      },
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, a1, a2) {
        return PriceChangeAlertDialog();
      },
    );
  }

  // reseller request return dialog helper
  Future showRequestReturn(context, enterquantity,
      {orderDetails, selected}) async {
    dynamic items = [];
    print("selected: $selected");
    if (selected == null) {
      selected = [];
      for (var x in orderDetails['items']) {
        selected.add(true);
      }
    }
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (context, _a1, _a2, _child) {
        return ScaleTransition(
          child: _child,
          scale: CurvedAnimation(parent: _a1, curve: Curves.bounceOut),
        );
      },
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, a1, a2) {
        return RequestReturnDialog(orderDetails, selected, enterquantity);
      },
    );
  }

  Future<bool> getConfirmationDialog(
      context, String title, String description) async {
    return await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (context, _a1, _a2, _child) {
        return ScaleTransition(
          child: _child,
          scale: CurvedAnimation(parent: _a1, curve: Curves.bounceOut),
        );
      },
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, a1, a2) {
        return ConfirmationDialog(
          title: title,
          description: description,
        );
      },
    );
  }

  Future<dynamic> showSchedulePickupDialog(context) async {
    var dimensions = [
      {"l": 0.0, "b": 0.0, "h": 0.0, "w": 0.0}
    ];
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (context, _a1, _a2, _child) {
        return ScaleTransition(
          child: _child,
          scale: CurvedAnimation(parent: _a1, curve: Curves.bounceOut),
        );
      },
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, a1, a2) {
        return SchedulePickupDialog(dimensions: dimensions);
      },
    );
    return dimensions;
  }

  Future<dynamic> singleSelectPackageDialog(context) async {
    dynamic package = await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (context, _a1, _a2, _child) {
        return ScaleTransition(
          child: _child,
          scale: CurvedAnimation(parent: _a1, curve: Curves.ease),
        );
      },
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, a1, a2) {
        return ChangeNotifierProvider(
          create: (context) => PackageProvider(),
          child: SingleSelectPackageDialog(),
        );
      },
    );
    return package;
  }

  Future packageDetails(context, package, packageProvider) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (context, _a1, _a2, _child) {
        return ScaleTransition(
          child: _child,
          scale: CurvedAnimation(parent: _a1, curve: Curves.ease),
        );
      },
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, a1, a2) {
        return PackageDetail(
            package: package, packageProvider: packageProvider);
      },
    );
  }
}
