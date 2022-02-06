import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:silkroute/methods/checkAccountDetails.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/MerchantApi.dart';
import 'package:silkroute/model/services/aws.dart';
import 'package:silkroute/model/services/uploadImageApi.dart';
import 'package:silkroute/provider/NewProductProvider1.dart';
import 'package:silkroute/view/dialogBoxes/editAccountDetailsBottomsheet.dart';
import 'package:silkroute/view/pages/merchant/merchant_home.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/customBottomSheet.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/show_dialog.dart';
import 'package:silkroute/view/widget/text_field.dart';
import 'package:silkroute/view/widget/topbar.dart';
import 'package:silkroute/view/widget2/footer.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

InputDecoration textFormFieldInputDecorator(String labelText, String hintText,
    {double hpadding = 20}) {
  return new InputDecoration(
    border: OutlineInputBorder(
      borderSide: new BorderSide(
        color: Colors.black,
      ),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    isDense: true,
    contentPadding: new EdgeInsets.symmetric(
      horizontal: hpadding,
      vertical: 8,
    ),
    labelText: labelText,
    hintText: hintText,
    focusedBorder: OutlineInputBorder(
      borderSide: new BorderSide(
        color: Colors.black54,
        width: 2,
      ),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    labelStyle: textStyle1(11, Colors.black54, FontWeight.normal),
    hintStyle: textStyle1(11, Colors.black54, FontWeight.w300),
  );
}

class Temp extends StatefulWidget {
  const Temp({Key key}) : super(key: key);
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  LocalStorage storage = LocalStorage('silkroute');
  bool loading = true;

  void loadVars() async {
    var res = await AccountDetails().check(context);
    if (res == false) {
      setState(() {
        loading = false;
      });
      await CustomBottomSheet().show(context, EditAccountDetailsBottomSheet());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Navbar(),
        primary: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/1.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: <Widget>[
              //////////////////////////////
              ///                        ///
              ///         TopBar         ///
              ///                        ///
              //////////////////////////////

              TopBar(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),

              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    color: Colors.white,
                  ),
                  child: CustomScrollView(slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        loading
                            ? Text("Loading")
                            : SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Temp(),
                                    // SizedBox(height: 20),

                                    // MAIN IMAGES SECTION
                                    UploadProductImages(),
                                    SizedBox(height: 5),

                                    //////// PRODUCT INFO

                                    ProductInfo(),
                                    SizedBox(height: 15),

                                    ///// Different Color images of PRODUCT

                                    ((NewProductProvider1.setSize != null) &&
                                            (NewProductProvider1.setSize > 0))
                                        ? DifferentColorImage()
                                        : Container(),

                                    SizedBox(height: 5),

                                    //// MIN ORDER AMOUNT and PRICE

                                    if ((NewProductProvider1.setSize != null) &&
                                        (NewProductProvider1.setSize >= 4) &&
                                        (NewProductProvider1.setSize <= 24))
                                      MinOrderAmountAndPrice(),

                                    SizedBox(height: 5),

                                    //// Specifications

                                    Specifications(),

                                    SizedBox(height: 5),

                                    //// Final Price

                                    // FinalPrice(),

                                    //// UPLOAD BUTTON

                                    UploadButton(),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom))
                                  ],
                                ),
                              ),
                      ]),
                    ),
                    SliverFillRemaining(
                        hasScrollBody: false, child: Container()),
                  ]),
                ),
              ),

              //////////////////////////////
              ///                        ///
              ///         Footer         ///
              ///                        ///
              //////////////////////////////
              Footer(),
            ],
          ),
        ),
        // bottomNavigationBar: Footer(),
      ),
    );
  }
}

class UploadButton extends StatefulWidget {
  const UploadButton({Key key}) : super(key: key);

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  LocalStorage storage = LocalStorage('silkroute');
  Map<String, dynamic> s = {};
  bool _agree1 = false, _agree2 = false;
  int _imageCounter = 0;
  bool _uploadingImage = false;

  loadparameters() async {
    for (dynamic x in MerchantHome.categoriess) {
      if (x == NewProductProvider1.category) {
        s = x["parameters"];
        break;
      }
    }
  }

