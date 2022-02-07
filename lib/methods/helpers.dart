import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:silkroute/model/services/CrateApi.dart';
import 'package:silkroute/model/services/couponApi.dart';
import 'package:silkroute/provider/NewProductProvider.dart';
import 'package:silkroute/provider/PackageProvider.dart';
import 'package:silkroute/view/dialogBoxes/CouponDialogBox.dart';
import 'package:silkroute/view/dialogBoxes/agreementsDialogBox.dart';
import 'package:silkroute/view/dialogBoxes/colorImageDialog.dart';
import 'package:silkroute/view/dialogBoxes/confirmationDialog.dart';
import 'package:silkroute/view/dialogBoxes/editPickupAddressDialog.dart';
import 'package:silkroute/view/dialogBoxes/offline_bank_transfer_dialog.dart';
import 'package:silkroute/view/dialogBoxes/package_detail.dart';
import 'package:silkroute/view/dialogBoxes/pickup_details_dialog.dart';
import 'package:silkroute/view/dialogBoxes/price_change_alert_dialog.dart';
import 'package:silkroute/view/dialogBoxes/request_return_dialog.dart';
import 'package:silkroute/view/dialogBoxes/schedulePickupDialog.dart';
import 'package:silkroute/view/dialogBoxes/showBankAccountDialog.dart';
import 'package:silkroute/view/dialogBoxes/single_select_package_dialog.dart';
import 'package:silkroute/view/pages/merchant/add_new_product_page.dart';
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

  List<List<String>> getAgreements(userType) {
    List<List<String>> reseller = [
      [
        "Read product details and offer details carefully before placing the order.",
        "All products are available only in wholesale sets.",
        "Choose colors if multiple colors are available, enter the quantity and add to crate.",
        "Enter your pin code, apply coupons and recheck bill before proceeding.",
        "Enter address & complete payment as per your preference.",
        "After placing order you can download the gst invoice from orders pages.",
        "In case we fail to deliver the order after 15 days of estimated delivery date, you will get 100% refund."
      ],
      [
        "We have 7 day no question return policy.",
        "If you want to return few/all products, go to orders details and then select product, enter quantity & create request return.",
        "There are no charges for return only if value of purchase order was more than 8000.",
        "Pack the return products in same package in which it came, keep label intact and hand over to pickup guy.",
        "For one order you cannot create multiple return requests, whatever you want to return, return in one time.",
        "You will get refund money after 7-15 days.",
        "Lesser the returns more exclusive offers you will get in next orders.",
        "You are responsible for any frauds/misdeed in return order."
      ]
    ];

    List<List<String>> merchant = [
      [
        "Mentioned product details must be correct.",
        "Mentioned stock must be available and keep it updated if it is reduced due to any reason.",
        "Keep the package/s ready along with invoice and it handover to pickup guy.",
        "If shipping is done through transport (non-courier service), you are responsible till product reaches us.",
        "We have 7 day no question return policy. 7 days count starts from the date we deliver product to our customer.",
        "Within return period we can return few/all the products.",
        "You will get 40% payment within 2 working days or order dispatch date whichever is later.",
        "You will get remaining payment (amount after adjusting return order) at the end of return period.",
        "If in any case value of return order exceeds the amount we have already paid to you for a order, you have to refund the required amount before the end of return period.",
        "You are responsible for delivering wrong/defective products or any other fraud/misdeed."
      ],
      []
    ];
    return userType == "Manufacturer" ? merchant : reseller;
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
    LocalStorage storage = await LocalStorage('silkroute');
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
          style: textStyle1(13, Colors.black, FontWeight.normal),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(right: 20),
              child: Text(
                "Close",
                style: textStyle1(12, Color(0xFF5B0D1B), FontWeight.bold),
              ),
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
          style: textStyle1(13, Colors.black, FontWeight.normal),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(right: 20),
              child: Text(
                "Close",
                style: textStyle1(12, Color(0xFF5B0D1B), FontWeight.bold),
              ),
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
          scale: CurvedAnimation(parent: _a1, curve: Curves.ease),
        );
      },
      transitionDuration: Duration(milliseconds: 400),
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
          scale: CurvedAnimation(parent: _a1, curve: Curves.ease),
        );
      },
      transitionDuration: Duration(milliseconds: 400),
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
              scale: CurvedAnimation(parent: _a1, curve: Curves.ease),
            );
          },
          transitionDuration: Duration(milliseconds: 400),
          pageBuilder: (context, a1, a2) {
            return ConfirmationDialog(
              title: title,
              description: description,
            );
          },
        ) ??
        false;
  }

  Future showTermsAndConditions(context) async {
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
        return ShowDialog(AgreementsDialogBox(), 0);
      },
    );
  }

  Future<dynamic> showSchedulePickupDialog(context, orderpackages) async {
    var res = await showGeneralDialog(
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
        return SchedulePickupDialog(dimensions: orderpackages);
      },
    );
    return res;
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

  Future pickupDetails(context, orders, docs, wt) async {
    print("dialog orders: $orders");
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
        return PickupDetailsDialog(orders: orders, docs: docs, wt: wt);
      },
    );
  }

  List<Widget> buildparams(context, params, _textControllers, data, _focusNodes,
      buildSpecs, _controller) {
    List<String> keys = Helpers().getKeys(params);
    List<Widget> res = [];

    for (String key in keys) {
      var param = params[key];
      // print("parms: $param");
      var parent = param["parent"];
      var parentVals = param["parentVals"];
      if (parentVals == null) {
        parentVals = [];
      }
      bool ok = true;
      // print("paren: $parent\n$parentVals");
      for (int i = 0; i < parent.length; i++) {
        ok &= (((data[parent[i]] ?? {})["value"] ?? "").toString() ==
            parentVals[i].toString());
      }
      if (!ok) continue;
      Widget c = param["fieldType"] == "Dropdown"
          ? buildDropdown(context, param, data, buildSpecs)
          : buildTextfield(
              context, param, _textControllers, data, _focusNodes, _controller);
      res.add(c);
    }
    return res;
  }

  Widget buildDropdown(context, param, data, buildSpecs) {
    // print("drop params: ${param['values']}");
    List<String> itemList = [];
    for (var x in param["values"]) {
      itemList.add(x.toString());
    }
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              "${param['title']}",
              style: textStyle1(
                12,
                Colors.black,
                FontWeight.normal,
              ),
            ),
          ),
          // SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: DropdownSearch<String>(
              mode: Mode.MENU,

              showSelectedItems: true,
              items: itemList,
              // label: "Category",
              // selectedItem: NewProductProvider.category,
              // selectedItem: pincodeAddress[0]["Name"],
              onChanged: (val) async {
                // print("object $val");
                if (data[param["key"]] == null)
                  data[param["key"]] = {
                    "title": param["title"],
                    "value": "",
                    "key": param["key"]
                  };
                data[param["key"]]["value"] = val.toString();
                data[param["key"]]["title"] = param["title"];

                await buildSpecs();
              },
              dropdownSearchBaseStyle: textStyle1(
                11,
                Colors.black,
                FontWeight.normal,
              ),
              dropdownButtonBuilder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
                  child: Icon(Icons.arrow_downward, size: 20),
                );
              },

              popupItemBuilder: (BuildContext context, dynamic s, bool sel) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                    s.toString(),
                    style: textStyle1(
                      11,
                      sel ? Color(0xFF811111) : Colors.black,
                      FontWeight.w500,
                    ),
                  ),
                );
              },
              dropdownBuilder: (BuildContext context, dynamic val) {
                print("dd ${param['key']} ${data[param['key']]}");

                val = ((data[param['key']] ?? {"value": null})["value"]) ?? val;

                bool ok = itemList.contains(val.toString());
                print("itel $itemList");
                print("val $val");
                if (!ok) {
                  if (data[param['key']] == null) {
                    data[param['key']] = {
                      "title": param["title"],
                      "value": "",
                      "key": param['key']
                    };
                  } else {
                    data[param['key']]["value"] = "";
                  }
                }
                return Container(
                  child: Text(
                    ((val == null || !ok) ? "Select" : val.toString()),
                    style: textStyle1(
                      11,
                      Colors.black,
                      FontWeight.normal,
                    ),
                  ),
                );
              },
              dropdownSearchDecoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.black54,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.black54,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                labelStyle: textStyle1(
                  11,
                  Colors.black,
                  FontWeight.normal,
                ),
                hintStyle: textStyle1(11, Colors.black, FontWeight.w500),
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextfield(
      context, param, _textControllers, data, _focusNodes, _controller) {
    // print("text param $param");
    if (_textControllers == null) {
      _textControllers = {};
    }
    if (_focusNodes == null) {
      _focusNodes = {};
    }
    _textControllers[param['key']] = new TextEditingController();
    if (data[param['key']] == null)
      data[param['key']] = {
        "title": param["title"],
        "value": "",
        "key": param['key']
      };
    _textControllers[param['key']].text = data[param['key']]["value"] ?? "";
    if (_focusNodes[param['key']] == null) {
      _focusNodes[param['key']] = new FocusNode();
      _focusNodes[param['key']].addListener(() {
        if (_focusNodes[param['key']].hasFocus) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    }
    _focusNodes[param['key']] = _focusNodes[param['key']] ?? (new FocusNode());
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              "${param['title']}",
              style: textStyle1(
                12,
                Colors.black,
                FontWeight.normal,
              ),
            ),
          ),
          // SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Theme(
                data: new ThemeData(
                  primaryColor: Colors.black87,
                ),
                child: new TextFormField(
                  controller: _textControllers[param['key']],
                  focusNode: _focusNodes[param['key']],
                  style: textStyle1(11, Colors.black, FontWeight.normal),
                  onChanged: (val) {
                    if (data[param['key']] == null)
                      data[param['key']] = {
                        "title": param["title"],
                        "value": "",
                        "key": param['key']
                      };
                    data[param['key']]["value"] =
                        _textControllers[param['key']].text;

                    // print("nrep: ${NewProductProvider.specifications}");
                  },
                  decoration: textFormFieldInputDecorator(
                      "Text Here", "Enter Text Here"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> getKeys(Map<String, dynamic> map) {
    List<String> keys = [];
    if (map == null) return [];
    map.forEach((key, value) {
      keys.add(key.toString());
    });
    return keys;
  }
}
