import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/MerchantApi.dart';
import 'package:silkroute/model/services/ResellerHomeApi.dart';
import 'package:silkroute/model/services/aws.dart';
import 'package:silkroute/model/services/uploadImageApi.dart';
import 'package:silkroute/provider/EditProductProvider.dart';
import 'package:silkroute/view/pages/merchant/merchant_home.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/my_circular_progress.dart';
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

class EditProduct extends StatefulWidget {
  const EditProduct({Key key, this.product}) : super(key: key);

  final dynamic product;

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  LocalStorage storage = LocalStorage('silkroute');
  bool loading = true;

  void loadVars() {
    setState(() {
      EditProductProvider.id = widget.product.id;
      EditProductProvider.designPrivate = widget.product.designPrivate;
      EditProductProvider.reference = widget.product.reference;
      EditProductProvider.title = widget.product.title;
      EditProductProvider.subCat = widget.product.subCat;
      EditProductProvider.category = widget.product.category;
      // EditProductProvider.specifications[0]["value"] = widget.product.subCat;
      EditProductProvider.fullSetPrice =
          double.parse(widget.product.mrp.toString());

      EditProductProvider.description = widget.product.description;
      EditProductProvider.setSize = widget.product.setSize;
      EditProductProvider.min = widget.product.min;
      EditProductProvider.stockAvailability = widget.product.stockAvailability;

      EditProductProvider.category = "";
      EditProductProvider.fullSetSize = widget.product.fullSetSize;
      EditProductProvider.editColors = widget.product.colors;
      EditProductProvider.editImages = widget.product.images;

      EditProductProvider.specifications = {};
      var specs = widget.product.specifications;
      for (var x in specs) {
        EditProductProvider.specifications[x['key']] = x;
      }

      print("ppp: ${widget.product}");
      // for (var x in widget.product.specifications) {
      //   EditProductProvider.specifications.add(x);
      // }
      // print("zz${EditProductProvider.specifications}");
      // print(
      //     "zzz: ${EditProductProvider.fullSetPrice} ${double.parse(widget.product.mrp.toString())}");
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
                                    // Temp(),
                                    // SizedBox(height: 20),

                                    // MAIN IMAGES SECTION
                                    UploadProductImages(),
                                    SizedBox(height: 5),

                                    //////// PRODUCT INFO

                                    ProductInfo(),
                                    SizedBox(height: 8),

                                    ///// Different Color images of PRODUCT

                                    ((EditProductProvider.editColors != null) &&
                                            (EditProductProvider
                                                    .editColors.length >
                                                0))
                                        ? DifferentColorImage()
                                        : Container(),

                                    //// MIN ORDER AMOUNT and PRICE

                                    if ((EditProductProvider.setSize != null) &&
                                        (EditProductProvider.setSize >= 1) &&
                                        (EditProductProvider.setSize <= 24))
                                      MinOrderAmountAndPrice(),

                                    SizedBox(height: 5),

                                    //// Specifications

                                    Specifications(),

                                    SizedBox(height: 5),

                                    //// Final Price

                                    // FinalPrice(),

                                    //// UPLOAD BUTTON

                                    UploadButton(id: widget.product.id),
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
  const UploadButton({Key key, this.id}) : super(key: key);
  final String id;
  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  LocalStorage storage = LocalStorage('silkroute');
  Map<String, dynamic> s = {};
  bool _agree1 = true, _agree2 = false;
  int _imageCounter = 0;
  bool _uploadingImage = false;

  loadparameters(cspecs) async {
    for (dynamic x in MerchantHome.categoriess) {
      print("title:: ${x['title']} ${EditProductProvider.category} \n $cspecs");
      if (x["title"] == EditProductProvider.category) {
        List<String> keys = Helpers().getKeys(x['parameters']);
        print("pre keys: ${keys}");
        for (String key in keys) {
          var param = x['parameters'][key];
          var parent = param["parent"];
          var parentVals = param["parentVals"];
          if (parentVals == null) {
            parentVals = [];
          }

          print("paren: $param\n$parent\n$parentVals");
          bool ok = true;
          for (int i = 0; i < parent.length; i++) {
            if (((cspecs[parent[i]] ?? {})["value"] ?? "").toString() !=
                parentVals[i].toString()) {
              ok = false;
              break;
            }
          }
          if (ok)
            s[key] = {
              "title": param["title"],
              "value": EditProductProvider
                  .specifications[EditProductProvider.category][key]["value"],
              "key": param["key"]
            };
        }
        break;
      }
    }
  }

  Future<bool> validateSpecs() async {
    print("validate specs\n${EditProductProvider.specifications}");
    var cspecs =
        EditProductProvider.specifications[EditProductProvider.category];
    await loadparameters(cspecs);
    var keys = Helpers().getKeys(s);
    print("valid keys $keys");
    for (int i = 0; i < s.length; i++) {
      print(
          "${keys[i]} ${cspecs[keys[i]]["title"]} ${cspecs[keys[i]]["value"]}");
      if (s[keys[i]]["value"].length == 0) {
        Toast()
            .notifyErr("Invalid ${cspecs[keys[i]]["title"]} in Specifications");
        return false;
      }
    }
    if (EditProductProvider.subCat == null ||
        EditProductProvider.subCat.length == 0) {
      Toast().notifyErr("Select at least one Tag");
      return false;
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
                height: MediaQuery.of(context).size.height * 0.2,
                // padding: EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.height * 0.9,
                // padding: EdgeInsets.symmetric(
                //     horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: <Widget>[
                    //     Container(
                    //       width: MediaQuery.of(context).size.width * 0.6,
                    //       child: Text(
                    //         "I agree that product is NOT already uploaded.",
                    //         style:
                    //             textStyle1(13, Colors.black, FontWeight.normal),
                    //       ),
                    //       // Text("All the info is correct and sufficient quatity is available."),
                    //     ),
                    //     Container(
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           setState(() {
                    //             _agree1 = !_agree1;
                    //           });
                    //         },
                    //         child: Icon(
                    //           !_agree1
                    //               ? Icons.check_box_outline_blank
                    //               : Icons.check_box,
                    //           size: 25,
                    //         ),
                    //       ),
                    //       // Text("All the info is correct and sufficient quatity is available."),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              "All the info is correct and sufficient quatity is available.",
                              style: textStyle1(
                                  13, Colors.black, FontWeight.normal),
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
                          color: Color(0xFF811111),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Text(
                          "Confirm",
                          style:
                              textStyle1(13, Colors.white, FontWeight.normal),
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
        "-->\nimages-\n${EditProductProvider.editImages}\ncolors\n${EditProductProvider.editColors}\n");
    if (EditProductProvider.title.length == 0) {
      Toast().notifyErr("Invalid Title");
      return false;
    }
    if (EditProductProvider.category.length == 0) {
      Toast().notifyErr("Invalid Category");
      return false;
    }
    if (EditProductProvider.setSize < 1 || EditProductProvider.setSize > 24) {
      Toast().notifyErr("Invalid Number of Colors");
      return false;
    }
    if (EditProductProvider.description.length == 0) {
      Toast().notifyErr("Invalid Description");
      return false;
    }
    if (EditProductProvider.editImages.contains(null) ||
        EditProductProvider.editImages.length < 4) {
      Toast().notifyErr("Choose all main images");
      return false;
    }
    if (EditProductProvider.editColors.contains(null) ||
        EditProductProvider.editColors.length < EditProductProvider.setSize) {
      Toast().notifyErr("Choose all set images");
      return false;
    }
    if (EditProductProvider.stockAvailability == 0) {
      Toast().notifyErr("Invalid Stock Availability");
      return false;
    }
    if (EditProductProvider.min > EditProductProvider.setSize ||
        EditProductProvider.min <= 0) {
      Toast().notifyErr("Invalid Set Size");
      return false;
    }

    print("texts and images validated");

    bool ok = await validateSpecs();
    if (!ok) {
      Toast().notifyErr("Something wrong in specifications");
    }

    return ok;
  }

  bool updating = false;

  void uploadHandler() async {
    setState(() {
      updating = true;
    });
    var isValid = await validateForm();
    if (isValid) {
      if (_agree1 && _agree2) {
        try {
          var contact = await storage.getItem('contact');
          List<String> imageUrls = [], colorUrls = [];

          var specs = [];
          var cat = EditProductProvider.category;
          print("specs: ${EditProductProvider.specifications[cat]}");

          List<String> keys = Helpers()
              .getKeys(s); // s contains filtered specs after validation
          for (var x in keys) {
            specs.add({
              "title": s[x]["title"],
              "value": s[x]["value"],
              "key": s[x]["key"]
            });
          }

          Map<String, dynamic> data = {
            "designPrivate": EditProductProvider.designPrivate,
            "title": EditProductProvider.title,
            "category": EditProductProvider.category,
            // "subCat": EditProductProvider.specifications[0]["value"],
            "subCat": EditProductProvider.subCat,
            "mrp": EditProductProvider.fullSetPrice,
            'discount': false,
            'discountValue': 0,
            'userContact': contact,
            'description': EditProductProvider.description,
            'totalSet': EditProductProvider.setSize,
            'min': EditProductProvider.min,
            'stockAvailability': EditProductProvider.stockAvailability,
            'resellerCrateAvailability': 0,
            // 'images': EditProductProvider.editImages,

            'fullSetPrice': EditProductProvider.fullSetPrice,

            'fullSetSize': EditProductProvider.fullSetSize,
            // 'colors': EditProductProvider.editColors,
            'specifications': specs,
          };
          print("newP-> $data");
          // var addProductRes = await MerchantApi().addNewProduct(data);
          // addProductRes = await jsonDecode(addProductRes);
          // print("addProductRes: ${addProductRes}");
          // if (addProductRes['success'] == false) {
          //   Toast().notifyErr(
          //       addProductRes['msg'] + "\nPlease retry or contact owner");
          //   return;
          // }
          // String id = addProductRes['id'].toString();
          // print("uploaded: $id");

          // setState(() {
          //   _uploadingImage = true;
          //   _imageCounter = 0;
          // });
          // for (int i = 0; i < EditProductProvider.editImages.length; i++) {
          //   print("uploading main image ${EditProductProvider.editImages[i]}");
          //   String ex = EditProductProvider.editImages[i].absolute
          //       .toString()
          //       .split('.')
          //       .last
          //       .split("'")[0];
          //   String name = (id + "-main-" + i.toString() + "." + ex).toString();

          //   var urls =
          //       await AWS().uploadImage(EditProductProvider.editImages[i], name);
          //   if (urls['success'] == false) {
          //     Toast().notifyErr("Error in uploading images.\nUpload again");
          //     await MerchantApi().deleteProduct({'_id': id});
          //     _uploadingImage = false;
          //     _imageCounter = 0;
          //     return;
          //   }
          //   imageUrls.add(urls['downloadUrl']);
          //   setState(() {
          //     _imageCounter = _imageCounter + 1;
          //   });
          // }
          // for (int i = 0; i < EditProductProvider.editColors.length; i++) {
          //   String ex = EditProductProvider.editColors[i].absolute
          //       .toString()
          //       .split('.')
          //       .last
          //       .split("'")[0];
          //   String name = (id + "-color-" + i.toString() + "." + ex).toString();
          //   print("uploading color image ${EditProductProvider.editColors[i]}");
          //   var urls =
          //       await AWS().uploadImage(EditProductProvider.editColors[i], name);
          //   if (urls['success'] == false) {
          //     Toast().notifyErr("Error in uploading images.\nUpload again");
          //     await MerchantApi().deleteProduct({'_id': id});
          //     _uploadingImage = false;
          //     _imageCounter = 0;
          //     return;
          //   }
          //   colorUrls.add(urls['downloadUrl']);

          //   setState(() {
          //     _imageCounter = _imageCounter + 1;
          //   });
          // }
          // setState(() {
          //   _uploadingImage = false;
          // });
          // var body = {
          //   'qry': {"_id": id},
          //   'updates': {'images': imageUrls, 'colors': colorUrls}
          // };
          var res = await MerchantApi().updateProduct({
            'qry': {"_id": widget.id},
            'updates': data
          });
          if (res["success"] == true) {
            Toast().notifySuccess("Product Updated Successfully");
          } else {
            Toast().notifyErr("Some error occurred");
          }
          Navigator.of(context).pushNamed('/merchant_home');
          print("\nupdated\n");
          setState(() {
            updating = false;
          });
        } catch (err) {
          print("err $err");
          Toast().notifyErr(
              "Error while uploading product. Upload Again.\nOr Contact Us");
          // setState(() {
          //   _uploadingImage = false;
          // });
          setState(() {
            updating = false;
          });
        }
      } else {
        Toast().notifyErr("Check Agreement");
        setState(() {
          updating = false;
        });
        return;
      }
    }
    setState(() {
      updating = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  bool deleting = false;

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
                        (EditProductProvider.setSize +
                                EditProductProvider.editImages.length)
                            .toString(),
                    style: textStyle1(13, Colors.black54, FontWeight.normal),
                  )
                : Container(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.fromLTRB(20, 6, 20, 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                      border: Border.all(
                        width: 2,
                        color: Color(0xff811111),
                      ),
                    ),
                    child: deleting
                        ? MyCircularProgress()
                        : Text(
                            "Delete",
                            style: textStyle1(
                              13,
                              Color(0xff811111),
                              FontWeight.w500,
                            ),
                          ),
                  ),
                  onTap: () async {
                    if (deleting) return;
                    setState(() {
                      deleting = true;
                    });
                    var want = await Helpers().getConfirmationDialog(
                        context,
                        "Delete",
                        "Are you sure you want to delete this product?");
                    if (want != true) {
                      setState(() {
                        deleting = false;
                      });
                      return;
                    }
                    var res = await MerchantApi().deleteProduct({
                      "reference": EditProductProvider.reference,
                      "_id": EditProductProvider.id
                    });
                    if (res['success'] == true) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/merchant_home',
                          ModalRoute.withName('/merchant_home'));
                    }
                    setState(() {
                      deleting = false;
                    });
                  },
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color(0xFF811111),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  child: Text(
                    // !_uploadingImage ? "Upload to Shop" : "Uploading...",
                    "Save Changes",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
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
      less = (EditProductProvider.min < EditProductProvider.setSize);
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
                            18, Color(0xFF811111), FontWeight.normal)),
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
                        child: Text(
                          "Get Price",
                          style:
                              textStyle1(10, Colors.black54, FontWeight.normal),
                        ),
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
                                  13, Colors.black54, FontWeight.normal),
                            ),
                            Text(
                              halfSetPrice,
                              style: textStyle1(
                                  13, Colors.black54, FontWeight.normal),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Full Set Price",
                            style: textStyle1(
                                13, Colors.black54, FontWeight.normal),
                          ),
                          Text(
                            fullSetPrice,
                            style: textStyle1(
                                13, Colors.black54, FontWeight.normal),
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

class PreviousSelectedTypes extends StatefulWidget {
  const PreviousSelectedTypes({Key key, this.types}) : super(key: key);
  final types;

  @override
  _PreviousSelectedTypesState createState() => _PreviousSelectedTypesState();
}

class _PreviousSelectedTypesState extends State<PreviousSelectedTypes> {
  bool loading = true;
  List<Widget> widgets = [];
  void loadVars() {
    setState(() {
      loading = true;
    });
    widgets = [];
    widget.types.forEach((type) {
      widgets.add(
        Container(
          decoration: BoxDecoration(
            color: Color(0xff811111).withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.fromLTRB(14, 7, 14, 7),
          child: Text(
            type.toString(),
            style: textStyle1(
              12,
              Color(0xff811111),
              FontWeight.normal,
            ),
          ),
        ),
      );
    });

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // loadVars();
  }

  @override
  Widget build(BuildContext context) {
    loadVars();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text("Selected Types:",
                style: textStyle1(13, Colors.black, FontWeight.normal)),
          ),
          SizedBox(height: 5),
          loading
              ? Text("Loading")
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(children: widgets),
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
  List<dynamic> subcats = [];

  void loadVars() async {
    setState(() {
      loading = true;
    });
    subcats = EditProductProvider.subCat;
    print("subcats: $subcats");
    _category = EditProductProvider.category;
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
    var tags = await ResellerHomeApi().getAllTags();
    print("tage: $tags");
    for (var y in tags) {
      _data.add(y);
    }
    for (var x in mechantHomeCategories) {
      _categories.add(x["title"]);

      if (x["title"] == _category) {
        _parameters = x["parameters"];
      }
    }
    if (_category.length == 0) {
      _category = _categories[0];
      EditProductProvider.category = _category;
      _parameters = mechantHomeCategories[0]["parameters"];
    }

    // print("cat $_category");
    // print("param $_parameters");

    for (var x in _data) {
      _typeData.add(x);
    }

    // print("type $_typeData");
    EditProductProvider.specifications = {
      _category: EditProductProvider.specifications
    };

    _specs = EditProductProvider.specifications[_category];

    // print("specs $_specs");

    dynamic tempSpecs = {};
    List<String> keys =
        Helpers().getKeys(EditProductProvider.specifications[_category]) ?? [];
    for (dynamic x in keys) {
      tempSpecs[x] = EditProductProvider.specifications[_category][x];
    }

    // print("specs $_specs");

    // print("specs ${EditProductProvider.specifications}");

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

  var loadingSpecs = true;

  void buildSpecs() async {
    setState(() {
      loadingSpecs = true;
    });
    print("Merchant home cats: ${MerchantHome.categoriess}");
    for (var x in MerchantHome.categoriess) {
      if (x["title"] == _category) {
        setState(() {
          _parameters = x["parameters"];
        });

        break;
      }
    }

    if (EditProductProvider.specifications == null)
      EditProductProvider.specifications = {};
    if (EditProductProvider.specifications[_category] == null)
      EditProductProvider.specifications[_category] =
          new Map<String, dynamic>();
    print(
        "Newprod- $_category\n${EditProductProvider.specifications[_category]}");
    specsWidget = Helpers().buildparams(
        context,
        _parameters,
        _textControllers,
        EditProductProvider.specifications[_category],
        _focusNodes,
        buildSpecs,
        _controller);

    setState(() {
      // EditProductProvider.specifications.add({"title": "Type", "value": []});
      // for (var x in _specs) {
      //   EditProductProvider.specifications.add(x);
      // }
    });

    setState(() {
      loadingSpecs = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

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
    // print("${EditProductProvider.specifications}");
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
                                  "Category: ",
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
                                    selectedItem: EditProductProvider.category,
                                    // selectedItem: pincodeAddress[0]["Name"],
                                    onChanged: (val) async {
                                      setState(() {
                                        print("object $val");
                                        _category = val;
                                        EditProductProvider.category =
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
                                      return Padding(
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
                                          (val ?? "Select"),
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
                              selectedColor: Color(0xFF811111),
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
                              initialValue: (subcats ?? []).map((e) {
                                return e.toString();
                              }).toList(),
                              onConfirm: (values) {
                                setState(() {
                                  print("values $values");
                                  EditProductProvider.subCat = values;
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
                        style: textStyle1(13, Colors.grey, FontWeight.normal)),
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
  List<TextEditingController> _dimensionsController = new List();

  void loadVars() {
    setState(() {
      // _counter = EditProductProvider.setSize;
      _setSizeController.text = EditProductProvider.min.toString();
      _fullController.text = EditProductProvider.fullSetPrice.toString();
      for (int i = 0; i < 3; i++) {
        _dimensionsController.add(new TextEditingController());
      }
      _dimensionsController[0].text =
          EditProductProvider.fullSetSize["L"].toString();
      _dimensionsController[1].text =
          EditProductProvider.fullSetSize["B"].toString();
      _dimensionsController[2].text =
          EditProductProvider.fullSetSize["H"].toString();
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.black54,
                        ),
                        child: new TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          style:
                              textStyle1(13, Colors.black, FontWeight.normal),
                          onChanged: (val) {
                            if (val.length > 0) {
                              setState(() {
                                EditProductProvider.min = int.parse(val);
                              });
                            } else {
                              setState(() {
                                EditProductProvider.min = 0;
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
                          primaryColor: Colors.black54,
                        ),
                        child: new TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          style:
                              textStyle1(13, Colors.black, FontWeight.normal),
                          onChanged: (val) {
                            if (_fullController.text.length > 0) {
                              setState(() {
                                EditProductProvider.fullSetPrice =
                                    double.parse(_fullController.text);
                              });
                            } else {
                              setState(() {
                                EditProductProvider.fullSetPrice = 0.0;
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

  void loadVars() {
    setState(() {
      loading = false;
    });
  }

  pickImage(index) async {
    return;
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
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.05,
                child: ListView.builder(
                  itemCount: EditProductProvider.editColors.length,
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
                        child: (EditProductProvider.editColors[index] == null)
                            ? FittedBox(
                                child: Icon(
                                  Icons.file_upload,
                                  color: Colors.grey[800],
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    // image: FileImage(File(
                                    //     EditProductProvider.editColors[index].path)),
                                    image: CachedNetworkImageProvider(
                                        EditProductProvider.editColors[index]
                                            .toString()),
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
  TextEditingController _noOfColorsController = TextEditingController();
  TextEditingController _stockAvailabilityController = TextEditingController();
  Timer _debounce;

  void loadVars() {
    setState(() {
      _titleController.text = EditProductProvider.title;
      _descController.text = EditProductProvider.description;
      _noOfColorsController.text =
          EditProductProvider.editColors.length.toString();
      _stockAvailabilityController.text =
          EditProductProvider.stockAvailability.toString();
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
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Theme(
                      data: new ThemeData(
                        primaryColor: Colors.black54,
                      ),
                      child: new TextFormField(
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        initialValue: EditProductProvider.reference,
                        enabled: false,
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
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              EditProductProvider.designPrivate =
                                  !EditProductProvider.designPrivate;
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                EditProductProvider.designPrivate
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: Colors.black54,
                                size: 25,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Private Design",
                                style: textStyle1(
                                  13,
                                  Colors.black54,
                                  FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Theme(
                data: new ThemeData(
                  primaryColor: Colors.black54,
                ),
                child: new TextFormField(
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
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
                      EditProductProvider.title = _titleController.text;
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
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // DESCRIPTION

              Theme(
                data: new ThemeData(
                  primaryColor: Colors.black54,
                ),
                child: new TextFormField(
                  minLines: 1,
                  maxLines: 3,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      EditProductProvider.description = _descController.text;
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
                        FontWeight.w500,
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
                        primaryColor: Colors.black54,
                      ),
                      child: new TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            if (_noOfColorsController.text.length > 0) {
                              EditProductProvider.setSize =
                                  int.parse(_noOfColorsController.text);
                              if (EditProductProvider.setSize > 24) {
                                EditProductProvider.setSize = 24;
                                _noOfColorsController.text = "24";
                              }
                              EditProductProvider.editColors = [];
                              for (int i = 0;
                                  i < EditProductProvider.setSize;
                                  i++) {
                                EditProductProvider.editColors.add(null);
                              }
                            }
                          });
                        },
                        controller: _noOfColorsController,
                        decoration: new InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black54,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          isDense: true,
                          contentPadding: new EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8,
                          ),
                          enabled: false,
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
                        primaryColor: Colors.black54,
                      ),
                      child: new TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            if (_stockAvailabilityController.text.length > 0) {
                              EditProductProvider.stockAvailability =
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

  List<dynamic> _image = [null, null, null, null];
  final _picker = ImagePicker();

  pickImage(index) async {
    return;
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
      _image = EditProductProvider.editImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
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
                                      // image:
                                      //     FileImage(File(_image[index].path)),
                                      image: CachedNetworkImageProvider(
                                          _image[index].toString()),
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
                                  :
                                  // FileImage(File(_image[index].path)),
                                  CachedNetworkImageProvider(_image[index]),
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
                        size: (imagePageIndex == index) ? 13 : 10,
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

class Temp extends StatefulWidget {
  const Temp({Key key}) : super(key: key);

  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  File _image = null;
  dynamic im;
  final _picker = ImagePicker();

  pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      // imageQuality: 50,
    );
    var bytes = await image.length();
    var kb = bytes / 1024;
    print("kb: $kb");
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 3076,
      maxWidth: 3076,
    );

    // var path = croppedFile.path

    var resultImage = await FlutterImageCompress.compressAndGetFile(
        croppedFile.path, image.path,
        quality: 50);

    print("done compressing ${croppedFile.path}");

    bytes = await croppedFile.length();
    kb = bytes / 1024;
    print("after kb: $kb");
    bytes = await resultImage.length();
    kb = bytes / 1024;
    print("after kb: $kb");

    // final mb = kb / 1024;

    setState(() {
      // im = image;
      _image = resultImage;

      // im = image;
      // EditProductProvider.editImages = _image;
    });
  }

  void upload() async {
    String name = _image.absolute.toString().split('/').last.split("'")[0];
    print("name: $name");
    // await AWS().uploadImage(_image, name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              print("pick");
              await pickImage();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,

                  // borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: (_image == null)
                  ? FittedBox(
                      child: Icon(
                        Icons.file_upload,
                        color: Colors.black38,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(_image.path)),
                        ),
                      ),
                    ),
            ),
          ),
          (_image == null)
              ? Container()
              : Container(
                  width: 300,
                  height: 300,
                  child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    itemCount: 1,
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: FileImage(File(_image.path)),
                        initialScale: PhotoViewComputedScale.contained * 0.8,
                      );
                    },
                  )),
          ElevatedButton(
              onPressed: () async {
                upload();
              },
              child: Text("Submit")),
        ],
      ),
    );
  }
}
