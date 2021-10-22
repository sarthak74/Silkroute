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
import 'package:silkroute/view/widget/text_field.dart';
import 'package:silkroute/view/widget/topbar.dart';
import 'package:silkroute/view/widget2/footer.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

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

                                    FinalPrice(),

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
  List s = ["Fabric", "Length", "Weight", "Min Order Quotient"];
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

  bool validateForm() {
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

    print("texts and images validated");

    return validateSpecs();
  }

  void uploadHandler() async {
    if (validateForm()) {
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
        await UploadImageApi().uploadImage(NewProductProvider.images[i], name);
        setState(() {
          _imageCounter = _imageCounter + 1;
        });
      }
      for (int i = 0; i < NewProductProvider.colors.length; i++) {
        String name = (id + "-color-" + i.toString()).toString();
        print("uploading color image ${NewProductProvider.colors[i]}");
        await UploadImageApi().uploadImage(NewProductProvider.colors[i], name);
        setState(() {
          _imageCounter = _imageCounter + 1;
        });
      }
      setState(() {
        _uploadingImage = false;
      });
      print("\nupdated\n");
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
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                    children: [
                      if (less)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Half set Price",
                              style: textStyle(13, Colors.black87),
                            ),
                            Text(halfSetPrice,
                                style: textStyle(13, Colors.black87)),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Full Set Price",
                            style: textStyle(13, Colors.black87),
                          ),
                          Text(fullSetPrice,
                              style: textStyle(13, Colors.black87)),
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
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
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
                                      decoration: new InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                        ),
                                        contentPadding:
                                            new EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                          vertical: 10,
                                        ),
                                        labelText: "Text Here",
                                        hintText: "Enter Text Here",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black54,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                        ),
                                        labelStyle:
                                            textStyle(13, Colors.black54),
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

      NewProductProvider.min = (NewProductProvider.setSize / 2).floor();
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
                Text(
                  "Select Min Order Quantity: ",
                  style: textStyle(13, Colors.black54),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        subtract();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black87),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(
                          "-",
                          style: textStyle(15, Colors.black87),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black87),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(
                          less
                              ? ((NewProductProvider.setSize / 2).floor())
                                  .toString()
                              : NewProductProvider.setSize.toString(),
                          style: textStyle(17, Colors.black87),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        add();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black87),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(
                          "+",
                          style: textStyle(15, Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (less)
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Theme(
                          data: new ThemeData(
                            primaryColor: Colors.black87,
                          ),
                          child: new TextFormField(
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                NewProductProvider.halfSetPrice =
                                    double.parse(_halfController.text);
                              });
                            },
                            controller: _halfController,
                            decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: new BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              contentPadding: new EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              labelText: "Half set price",
                              hintText: "Enter price of half set",
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                  color: Colors.black54,
                                  width: 2,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
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
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.black87,
                        ),
                        child: new TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              NewProductProvider.fullSetPrice =
                                  double.parse(_fullController.text);
                            });
                          },
                          controller: _fullController,
                          decoration: new InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            contentPadding: new EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            labelText: "Full set price",
                            hintText: "Enter price of half set",
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                color: Colors.black54,
                                width: 2,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
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
                    border: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: new EdgeInsets.symmetric(
                      horizontal: 20.0,
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
                    ),
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
                          contentPadding: new EdgeInsets.symmetric(
                            horizontal: 20.0,
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
                          contentPadding: new EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          labelText: "Stock Availability",
                          hintText: "Sets Available in Stock",
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
    final image = await _picker.pickImage(source: ImageSource.gallery);

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
      margin: EdgeInsets.symmetric(vertical: 10),
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
                        Icons.file_upload,
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
