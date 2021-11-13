import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/MerchantApi.dart';
import 'package:silkroute/model/services/uploadImageApi.dart';
import 'package:silkroute/provider/NewProductProvider.dart';
import 'package:silkroute/view/pages/merchant/merchant_home.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
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
    labelStyle: textStyle(11, Colors.black54),
    hintStyle: textStyle1(11, Colors.black54, FontWeight.w300),
  );
}

class AddNewProductPage extends StatefulWidget {
  const AddNewProductPage({Key key}) : super(key: key);
  @override
  _AddNewProductPageState createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {
  LocalStorage storage = LocalStorage('silkroute');
  bool loading = true;

  void loadVars() {
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
                                    // MAIN IMAGES SECTION
                                    UploadProductImages(),
                                    SizedBox(height: 20),

                                    //////// PRODUCT INFO

                                    ProductInfo(),
                                    SizedBox(height: 20),

                                    ///// Different Color images of PRODUCT

                                    ((NewProductProvider.setSize != null) &&
                                            (NewProductProvider.setSize > 0))
                                        ? DifferentColorImage()
                                        : Container(),

                                    SizedBox(height: 20),

                                    //// MIN ORDER AMOUNT and PRICE

                                    if ((NewProductProvider.setSize != null) &&
                                        (NewProductProvider.setSize >= 4) &&
                                        (NewProductProvider.setSize <= 24))
                                      MinOrderAmountAndPrice(),

                                    SizedBox(height: 20),

                                    //// Specifications

                                    Specifications(),

                                    SizedBox(height: 20),

                                    //// Final Price

                                    // FinalPrice(),

                                    //// UPLOAD BUTTON

                                    UploadButton(),
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
  List s = ["Fabric", "Length", "Breadth", "Weight", "Min Order Quotient"];
  bool _agree1 = false, _agree2 = false;
  int _imageCounter = 0;
  bool _uploadingImage = false;
  bool validateSpecs() {
    for (int i = 0; i < s.length; i++) {
      if (NewProductProvider.specifications[i]["value"].length == 0) {
        Toast().notifyErr("Invalid ${s[i]} in Specifications");
        return false;
      }
    }
    if (NewProductProvider.specifications[0]["value"] == null ||
        NewProductProvider.specifications[0]["value"].length == 0) {
      Toast().notifyErr("Select at least one Type in");
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
                            "I agree that product is NOT already uploaded.",
                            style:
                                textStyle1(13, Colors.black, FontWeight.w500),
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
                                textStyle1(13, Colors.black, FontWeight.w500),
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
                          style: textStyle(15, Colors.white),
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
        "-->\nimages-\n${NewProductProvider.images}\ncolors\n${NewProductProvider.colors}\n");
    if (NewProductProvider.title.length == 0) {
      Toast().notifyErr("Invalid Title");
      return false;
    }
    if (NewProductProvider.category.length == 0) {
      Toast().notifyErr("Invalid Category");
      return false;
    }
    if (NewProductProvider.setSize < 4 || NewProductProvider.setSize > 24) {
      Toast().notifyErr("Invalid Set Size");
      return false;
    }
    if (NewProductProvider.description.length == 0) {
      Toast().notifyErr("Invalid Description");
      return false;
    }
    if (NewProductProvider.images.contains(null) ||
        NewProductProvider.images.length < 4) {
      Toast().notifyErr("Choose all main images");
      return false;
    }
    if (NewProductProvider.colors.contains(null) ||
        NewProductProvider.colors.length < NewProductProvider.setSize) {
      Toast().notifyErr("Choose all set images");
      return false;
    }
    if (NewProductProvider.stockAvailability == 0) {
      Toast().notifyErr("Invalid Stock Availability");
      return false;
    }
    if (NewProductProvider.min != NewProductProvider.setSize &&
        NewProductProvider.min != (NewProductProvider.setSize / 2).floor()) {
      Toast().notifyErr("Invalid Minimum Order");
      return false;
    }

    if (NewProductProvider.min == (NewProductProvider.setSize / 2).floor()) {
      if (NewProductProvider.halfSetPrice == 0.0) {
        Toast().notifyErr("Invalid Half Set Price");
        return false;
      }
    }

    if (NewProductProvider.fullSetPrice == 0.0) {
      Toast().notifyErr("Invalid Full Set Price");
      return false;
    }

    for (var d in ['L', 'B', 'H']) {
      if (NewProductProvider.fullSetSize[d] < 0.5) {
        Toast().notifyErr("Invalid Full Set $d");
        return false;
      }
      if (NewProductProvider.halfSetSize[d] < 0.5) {
        Toast().notifyErr("Invalid Half Set $d");
        return false;
      }
    }

    print("texts and images validated");

    return validateSpecs();
  }

  void uploadHandler() async {
    var isValid = await validateForm();
    if (isValid) {
      if (_agree1 && _agree2) {
        Map<String, dynamic> data = {
          "title": NewProductProvider.title,
          "category": NewProductProvider.category,
          "subCat": NewProductProvider.specifications[0]["value"],
          "mrp": NewProductProvider.fullSetPrice,
          'discount': false,
          'discountValue': 0,
          'userContact': storage.getItem("contact"),
          'description': NewProductProvider.description,
          'setSize': NewProductProvider.setSize,
          'min': NewProductProvider.min,
          'stockAvailability': NewProductProvider.stockAvailability,
          'resellerCrateAvailability': 0,
          // 'images': NewProductProvider.images,
          'halfSetPrice': NewProductProvider.halfSetPrice,
          'fullSetPrice': NewProductProvider.fullSetPrice,
          'halfSetSize': NewProductProvider.halfSetPrice,
          'fullSetSize': NewProductProvider.halfSetSize,
          // 'colors': NewProductProvider.colors,
          'specifications': NewProductProvider.specifications.sublist(1, 5),
        };
        print("newP-> $data");
        var id = await MerchantApi().addNewProduct(data);
        id = id.toString();
        print("uploaded: $id");

        setState(() {
          _uploadingImage = true;
          _imageCounter = 0;
        });
        for (int i = 0; i < NewProductProvider.images.length; i++) {
          print("uploading main image ${NewProductProvider.images[i]}");
          String name = (id + "-main-" + i.toString()).toString();
          await UploadImageApi()
              .uploadImage(NewProductProvider.images[i], name);
          setState(() {
            _imageCounter = _imageCounter + 1;
          });
        }
        for (int i = 0; i < NewProductProvider.colors.length; i++) {
          String name = (id + "-color-" + i.toString()).toString();
          print("uploading color image ${NewProductProvider.colors[i]}");
          await UploadImageApi()
              .uploadImage(NewProductProvider.colors[i], name);
          setState(() {
            _imageCounter = _imageCounter + 1;
          });
        }
        setState(() {
          _uploadingImage = false;
        });
        print("\nupdated\n");
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
                        (NewProductProvider.setSize +
                                NewProductProvider.images.length)
                            .toString(),
                    style: textStyle(13, Colors.black54),
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
                      fontWeight: FontWeight.w500,
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
      less = (NewProductProvider.min < NewProductProvider.setSize);
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
                        style: textStyle(18, Color(0xFF5B0D1B))),
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
                            style: textStyle(10, Colors.black54)),
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
                              style: textStyle(13, Colors.black87),
                            ),
                            Text(
                              halfSetPrice,
                              style: textStyle(13, Colors.black87),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Full Set Price",
                            style: textStyle(13, Colors.black87),
                          ),
                          Text(
                            fullSetPrice,
                            style: textStyle(13, Colors.black87),
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
  List _specs = [];
  List<String> _typeData = [], _categories = [];
  String _category;
  List<TextEditingController> _textControllers = new List();
  AnimationController _controller;
  Animation _animation;

  List<FocusNode> _focusNodes = new List();

  void loadVars() {
    setState(() {
      _category = NewProductProvider.category;
      Set<String> _data = {};
      for (var x in MerchantHome.categoriess) {
        _categories.add(x["title"]);
        for (var y in x["subCat"]) {
          _data.add(y["title"]);
        }
      }
      if (_category.length == 0) {
        _category = _categories[0];
        NewProductProvider.category = _category;
      }
      for (var x in _data) {
        _typeData.add(x);
      }

      for (var x in NewProductProvider.specifications) {
        _specs.add(x);
      }

      print("specs: $_specs ${NewProductProvider.specifications}");

      if (_specs.length == 0) {
        _specs = [
          {
            "title": "Fabric",
            "value": "",
          },
          {
            "title": "Length",
            "value": "",
          },
          {
            "title": "xyz",
            "value": "",
          },
          {
            "title": "Weight",
            "value": "",
          },
          {
            "title": "Min Order Quotient",
            "value": "",
          }
        ];

        NewProductProvider.specifications.add({"title": "Type", "value": []});
        for (var x in _specs) {
          NewProductProvider.specifications.add(x);
        }

        // print("specs2: $_specs ${NewProductProvider.specifications}");
      } else {
        _specs.removeAt(0);
        // print("specs3: $_specs");
      }

      _controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: 300));
      _animation = Tween(begin: 20.0, end: 0.0).animate(_controller)
        ..addListener(() {
          setState(() {});
        });

      for (int i = 0; i < _specs.length; i++) {
        _focusNodes.add(FocusNode());
        _focusNodes[i].addListener(() {
          if (_focusNodes[i].hasFocus) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        });
      }

      loading = false;
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
    _controller.dispose();
    for (int i = 0; i < _textControllers.length; i++) {
      _textControllers[i].dispose();
    }

    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].dispose();
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
                Text(
                  "Specifications",
                  style: textStyle(18, Color(0xFF5B0D1B)),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.grey[200],
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                      vertical: _animation.value,
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Category",
                            style: textStyle(13, Colors.black),
                          ),
                          DropdownButton<String>(
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.black,
                            ),
                            items: _categories.map((String e) {
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                print("object $val");
                                _category = val;
                                NewProductProvider.category = _category;
                              });
                            },
                            value: _category,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Type",
                          style: textStyle(13, Colors.black),
                        ),
                      ),
                      SizedBox(height: 10),
                      MultiSelectDialogField(
                        selectedItemsTextStyle: textStyle(13, Colors.white),
                        searchTextStyle: textStyle(13, Colors.black),
                        items: _typeData
                            .map((e) => MultiSelectItem(e, e))
                            .toList(),
                        listType: MultiSelectListType.CHIP,
                        selectedColor: Color(0xFF5B0D1B),
                        searchable: true,
                        decoration: BoxDecoration(
                          color: Color(0xFF5B0D1B).withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          border: Border.all(
                            color: Color(0xFF5B0D1B),
                            width: 2,
                          ),
                        ),
                        onConfirm: (values) {
                          setState(() {
                            print("values $values");
                            NewProductProvider.specifications[0]["value"] =
                                values;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _specs.length,
                        itemBuilder: (BuildContext context, int i) {
                          _textControllers.add(new TextEditingController());
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                _specs[i]["title"],
                                style: textStyle(13, Colors.black),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  child: Theme(
                                    data: new ThemeData(
                                      primaryColor: Colors.black87,
                                    ),
                                    child: new TextFormField(
                                      controller: _textControllers[i],
                                      focusNode: _focusNodes[i],
                                      style: textStyle1(
                                          13, Colors.black, FontWeight.w500),
                                      onChanged: (val) {
                                        setState(() {
                                          _specs[i]["value"] =
                                              _textControllers[i].text;
                                          NewProductProvider
                                                      .specifications[i + 1]
                                                  ["value"] =
                                              _textControllers[i].text;
                                          print(
                                              "nrep: ${NewProductProvider.specifications}");
                                        });
                                      },
                                      decoration: textFormFieldInputDecorator(
                                          "Text Here", "Enter Text Here"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
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
  bool less = false;
  bool loading = true;
  TextEditingController _halfController = new TextEditingController();
  TextEditingController _fullController = new TextEditingController();
  TextEditingController _halfWtController = new TextEditingController();
  TextEditingController _fullWtController = new TextEditingController();

  void loadVars() {
    setState(() {
      // _counter = NewProductProvider.setSize;
      _halfController.text = NewProductProvider.halfSetPrice.toString();
      _fullController.text = NewProductProvider.fullSetPrice.toString();
      loading = false;
    });
  }

  void add() {
    setState(() {
      less = false;
      NewProductProvider.min = NewProductProvider.setSize;
      print("min: ${NewProductProvider.min}");
    });
  }

  void subtract() {
    setState(() {
      less = true;

      NewProductProvider.min = (NewProductProvider.setSize / 2).ceil();
      print("min: ${NewProductProvider.min}");
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
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Text(
                      "Want to sell Half set?",
                      style: textStyle1(13, Colors.black54, FontWeight.w500),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          less = !less;
                          less ? subtract() : add();
                        });
                      },
                      child: !less
                          ? Icon(Icons.check_box_outline_blank)
                          : Icon(Icons.check_box),
                    ),
                    SizedBox(width: 10),
                    less
                        ? Text(
                            "(${NewProductProvider.min} units)",
                            style:
                                textStyle1(13, Colors.black54, FontWeight.w500),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: <Widget>[
                    if (less)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Theme(
                              data: new ThemeData(
                                primaryColor: Colors.black87,
                              ),
                              child: new TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                style: textStyle1(
                                    15, Colors.black, FontWeight.w500),
                                onChanged: (val) {
                                  if (_halfController.text.length > 0) {
                                    setState(() {
                                      NewProductProvider.halfSetPrice =
                                          double.parse(_halfController.text);
                                    });
                                  } else {
                                    setState(() {
                                      NewProductProvider.halfSetPrice = 0.0;
                                    });
                                  }
                                },
                                controller: _fullController,
                                decoration: textFormFieldInputDecorator(
                                    "Half set price", "Rupee (₹)"),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Size: ",
                            style:
                                textStyle1(13, Colors.black87, FontWeight.w500),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.13,
                            child: Theme(
                              data: new ThemeData(
                                primaryColor: Colors.black87,
                              ),
                              child: new TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                style: textStyle1(
                                    15, Colors.black, FontWeight.w500),
                                onChanged: (val) {
                                  print("val L: $val");
                                  if (val.length > 0) {
                                    setState(() {
                                      NewProductProvider.halfSetSize['L'] =
                                          double.parse(val);
                                    });
                                  } else {
                                    setState(() {
                                      NewProductProvider.halfSetSize['L'] = 0.0;
                                    });
                                  }
                                },
                                decoration: textFormFieldInputDecorator(
                                    "L", "cm",
                                    hpadding: 15),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.13,
                            child: Theme(
                              data: new ThemeData(
                                primaryColor: Colors.black87,
                              ),
                              child: new TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                style: textStyle1(
                                    15, Colors.black, FontWeight.w500),
                                onChanged: (val) {
                                  print("val B: $val");
                                  if (val.length > 0) {
                                    setState(() {
                                      NewProductProvider.halfSetSize['B'] =
                                          double.parse(val);
                                    });
                                  } else {
                                    setState(() {
                                      NewProductProvider.halfSetSize['B'] = 0.0;
                                    });
                                  }
                                },
                                decoration: textFormFieldInputDecorator(
                                    "B", "cm",
                                    hpadding: 15),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.13,
                            child: Theme(
                              data: new ThemeData(
                                primaryColor: Colors.black87,
                              ),
                              child: new TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                style: textStyle1(
                                    15, Colors.black, FontWeight.w500),
                                onChanged: (val) {
                                  print("val H: $val");
                                  if (val.length > 0) {
                                    setState(() {
                                      NewProductProvider.halfSetSize['H'] =
                                          double.parse(val);
                                    });
                                  } else {
                                    setState(() {
                                      NewProductProvider.halfSetSize['H'] = 0.0;
                                    });
                                  }
                                },
                                decoration: textFormFieldInputDecorator(
                                    "H", "cm",
                                    hpadding: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Theme(
                            data: new ThemeData(
                              primaryColor: Colors.black87,
                            ),
                            child: new TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              style:
                                  textStyle1(15, Colors.black, FontWeight.w500),
                              onChanged: (val) {
                                if (_fullController.text.length > 0) {
                                  setState(() {
                                    NewProductProvider.fullSetPrice =
                                        double.parse(_fullController.text);
                                  });
                                } else {
                                  setState(() {
                                    NewProductProvider.fullSetPrice = 0.0;
                                  });
                                }
                              },
                              controller: _fullController,
                              decoration: textFormFieldInputDecorator(
                                  "Full set price", "Rupee (₹)"),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Size: ",
                          style:
                              textStyle1(13, Colors.black87, FontWeight.w500),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.13,
                          child: Theme(
                            data: new ThemeData(
                              primaryColor: Colors.black87,
                            ),
                            child: new TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              style:
                                  textStyle1(15, Colors.black, FontWeight.w500),
                              onChanged: (val) {
                                print("val L: $val");
                                if (val.length > 0) {
                                  setState(() {
                                    NewProductProvider.fullSetSize['L'] =
                                        double.parse(val);
                                  });
                                } else {
                                  setState(() {
                                    NewProductProvider.fullSetSize['L'] = 0.0;
                                  });
                                }
                              },
                              decoration: textFormFieldInputDecorator("L", "cm",
                                  hpadding: 15),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.13,
                          child: Theme(
                            data: new ThemeData(
                              primaryColor: Colors.black87,
                            ),
                            child: new TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              style:
                                  textStyle1(15, Colors.black, FontWeight.w500),
                              onChanged: (val) {
                                print("val B: $val");
                                if (val.length > 0) {
                                  setState(() {
                                    NewProductProvider.fullSetSize['B'] =
                                        double.parse(val);
                                  });
                                } else {
                                  setState(() {
                                    NewProductProvider.fullSetSize['B'] = 0.0;
                                  });
                                }
                              },
                              decoration: textFormFieldInputDecorator("B", "cm",
                                  hpadding: 15),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.13,
                          child: Theme(
                            data: new ThemeData(
                              primaryColor: Colors.black87,
                            ),
                            child: new TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              style:
                                  textStyle1(15, Colors.black, FontWeight.w500),
                              onChanged: (val) {
                                print("val H: $val");
                                if (val.length > 0) {
                                  setState(() {
                                    NewProductProvider.fullSetSize['H'] =
                                        double.parse(val);
                                  });
                                } else {
                                  setState(() {
                                    NewProductProvider.fullSetSize['H'] = 0.0;
                                  });
                                }
                              },
                              decoration: textFormFieldInputDecorator("H", "cm",
                                  hpadding: 15),
                            ),
                          ),
                        ),
                      ],
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

  void loadVars() {
    setState(() {
      loading = false;
    });
  }

  pickImage(index) async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      NewProductProvider.colors[index] = File(image.path);
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
                  "Choose pictures of ${NewProductProvider.setSize} colors:",
                  style: textStyle(13, Colors.black54),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.05,
                child: ListView.builder(
                  itemCount: NewProductProvider.colors.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        pickImage(index);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.width * 0.03,
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              width: (_selected == index) ? 2 : 0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: (NewProductProvider.colors[index] == null)
                            ? FittedBox(
                                child: Icon(
                                  Icons.file_upload,
                                  color: Colors.grey[800],
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(
                                        NewProductProvider.colors[index].path)),
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
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _setSizeController = TextEditingController();
  TextEditingController _stockAvailabilityController = TextEditingController();
  Timer _debounce;

  void loadVars() {
    setState(() {
      _titleController.text = NewProductProvider.title;
      _descController.text = NewProductProvider.description;
      _setSizeController.text = NewProductProvider.setSize.toString();
      _stockAvailabilityController.text =
          NewProductProvider.stockAvailability.toString();
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
              Theme(
                data: new ThemeData(
                  primaryColor: Colors.black87,
                ),
                child: new TextFormField(
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      NewProductProvider.title = _titleController.text;
                    });
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
                    labelStyle: textStyle(13, Colors.black54),
                    hintStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // DESCRIPTION

              Theme(
                data: new ThemeData(
                  primaryColor: Colors.black87,
                ),
                child: new TextFormField(
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      NewProductProvider.description = _descController.text;
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
                    labelStyle: textStyle(13, Colors.black54),
                    hintStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // SET SIZE

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Theme(
                      data: new ThemeData(
                        primaryColor: Colors.black87,
                      ),
                      child: new TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            if (_setSizeController.text.length > 0) {
                              NewProductProvider.setSize =
                                  int.parse(_setSizeController.text);
                              if (NewProductProvider.setSize > 24) {
                                NewProductProvider.setSize = 24;
                                _setSizeController.text = "24";
                              }

                              NewProductProvider.min =
                                  NewProductProvider.setSize;

                              NewProductProvider.colors = [];
                              for (int i = 0;
                                  i < NewProductProvider.setSize;
                                  i++) {
                                NewProductProvider.colors.add(null);
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
                          labelText: "Set Size",
                          hintText: "Set Size",
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black54,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelStyle: textStyle(13, Colors.black54),
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Theme(
                      data: new ThemeData(
                        primaryColor: Colors.black87,
                      ),
                      child: new TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            if (_stockAvailabilityController.text.length > 0) {
                              NewProductProvider.stockAvailability =
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
                          labelText: "Sets in stock",
                          hintText: "No. of sets available",
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black54,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelStyle: textStyle(13, Colors.black54),
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
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

  pickImage(index) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    final bytes = await image.length();
    final kb = bytes / 1024;
    print("kb: $kb");
    // final mb = kb / 1024;

    setState(() {
      _image[index] = File(image.path);
      _selected = index;
      NewProductProvider.images = _image;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 300,
      alignment: Alignment.topCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
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
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              width: (_selected == index) ? 2 : 0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: (_image[index] == null)
                            ? FittedBox(
                                child: Icon(
                                  Icons.file_upload,
                                  color: Colors.black38,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(_image[index].path)),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    if (index < 3) SizedBox(height: 13)
                  ],
                );
              },
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: null, // todo: zoom
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black54),
              ),
              child: (_image[_selected] == null)
                  ? FittedBox(
                      child: Icon(
                        Icons.image,
                        color: Colors.black38,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(_image[_selected].path)),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