  Future<bool> validateSpecs() async {
    await loadparameters();
    var keys = Helpers().getKeys(s);
    NewProductProvider1.specifications =
        NewProductProvider1.specifications[NewProductProvider1.category];
    for (int i = 0; i < keys.length; i++) {
      if (NewProductProvider1.specifications[keys[i]]["value"].length == 0) {
        Toast().notifyErr(
            "Invalid ${NewProductProvider1.specifications[keys[i]]["title"]} in Specifications");
        return false;
      }
    }
    if (NewProductProvider1.subCat == null ||
        NewProductProvider1.subCat.length == 0) {
      Toast().notifyErr("Select at least one Tag");
    }
    print("Specs validated");
    return true;
  }

  Future<bool> validateForm() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 16,
              content: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.height * 0.9,
                // padding: EdgeInsets.symmetric(
                //     horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            "I agree that product is NOT already uploaded. If uploaded, then you can increase stock by updating the product!",
                            style:
                                textStyle1(13, Colors.black, FontWeight.normal),
                          ),
                          // Text("All the info is correct and sufficient quatity is available."),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _agree1 = !_agree1;
                              });
                            },
                            child: Icon(
                              !_agree1
                                  ? Icons.check_box_outline_blank
                                  : Icons.check_box,
                              size: 25,
                            ),
                          ),
                          // Text("All the info is correct and sufficient quatity is available."),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            "All the info is correct and sufficient quatity is available.",
                            style:
                                textStyle1(13, Colors.black, FontWeight.normal),
                          ),
                          // Text("All the info is correct and sufficient quatity is available."),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _agree2 = !_agree2;
                              });
                            },
                            child: Icon(
                              !_agree2
                                  ? Icons.check_box_outline_blank
                                  : Icons.check_box,
                              size: 25,
                            ),
                          ),
                          // Text("All the info is correct and sufficient quatity is available."),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (_agree1 && _agree2) {
                          Navigator.pop(context);
                        } else {
                          Toast().notifyErr("Check agreement");
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                        decoration: BoxDecoration(
                          color: Color(0xFF5B0D1B),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Text(
                          "Confirm",
                          style:
                              textStyle1(15, Colors.white, FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    print(
        "-->\nimages-\n${NewProductProvider1.images}\ncolors\n${NewProductProvider1.colors}\n");

    if (NewProductProvider1.reference.length == 0) {
      Toast().notifyErr("Invalid Reference ID");
      return false;
    }
    if (NewProductProvider1.title.length == 0) {
      Toast().notifyErr("Invalid Title");
      return false;
    }
    if (NewProductProvider1.category.length == 0) {
      Toast().notifyErr("Invalid Category");
      return false;
    }
    if (NewProductProvider1.setSize < 4 || NewProductProvider1.setSize > 24) {
      Toast().notifyErr("Invalid Number of Colors");
      return false;
    }
    if (NewProductProvider1.description.length == 0) {
      Toast().notifyErr("Invalid Description");
      return false;
    }
    if (NewProductProvider1.images.contains(null) ||
        NewProductProvider1.images.length < 4) {
      Toast().notifyErr("Choose all main images");
      return false;
    }
    if (NewProductProvider1.colors.contains(null) ||
        NewProductProvider1.colors.length < NewProductProvider1.setSize) {
      Toast().notifyErr("Choose all set images");
      return false;
    }
    if (NewProductProvider1.stockAvailability == 0) {
      Toast().notifyErr("Invalid Stock Availability");
      return false;
    }
    if (NewProductProvider1.min > NewProductProvider1.setSize ||
        NewProductProvider1.min <= 0) {
      Toast().notifyErr("Invalid Set Size");
      return false;
    }

    for (var d in ['L', 'B', 'H']) {
      if (NewProductProvider1.fullSetSize[d] < 1) {
        Toast().notifyErr("Invalid Set $d");
        return false;
      }
    }

    print("texts and images validated");

    return await validateSpecs();
  }

  void uploadHandler() async {
    var accountCheck = await AccountDetails().check(context);
    if (accountCheck == false) {
      Toast().notifyErr("Account details are not added!");
      Navigator.pop(context);
      Navigator.of(context).pushNamed("/merchant_acc_details");
      return;
    }
    var isValid = await validateForm();
    if (isValid) {
      if (_agree1 && _agree2) {
        try {
          var contact = await storage.getItem('contact');
          List<String> imageUrls = [], colorUrls = [];
          var specs = [];
          print("specs: ${NewProductProvider1.specifications}");

          List<String> keys =
              Helpers().getKeys(NewProductProvider1.specifications);
          for (var x in keys) {
            specs.add({
              "title": NewProductProvider1.specifications[x]["title"],
              "value": NewProductProvider1.specifications[x]["value"]
            });
          }

          Map<String, dynamic> data = {
            "title": NewProductProvider1.title,
            "category": NewProductProvider1.category,
            "subCat": NewProductProvider1.specifications[0]["value"],
            "mrp": NewProductProvider1.fullSetPrice,
            'discount': false,
            'discountValue': 0,
            'userContact': contact,
            'description': NewProductProvider1.description,
            'totalSet': NewProductProvider1.setSize,
            'min': NewProductProvider1.min,
            'stockAvailability': NewProductProvider1.stockAvailability,
            'resellerCrateAvailability': 0,
            // 'images': NewProductProvider1.images,

            'fullSetPrice': NewProductProvider1.fullSetPrice,

            'fullSetSize': NewProductProvider1.fullSetSize,
            // 'colors': NewProductProvider1.colors,
            'specifications': specs,
          };
          print("newP-> $data");
          var addProductRes = await MerchantApi().addNewProduct(data);
          addProductRes = await jsonDecode(addProductRes);
          print("addProductRes: ${addProductRes}");
          if (addProductRes['success'] == false) {
            Toast().notifyErr(
                addProductRes['msg'] + "\nPlease retry or contact owner");
            return;
          }
          String id = addProductRes['id'].toString();
          print("uploaded: $id");

          setState(() {
            _uploadingImage = true;
            _imageCounter = 0;
          });
          for (int i = 0; i < NewProductProvider1.images.length; i++) {
            print("uploading main image ${NewProductProvider1.images[i]}");
            String ex = NewProductProvider1.images[i].absolute
                .toString()
                .split('.')
                .last
                .split("'")[0];
            String name = (id + "-main-" + i.toString() + "." + ex).toString();

            var urls =
                await AWS().uploadImage(NewProductProvider1.images[i], name);
            if (urls['success'] == false) {
              Toast().notifyErr("Error in uploading images.\nUpload again");
              await MerchantApi().deleteProduct({'_id': id});
              _uploadingImage = false;
              _imageCounter = 0;
              return;
            }
            imageUrls.add(urls['downloadUrl']);
            setState(() {
              _imageCounter = _imageCounter + 1;
            });
          }
          for (int i = 0; i < NewProductProvider1.colors.length; i++) {
            String ex = NewProductProvider1.colors[i].absolute
                .toString()
                .split('.')
                .last
                .split("'")[0];
            String name = (id + "-color-" + i.toString() + "." + ex).toString();
            print("uploading color image ${NewProductProvider1.colors[i]}");
            var urls =
                await AWS().uploadImage(NewProductProvider1.colors[i], name);
            if (urls['success'] == false) {
              Toast().notifyErr("Error in uploading images.\nUpload again");
              await MerchantApi().deleteProduct({'_id': id});
              _uploadingImage = false;
              _imageCounter = 0;
              return;
            }
            colorUrls.add(urls['downloadUrl']);

            setState(() {
              _imageCounter = _imageCounter + 1;
            });
          }
          setState(() {
            _uploadingImage = false;
          });
          var body = {
            'qry': {"_id": id},
            'updates': {'images': imageUrls, 'colors': colorUrls}
          };
          var res = await MerchantApi().updateProduct(body);
          if (res["success"] == true) {
            Toast().notifySuccess("Product Uploaded Successfully");
          } else {
            Toast().notifyErr("Some error occurred");
          }
          Navigator.of(context).pushNamed('/merchant_home');
          print("\nupdated\n");
        } catch (err) {
          print("err $err");
          Toast().notifyErr(
              "Error while uploading product. Upload Again.\nOr Contact Us");
          setState(() {
            _uploadingImage = false;
          });
        }
      } else {
        Toast().notifyErr("Check Agreement");
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        uploadHandler();
      },
      child: Center(
        child: Column(
          children: <Widget>[
            _uploadingImage
                ? Text(
                    "Uploading images: " +
                        _imageCounter.toString() +
                        "/" +
                        (NewProductProvider1.setSize +
                                NewProductProvider1.images.length)
                            .toString(),
                    style: textStyle1(13, Colors.black54, FontWeight.normal),
                  )
                : Container(),
            SizedBox(height: 10),
            FittedBox(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xFF5B0D1B),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: Text(
                  !_uploadingImage ? "Upload to Shop" : "Uploading...",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FinalPrice extends StatefulWidget {
  const FinalPrice({Key key}) : super(key: key);

  @override
  _FinalPriceState createState() => _FinalPriceState();
}

class _FinalPriceState extends State<FinalPrice> {
  String halfSetPrice, fullSetPrice;
  bool less = false, loading = true;
  void getPrice() {
    setState(() {
      less = (NewProductProvider1.min < NewProductProvider1.setSize);
      if (less) {
        halfSetPrice = Math().getHalfSetPrice().toString();
      }
      fullSetPrice = Math().getFullSetPrice().toString();
    });
  }

  void loadVars() {
    setState(() {
      halfSetPrice = "0.0";
      fullSetPrice = "0.0";
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text("Loading")
        : Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Final price to Customer",
                        style: textStyle1(
                            18, Color(0xFF5B0D1B), FontWeight.normal)),
                    GestureDetector(
                      onTap: () {
                        getPrice();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey[200]),
                        child: Text("Get Price",
                            style: textStyle1(
                                10, Colors.black54, FontWeight.normal)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (less)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Half set Price",
                              style: textStyle1(
                                  13, Colors.black87, FontWeight.normal),
                            ),
                            Text(
                              halfSetPrice,
                              style: textStyle1(
                                  13, Colors.black87, FontWeight.normal),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Full Set Price",
                            style: textStyle1(
                                13, Colors.black87, FontWeight.normal),
                          ),
                          Text(
                            fullSetPrice,
                            style: textStyle1(
                                13, Colors.black87, FontWeight.normal),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class Specifications extends StatefulWidget {
  const Specifications({Key key}) : super(key: key);

  @override
  _SpecificationsState createState() => _SpecificationsState();
}

class _SpecificationsState extends State<Specifications>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  dynamic _specs;
  dynamic _parameters;
  List<String> _typeData = [], _categories = [];
  String _category;

  AnimationController _controller;
  Animation _animation;

  Map<String, dynamic> finalData = {};
  Map<String, TextEditingController> _textControllers;
  List<Widget> specsWidget = [Text("")];

  Map<String, FocusNode> _focusNodes;

  bool hasSpecs = true;

  void loadVars() async {
    setState(() {
      loading = true;
    });
    _category = NewProductProvider1.category;
    Set<String> _data = {};
    List mechantHomeCategories =
        (MerchantHome.categoriess != null) ? MerchantHome.categoriess : [];
    if (MerchantHome.categoriess.length == null) {
      hasSpecs = false;
      return;
    }
    if (MerchantHome.categoriess.length == 0) {
      hasSpecs = false;
      return;
    }
    for (var x in mechantHomeCategories) {
      _categories.add(x["title"]);
      for (var y in x["subCat"]) {
        _data.add(y["title"]);
      }
      if (x["title"] == _category) {
        _parameters = x["parameters"];
      }
    }

    if (_category.length == 0) {
      _category = _categories[0];
      NewProductProvider1.category = _category;
      _parameters = mechantHomeCategories[0]["parameters"];
    }

    print("params--- $_parameters");

    // print("cat $_category");
    // print("param $_parameters");

    for (var x in _data) {
      _typeData.add(x);
    }

    // print("type $_typeData");
    if (NewProductProvider1.specifications == null)
      NewProductProvider1.specifications = {};
    if (NewProductProvider1.specifications[_category] == null)
      NewProductProvider1.specifications[_category] =
          new Map<String, dynamic>();
    _specs = NewProductProvider1.specifications[_category];

    // print("specs $_specs");

    dynamic tempSpecs = {};
    List<String> keys =
        Helpers().getKeys(NewProductProvider1.specifications[_category]) ?? [];
    for (dynamic x in keys) {
      tempSpecs[x] = NewProductProvider1.specifications[_category][x];
    }

    if ((Helpers().getKeys(_specs) ?? []).length == 0) {
      for (String x in Helpers().getKeys(_parameters)) {
        if (_specs[x] == null) _specs[x] = {};
        _specs[x] = {"title": _parameters[x]["title"], "value": ""};
        NewProductProvider1.specifications[_category]
            [x] = {"title": _parameters[x]["title"], "value": ""};
      }

      // NewProductProvider1.specifications.add({"title": "Type", "value": []});

      // print("specs2: $_specs ${NewProductProvider1.specifications}");
    }

    // print("specs $_specs");

    // print("specs ${NewProductProvider1.specifications}");

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 20.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    await buildSpecs();
    setState(() {
      loading = false;
    });
  }

  var loadingSpecs = false;

  void buildSpecs() async {
    setState(() {
      loadingSpecs = true;
    });
    for (var x in MerchantHome.categoriess) {
      if (x["title"] == _category) {
        setState(() {
          _parameters = x["parameters"];
        });

        break;
      }
    }
    if (NewProductProvider1.specifications == null)
      NewProductProvider1.specifications = {};
    if (NewProductProvider1.specifications[_category] == null)
      NewProductProvider1.specifications[_category] =
          new Map<String, dynamic>();
    print(
        "Newprod- $_category\n${NewProductProvider1.specifications[_category]}");
    specsWidget = Helpers().buildparams(
        context,
        _parameters,
        _textControllers,
        NewProductProvider1.specifications[_category],
        _focusNodes,
        buildSpecs,
        _controller);

    setState(() {
      loadingSpecs = false;
    });
  }

  void addFieldHandler() {
    var data = {"title": "Title", "value": "Text"};
    _specs.add(data);
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    var keys = Helpers().getKeys(_textControllers);
    for (int i = 0; i < keys.length; i++) {
      if (_textControllers[keys[i]] == null) continue;
      _textControllers[keys[i]].dispose();
    }
    keys = Helpers().getKeys(_focusNodes);
    for (int i = 0; i < keys.length; i++) {
      if (_focusNodes[keys[i]] == null) continue;
      _focusNodes[keys[i]].dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text("Loading")
        : Container(
            width: MediaQuery.of(context).size.width,
            // padding: EdgeInsets.symmetric(vertical: 20, horizontal: MediaQuery.of(context).size.width*0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "Details",
                    style: textStyle1(15, Color(0xFF811111), FontWeight.normal),
                  ),
                ),
                SizedBox(height: 10),
                hasSpecs
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.grey[200],
                        ),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                            vertical: _animation.value,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Category",
                                  style: textStyle1(
                                      13, Colors.black, FontWeight.normal),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: DropdownSearch<String>(
                                    mode: Mode.MENU,

                                    showSelectedItems: true,
                                    items: _categories.map((e) {
                                      return e.toString();
                                    }).toList(),
                                    // label: "Category",
                                    // selectedItem: NewProductProvider1.category,
                                    // selectedItem: pincodeAddress[0]["Name"],
                                    onChanged: (val) async {
                                      setState(() {
                                        print("object $val");
                                        _category = val;
                                        NewProductProvider1.category =
                                            _category;
                                      });
                                      await buildSpecs();
                                    },
                                    dropdownSearchBaseStyle: textStyle1(
                                      11,
                                      Colors.black,
                                      FontWeight.normal,
                                    ),
                                    dropdownButtonBuilder:
                                        (BuildContext context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width: 1,
                                              color: Colors.black12,
                                            ),
                                          ),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 15, 10),
                                        child: Icon(Icons.arrow_downward,
                                            size: 20),
                                      );
                                    },

                                    popupItemBuilder: (BuildContext context,
                                        String s, bool sel) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width: 1,
                                              color: Colors.black12,
                                            ),
                                          ),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Text(
                                          s,
                                          style: textStyle1(
                                            13,
                                            sel
                                                ? Color(0xFF811111)
                                                : Colors.black,
                                            FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    },
                                    dropdownBuilder:
                                        (BuildContext context, String val) {
                                      return Container(
                                        child: Text(
                                          ((val ?? _category) ?? "Select"),
                                          style: textStyle1(
                                            13,
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
                                        13,
                                        Colors.black,
                                        FontWeight.normal,
                                      ),
                                      hintStyle: textStyle1(
                                          13, Colors.black, FontWeight.w500),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tags:",
                                style: textStyle1(
                                    13, Colors.black, FontWeight.normal),
                              ),
                            ),
                            SizedBox(height: 10),
                            MultiSelectDialogField(
                              selectedItemsTextStyle: textStyle1(
                                  13, Colors.white, FontWeight.normal),
                              searchTextStyle: textStyle1(
                                  13, Colors.black, FontWeight.normal),
                              items: _typeData
                                  .map((e) => MultiSelectItem(e, e))
                                  .toList(),
                              listType: MultiSelectListType.CHIP,
                              selectedColor: Color(0xFF5B0D1B),
                              searchable: true,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                border: Border.all(
                                  color: Colors.black54,
                                  width: 1,
                                ),
                              ),
                              title: Text(
                                "Styles",
                                style: textStyle1(
                                  15,
                                  Colors.black,
                                  FontWeight.w500,
                                ),
                              ),
                              itemsTextStyle: textStyle1(
                                12,
                                Color(0xFF811111),
                                FontWeight.w500,
                              ),
                              buttonText: Text(
                                "Select",
                                style: textStyle1(
                                  13,
                                  Colors.black54,
                                  FontWeight.w500,
                                ),
                              ),
                              searchHint: "Style",
                              searchHintStyle: textStyle1(
                                  13, Colors.black54, FontWeight.w500),
                              onConfirm: (values) {
                                setState(() {
                                  print("values $values");
                                  NewProductProvider1.subCat = values;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            if (loadingSpecs)
                              Text("Loading")
                            else
                              Column(children: specsWidget),
                            SizedBox(height: 10),
                          ],
                        ),
                      )
                    : Text("No Specifications",
                        style: textStyle1(15, Colors.grey, FontWeight.normal)),
              ],
            ),
          );
  }
}

class MinOrderAmountAndPrice extends StatefulWidget {
  const MinOrderAmountAndPrice({Key key}) : super(key: key);

  @override
  _MinOrderAmountAndPriceState createState() => _MinOrderAmountAndPriceState();
}

class _MinOrderAmountAndPriceState extends State<MinOrderAmountAndPrice> {
  // int _counter = 0;

  bool loading = true;
  TextEditingController _halfController = new TextEditingController();
  TextEditingController _fullController = new TextEditingController();
  TextEditingController _setSizeController = new TextEditingController();
  TextEditingController _fullWtController = new TextEditingController();

  void loadVars() {
    setState(() {
      // _counter = NewProductProvider1.setSize;
      _setSizeController.text = NewProductProvider1.min.toString();
      _fullController.text = NewProductProvider1.fullSetPrice.toString();
      loading = false;
    });
  }

  @override
  void initState() {
    loadVars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text("Loading")
        : Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.black87,
                        ),
                        child: new TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          style:
                              textStyle1(15, Colors.black, FontWeight.normal),
                          onChanged: (val) {
                            if (val.length > 0) {
                              setState(() {
                                NewProductProvider1.min = int.parse(val);
                              });
                            } else {
                              setState(() {
                                NewProductProvider1.min = 0;
                              });
                            }
                          },
                          controller: _setSizeController,
                          decoration: textFormFieldInputDecorator(
                              "Set Size", "Enter set Size"),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.black87,
                        ),
                        child: new TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          style:
                              textStyle1(15, Colors.black, FontWeight.normal),
                          onChanged: (val) {
                            if (_fullController.text.length > 0) {
                              setState(() {
                                NewProductProvider1.fullSetPrice =
                                    double.parse(_fullController.text);
                              });
                            } else {
                              setState(() {
                                NewProductProvider1.fullSetPrice = 0.0;
                              });
                            }
                          },
                          controller: _fullController,
                          decoration: textFormFieldInputDecorator(
                              "Set price", "Rupee (₹)"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

class DifferentColorImage extends StatefulWidget {
  const DifferentColorImage({Key key}) : super(key: key);

  @override
  _DifferentColorImageState createState() => _DifferentColorImageState();
}

class _DifferentColorImageState extends State<DifferentColorImage> {
  int _selected = 0;
  bool loading = true;

  final _picker = ImagePicker();
  ImageSource _source;

  void loadVars() {
    setState(() {
      loading = false;
    });
  }

  pickImage(index) async {
    _source = await Helpers().getImageSource(context);
    if (_source == null) {
      Toast().notifyErr("No Source Selected!");
      return;
    }
    final image = await _picker.pickImage(source: _source);

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 3076,
      maxWidth: 3076,
    );

    var resultImage = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      image.path,
      quality: 50,
    );

    final bytes = await resultImage.length();
    final kb = bytes / 1024;
    print("kb: $kb");

    setState(() {
      NewProductProvider1.colors[index] = File(image.path);
      _selected = index;
    });
  }

  @override
  void initState() {
    loadVars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text("Loading")
        : Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Choose pictures of ${NewProductProvider1.setSize} colors:",
                  style: textStyle1(13, Colors.black54, FontWeight.normal),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.05,
                child: ListView.builder(
                  itemCount: NewProductProvider1.colors.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        pickImage(index);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.width * 0.1,
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.01),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: (_selected == index) ? 1 : 0),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: (NewProductProvider1.colors[index] == null)
                              ? Container(
                                  child: Icon(
                                    Icons.file_upload,
                                    color: Colors.grey[500],
                                    size: 22,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(File(
                                            NewProductProvider1
                                                .colors[index].path)),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}

class ProductInfo extends StatefulWidget {
  const ProductInfo({Key key}) : super(key: key);

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  bool loading = true;
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  TextEditingController _setSizeController = new TextEditingController();
  TextEditingController _stockAvailabilityController =
      new TextEditingController();
  TextEditingController _referenceController = new TextEditingController();
  Timer _debounce;

  void loadVars() {
    _referenceController.text = NewProductProvider1.reference;
    _titleController.text = NewProductProvider1.title;
    _descController.text = NewProductProvider1.description;
    _setSizeController.text = NewProductProvider1.setSize.toString();
    _stockAvailabilityController.text =
        NewProductProvider1.stockAvailability.toString();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text("Loading")
        : Column(
            children: <Widget>[
              // PRODUCT REFERENCE
              Theme(
                data: new ThemeData(
                  primaryColor: Colors.black87,
                ),
                child: new TextFormField(
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      NewProductProvider1.reference = _referenceController.text;
                    });
                  },
                  controller: _referenceController,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: new EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8,
                    ),
                    labelText: "Reference ID",
                    hintText: "Enter Reference ID",
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.black54,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelStyle:
                        textStyle1(13, Colors.black54, FontWeight.normal),
                    hintStyle: GoogleFonts.poppins(
                      textStyle: textStyle1(
                        13,
                        Colors.black54,
                        FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // PRODUCT TITLE

              Theme(
                data: new ThemeData(
                  primaryColor: Colors.black87,
                ),
                child: new TextFormField(
                  style: GoogleFonts.poppins(
                    textStyle: textStyle1(
                      13,
                      Colors.black,
                      FontWeight.normal,
                    ),
                  ),
                  onChanged: (val) {
                    if (val.length > 25) {
                      Toast().notifyErr("Character limit 25");
                      val = val.substring(0, 25);

                      _titleController.text = val;
                      _titleController.selection =
                          TextSelection.collapsed(offset: val.length);
                    } else {
                      NewProductProvider1.title = _titleController.text;
                    }
                  },
                  controller: _titleController,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: new EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8,
                    ),
                    labelText: "Product Title",
                    hintText: "Enter Product Title",
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.black54,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelStyle:
                        textStyle1(13, Colors.black54, FontWeight.normal),
                    hintStyle: GoogleFonts.poppins(
                      textStyle: textStyle1(
                        13,
                        Colors.black54,
                        FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // DESCRIPTION

              Theme(
                data: new ThemeData(
                  primaryColor: Colors.black87,
                ),
                child: new TextFormField(
                  minLines: 1,
                  maxLines: 3,
                  style: GoogleFonts.poppins(
                    textStyle: textStyle1(
                      13,
                      Colors.black,
                      FontWeight.normal,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      NewProductProvider1.description = _descController.text;
                    });
                  },
                  controller: _descController,
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: new EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8,
                    ),
                    isDense: true,
                    labelText: "Product Description",
                    hintText: "Enter Product Description",
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.black54,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelStyle:
                        textStyle1(13, Colors.black54, FontWeight.normal),
                    hintStyle: GoogleFonts.poppins(
                      textStyle: textStyle1(
                        13,
                        Colors.black54,
                        FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // SET SIZE

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Theme(
                      data: new ThemeData(
                        primaryColor: Colors.black87,
                      ),
                      child: new TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                        style: GoogleFonts.poppins(
                          textStyle: textStyle1(
                            15,
                            Colors.black,
                            FontWeight.normal,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            if (_setSizeController.text.length > 0) {
                              NewProductProvider1.setSize =
                                  int.parse(_setSizeController.text);
                              if (NewProductProvider1.setSize > 24) {
                                NewProductProvider1.setSize = 24;
                                _setSizeController.text = "24";
                              }
                              NewProductProvider1.colors = [];
                              for (int i = 0;
                                  i < NewProductProvider1.setSize;
                                  i++) {
                                NewProductProvider1.colors.add(null);
                              }
                            }
                          });
                        },
                        controller: _setSizeController,
                        decoration: new InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          isDense: true,
                          contentPadding: new EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8,
                          ),
                          labelText: "No of Colors",
                          hintText: "No of Colors",
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black54,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelStyle:
                              textStyle1(13, Colors.black54, FontWeight.normal),
                          hintStyle: GoogleFonts.poppins(
                            textStyle: textStyle1(
                              13,
                              Colors.black54,
                              FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Theme(
                      data: new ThemeData(
                        primaryColor: Colors.black87,
                      ),
                      child: new TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                        style: GoogleFonts.poppins(
                          textStyle: textStyle1(
                            15,
                            Colors.black,
                            FontWeight.normal,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            if (_stockAvailabilityController.text.length > 0) {
                              NewProductProvider1.stockAvailability =
                                  int.parse(_stockAvailabilityController.text);
                            }
                          });
                        },
                        controller: _stockAvailabilityController,
                        decoration: new InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          isDense: true,
                          contentPadding: new EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8),
                          labelText: "Stock",
                          hintText: "Available stock",
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black54,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelStyle:
                              textStyle1(13, Colors.black54, FontWeight.normal),
                          hintStyle: GoogleFonts.poppins(
                            textStyle: textStyle1(
                              13,
                              Colors.black54,
                              FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
  }
}

class UploadProductImages extends StatefulWidget {
  const UploadProductImages({Key key}) : super(key: key);

  @override
  _UploadProductImagesState createState() => _UploadProductImagesState();
}

class _UploadProductImagesState extends State<UploadProductImages> {
  int _selected = 0;

  List<File> _image = [null, null, null, null];
  final _picker = ImagePicker();
  ImageSource _source;

  pickImage(index) async {
    _source = await Helpers().getImageSource(context);
    if (_source == null) {
      Toast().notifyErr("No Source Selected!");
      return;
    }
    final image = await _picker.pickImage(source: _source);

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 3076,
      maxWidth: 3076,
    );

    var resultImage = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      image.path,
      quality: 50,
    );

    final bytes = await resultImage.length();
    final kb = bytes / 1024;
    print("kb: $kb");
    // final mb = kb / 1024;

    setState(() {
      _image[index] = File(resultImage.path);
      _selected = index;
      NewProductProvider1.images = _image;
    });
  }

  int imagePageIndex = 0;
  PageController imagePageController = new PageController();

  void onImagePageChanged(int page) {
    print("page: $page");
    setState(() {
      imagePageIndex = page;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (NewProductProvider1.images.length > 0) {
        _image = NewProductProvider1.images;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: MediaQuery.of(context).size.width -
          75 -
          MediaQuery.of(context).size.width * 0.05,
      alignment: Alignment.topCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 70,
            height: MediaQuery.of(context).size.width -
                100 -
                MediaQuery.of(context).size.width * 0.05,
            // alignment: Alignment.center,
            child: ListView.builder(
              // shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        pickImage(index);
                      },
                      child: ClipRRect(
                        // heightFactor: 1,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: (_selected == index) ? 2 : 0),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: (_image[index] == null)
                              ? Icon(
                                  Icons.file_upload,
                                  size: 40,
                                  color: Colors.black38,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          FileImage(File(_image[index].path)),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    if (index < 3)
                      SizedBox(
                          height: (MediaQuery.of(context).size.width -
                                  100 -
                                  MediaQuery.of(context).size.width * 0.05 -
                                  240) /
                              3)
                  ],
                );
              },
            ),
          ),
          // SizedBox(width: 10),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: null, // todo: zoom
                child: Container(
                  width: MediaQuery.of(context).size.width -
                      100 -
                      MediaQuery.of(context).size.width * 0.05,
                  height: MediaQuery.of(context).size.width -
                      100 -
                      MediaQuery.of(context).size.width * 0.05,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black54),
                  ),
                  child: (_image[_selected] == null)
                      ? Icon(
                          Icons.image,
                          color: Colors.black38,
                          size: 100, //aata hu 5 min
                        )
                      : PhotoViewGallery.builder(
                          scrollPhysics: const BouncingScrollPhysics(),
                          builder: (BuildContext context, int index) {
                            return PhotoViewGalleryPageOptions(
                              imageProvider: _image[index] == null
                                  ? AssetImage("assets/images/noimage.jpg")
                                  : FileImage(File(_image[index].path)),
                              initialScale: PhotoViewComputedScale.contained,

                              // heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
                            );
                          },
                          itemCount: _image.length,
                          loadingBuilder: (context, event) => Center(
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                value: event == null
                                    ? 0
                                    : event.cumulativeBytesLoaded /
                                        event.expectedTotalBytes,
                              ),
                            ),
                          ),
                          backgroundDecoration:
                              BoxDecoration(color: Colors.white),
                          pageController: imagePageController,
                          onPageChanged: onImagePageChanged,
                        ),
                ),
              ),
              Container(
                height: 21,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.circle,
                        size: (imagePageIndex == index) ? 15 : 10,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
