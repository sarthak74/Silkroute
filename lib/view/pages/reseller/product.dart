import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/CrateApi.dart';
import 'package:silkroute/model/services/ProductListApi.dart';
import 'package:silkroute/model/services/WishlistApi.dart';
import 'package:silkroute/view/pages/merchant/add_new_product_page.dart';
import 'package:silkroute/view/pages/reseller/order_page.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/subcategory_head.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

TextStyle textStyle(num size, Color color) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      color: color,
      fontSize: size.toDouble(),
      fontWeight: FontWeight.bold,
    ),
  );
}

class ProductPage extends StatefulWidget {
  const ProductPage({this.id, this.crateData});

  final String id;
  final dynamic crateData;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool loading = true;
  dynamic productDetails;

  void loadProductDetails() async {
    var pp = await ProductListApi().getProductInfo(widget.id);
    setState(() {
      print("id: ${widget.id}");
      productDetails = pp;
      print("pro: $pp");
      loading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProductDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        drawer: Navbar(),
        primary: false,
        body: SingleChildScrollView(
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
              children: <Widget>[
                //////////////////////////////
                ///                        ///
                ///         TopBar         ///
                ///                        ///
                //////////////////////////////

                TopBar(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
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
                                    children: <Widget>[
                                      ProductImage(
                                          productDetails: productDetails),
                                      ProductDescription(
                                          product: productDetails),
                                      widget.crateData == null
                                          ? ProductCounter(
                                              product: productDetails)
                                          : ProductCounter(
                                              product: productDetails,
                                              crateData: widget.crateData,
                                            ),
                                      ProductSpecifications(
                                          specifications:
                                              productDetails['specifications']),
                                    ],
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
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
        ),
        // bottomNavigationBar: Footer(),
      ),
    );
  }
}

class ProductSpecifications extends StatelessWidget {
  const ProductSpecifications({Key key, this.specifications}) : super(key: key);
  final specifications;

  @override
  Widget build(BuildContext context) {
    print("$specifications");
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                'Details',
                style: textStyle1(15, Colors.black, FontWeight.bold),
              ),
            ),
          ],
          rows: List<DataRow>.generate(
            specifications.length,
            (int index) => DataRow(
              cells: [
                DataCell(
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          specifications[index]["title"],
                          style: textStyle1(13, Colors.black, FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          specifications[index]["value"],
                          style: textStyle1(13, Colors.black, FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCounter extends StatefulWidget {
  const ProductCounter({this.product, this.crateData});
  final dynamic product, crateData;
  // crateData != null means modifying crate item

  @override
  _ProductCounterState createState() => _ProductCounterState();
}

class _ProductCounterState extends State<ProductCounter> {
  num counter, min, max, gap;
  num preqty = 0; // if crateData != null
  bool loading = true, addingtoCrate = false, showprice = false;
  List proColors = [], selectedColors = [];
  String
      // url = Math().ip() + "/images/616ff5ab029b95081c237c89-color-0",
      url =
          "https://raw.githubusercontent.com/sarthak74/Yibrance-imgaes/master/category-Suit.png",
      _qty = "";
  LocalStorage storage = LocalStorage('silkroute');
  TextEditingController _qtyController = TextEditingController();

  void inc() {
    setState(() {
      if (_qtyController.text == null || _qtyController.text.length == 0) {
        _qtyController.text = "0";
      }
      dynamic x = int.parse(_qtyController.text);
      x = Math().min(x + 1, widget.product["stockAvailability"]);
      _qtyController.text = x.toString();
      _qty = x.toString();
    });
    calcPrice();
  }

  void dec() {
    setState(() {
      if (_qtyController.text == null || _qtyController.text.length == 0) {
        _qtyController.text = "0";
      }
      dynamic x = int.parse(_qtyController.text);
      x = Math().max(x - 1, 0);
      _qtyController.text = x.toString();
      _qty = x.toString();
    });
    calcPrice();
  }

  num mrp, stock, discountValue;
  String sp;

  calcPrice() {
    setState(() {
      try {
        mrp = widget.product['mrp'];
        mrp *= int.parse(_qty);
        if (_qty == "0" || _qty == 0) {
          showprice = false;
          return;
        }
        sp = Math.getSp(mrp, discountValue);
        showprice = true;
      } catch (e) {
        showprice = false;
      }
    });
  }

  void loadVars() async {
    // ignore: todo
    // TODO: proColors is list of colors/images of product in set

    mrp = widget.product['mrp'];
    discountValue = widget.product['discountValue'];

    if (widget.product['discount']) {
      sp = Math.getSp(mrp, discountValue);
    }

    print("cdata ${widget.crateData}");
    proColors = widget.product["colors"];
    for (var x in widget.product["colors"]) {
      selectedColors.add(false);
    }

    if (widget.crateData != null) {
      _qtyController.text = widget.crateData["quantity"].toString();
      _qty = _qtyController.text;
      showprice = true;
      for (var x in widget.crateData["colors"]) {
        for (int i = 0; i < proColors.length; i++) {
          if (x == proColors[i]) {
            if (selectedColors[i] == true) continue;
            selectedColors[i] = true;
            break;
          }
        }
      }
      calcPrice();
    }
    setState(() {
      loading = false;
    });
  }

  editCrateHandler() async {
    setState(() {
      addingtoCrate = true;
    });
    //You can delete\nthis item using crate through Crate page
    if (_qtyController.text.length < 1) {
      setState(() {
        addingtoCrate = false;
        Toast().notifyErr("Enter some quantity");
      });
      return;
    }
    if (int.parse(_qtyController.text) >
        widget.product['stockAvailability'] + int.parse(preqty.toString())) {
      setState(() {
        addingtoCrate = false;
        Toast().notifyErr("We have less stock available");
      });
      return;
    }

    List selectedColorsUrl = [];
    for (int i = 0; i < selectedColors.length; i++) {
      if (selectedColors[i] == true) {
        selectedColorsUrl.add(proColors[i]);
      }
    }

    if (selectedColorsUrl.length < widget.product['min']) {
      setState(() {
        addingtoCrate = false;
        Toast()
            .notifyErr("Select a minimum of ${widget.product["min"]} colors!");
      });
      return;
    }

    var data = {
      'id': widget.product['_id'].toString(),
      'contact': await storage.getItem('contact'),
      'quantity': int.parse(_qty),
      'colors': selectedColorsUrl,
      'mrp': widget.product['mrp'],
      'merchantContact': widget.product['userContact'],
      'discountValue': widget.product['discountValue'],
      'discount': widget.product['discount'],
      'title': widget.product['title'],
      'stock': widget.product['stockAvailability']
    };

    print("editCrateHandler: $data");

    await CrateApi().editCrateItem(data);

    setState(() {
      _qtyController.text = "";

      addingtoCrate = false;
      Toast().notifySuccess("Crate Modified");
    });
  }

  addToCrateHandler() async {
    setState(() {
      addingtoCrate = true;
    });
    if (_qtyController.text.length < 1) {
      setState(() {
        addingtoCrate = false;
        Toast().notifyErr("Enter some quantity");
      });
      return;
    }
    if (int.parse(_qtyController.text) > widget.product['stockAvailability']) {
      setState(() {
        addingtoCrate = false;
        Toast().notifyErr("We have less stock available");
      });
      return;
    }

    List selectedColorsUrl = [];
    for (int i = 0; i < selectedColors.length; i++) {
      if (selectedColors[i] == true) {
        selectedColorsUrl.add(proColors[i]);
      }
    }

    if (selectedColorsUrl.length < widget.product['min']) {
      setState(() {
        addingtoCrate = false;
        Toast()
            .notifyErr("Select a minimum of ${widget.product["min"]} colors!");
      });
      return;
    }

    var data = {
      'id': widget.product['_id'].toString(),
      'contact': await storage.getItem('contact'),
      'quantity': int.parse(_qty),
      'colors': selectedColorsUrl,
      'mrp': widget.product['mrp'],
      'merchantContact': widget.product['userContact'],
      'discountValue': widget.product['discountValue'],
      'discount': widget.product['discount'],
      'title': widget.product['title'],
      'stock': widget.product['stockAvailability']
    };

    print("addToCrateHandler: $data");

    await CrateApi().setCrateItems(data);

    setState(() {
      _qtyController.text = "";

      addingtoCrate = false;
      Toast().notifySuccess("Added to Crate");
    });
  }

  @override
  void initState() {
    super.initState();

    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //  COLORS
          SizedBox(height: 1),
          Text(
            "Select any ${widget.product['min']}:",
            style: textStyle1(
              13,
              Colors.black,
              FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.topLeft,
            child: loading
                ? Text("Loading")
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 25,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.product["colors"].length,
                      itemBuilder: (BuildContext context, int index) {
                        // print("sel c: $selectedColors");
                        return GestureDetector(
                          onTap: () async {
                            selectedColors = await Helpers()
                                .showColorImageDialog(
                                    context,
                                    widget.product["colors"],
                                    selectedColors,
                                    widget.product['min']);
                            setState(() {});
                          },
                          child: Container(
                            width: 25,
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.5),
                              ),
                              border: Border.all(
                                width: selectedColors[index] ? 1.8 : 0.3,
                                color: Color(0xFF811111),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: dec,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(width: 2, color: Colors.black),
                      ),
                      padding: EdgeInsets.fromLTRB(8, 1, 8, 1),
                      child: Text(
                        "-",
                        style: textStyle(
                          12,
                          Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 70,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (val) async {
                        setState(() {
                          _qty = _qtyController.text;
                        });
                      },
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      controller: _qtyController,
                      decoration: InputDecoration(
                        hintText: "Quantity",
                        isDense: true,
                        focusColor: Color(0xFF5B0D1B),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xFF5B0D1B)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: inc,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(width: 2, color: Colors.black),
                      ),
                      padding: EdgeInsets.fromLTRB(8, 1, 8, 1),
                      child: Text(
                        "+",
                        style: textStyle(
                          12,
                          Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: (widget.crateData == null)
                    ? addToCrateHandler
                    : editCrateHandler,
                child: Container(
                  // width: MediaQuery.of(context).size.width * 0.5,

                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                        size: 15,
                      ),
                      SizedBox(width: 10),
                      addingtoCrate
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.05,
                              height: MediaQuery.of(context).size.width * 0.05,
                              child: CircularProgressIndicator(
                                color: Color(0xFF5B0D1B),
                              ),
                            )
                          : Text(
                              (widget.crateData == null)
                                  ? "Add to Crate"
                                  : "Modify Crate",
                              style: textStyle(13, Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          showprice
              ? Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Row(children: <Widget>[
                      Text(
                        "Amount:   ",
                        style: textStyle(13, Colors.black),
                      ),
                      Text(
                        "₹" + mrp.toString(),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Color(0xFF5B0D1B),
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            decoration: (discountValue > 0)
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationThickness: 3,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      if (discountValue > 0)
                        Text(
                          "₹" + sp.toString(),
                          style: textStyle(13, Color(0xFF811111)),
                        ),
                    ])
                  ],
                )
              : Container(),

          SizedBox(height: 10),

          Text(
            ("Available in stock: " +
                    widget.product['stockAvailability'].toString())
                .toString(),
            style: textStyle(12, Colors.black),
          ),
        ],
      ),
    );
  }
}

class ProductDescription extends StatefulWidget {
  const ProductDescription({this.product});
  final dynamic product;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  String sp;
  bool loading = true;
  void loadVars() {
    setState(() {
      sp = Math.getSp(widget.product['mrp'], widget.product['discountValue']);
      print("sp: $sp");

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
        : Container(
            margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                10,
                MediaQuery.of(context).size.width * 0.05,
                0),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.product['title'],
                    style: textStyle(15, Colors.black)),
                Text(widget.product['description'],
                    style: textStyle(12, Colors.grey)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    widget.product['discount']
                        ? Row(
                            children: <Widget>[
                              Text(
                                ("₹" + widget.product['mrp'].toString())
                                    .toString(),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Color(0xFF5B0D1B),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 3,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                ("₹" + sp.toString()).toString(),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Color(0xFF5B0D1B),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                (widget.product['discountValue'].toString() +
                                        "% off")
                                    .toString(),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              Text(
                                ("₹" + widget.product['mrp'].toString())
                                    .toString(),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Color(0xFF5B0D1B),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        ("Set of " + widget.product['min'].toString())
                            .toString(),
                        style: textStyle(10, Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

class ProductImage extends StatefulWidget {
  const ProductImage({this.productDetails});
  final dynamic productDetails;

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  bool loading = true, wishlist = false;
  int selected = 0;
  List images = [];
  List<String> wishlists = [];
  // String url = Math().ip() + "/images/616ff5ab029b95081c237c89-color-0";
  // String url = Math().ip() + "/images/" + widget.productDetails.id + "-main-" + 0;
  String url =
      "https://raw.githubusercontent.com/sarthak74/Yibrance-imgaes/master/category-Suit.png";
  LocalStorage storage = LocalStorage('silkroute');
  dynamic user;

  Future<void> loadImages() async {
    setState(() {
      images = widget.productDetails["images"];
    });
  }

  void wishlistFunction() async {
    String pid = widget.productDetails['_id'];
    if (!wishlists.contains(pid)) {
      await wishlists.add(pid);
      setState(() {
        user['wishlist'] = wishlists;
      });
    } else {
      await wishlists.remove(pid);
      setState(() {
        user['wishlist'] = wishlists;
      });
    }
    setState(() {
      wishlist = !wishlist;
    });
    await storage.setItem('user', user);
    await WishlistApi().setWishlist();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadImages().then((value) async {
        // print("images: $images");
        user = await storage.getItem('user');
        // print("user -- , $user");
        setState(() {
          List<dynamic> xy = (user != null && user['wishlist'] != null)
              ? user['wishlist']
              : [];

          for (dynamic x in xy) {
            wishlists.add(x.toString());
          }
          wishlist =
              wishlists.contains(widget.productDetails['_id'].toString());
          // user = storage.getItem('user');

          print("images: $images\n$wishlist");
          loading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text("Loading")
        : Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            height: MediaQuery.of(context).size.width -
                75 -
                MediaQuery.of(context).size.width * 0.05,
            alignment: Alignment.topCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 70,
                  height: MediaQuery.of(context).size.width -
                      100 -
                      MediaQuery.of(context).size.width * 0.05,
                  child: ListView.builder(
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index) {
                      // String url = Math().ip() + "/images/" + widget.productDetails.id + "-main-" + index.toString();
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = index;
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    width: (selected == index) ? 2 : 0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  (selected == index)
                                      ? BoxShadow(
                                          color: Color(0xFFC6C2C2),
                                          offset: Offset(2.0, 3.0),
                                          blurRadius: 4.0,
                                        )
                                      : BoxShadow(
                                          color: Color(0xFFFFFFFF),
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 0.0,
                                        ),
                                ],
                                color: Colors.white,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(url),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          if (index < 3)
                            SizedBox(
                                height: (MediaQuery.of(context).size.width -
                                        100 -
                                        MediaQuery.of(context).size.width *
                                            0.05 -
                                        240) /
                                    3)
                        ],
                      );
                    },
                  ),
                ),
                // SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width -
                      100 -
                      MediaQuery.of(context).size.width * 0.05,
                  height: MediaQuery.of(context).size.width -
                      100 -
                      MediaQuery.of(context).size.width * 0.05,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(url.toString()),
                      fit: BoxFit.contain,
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: wishlistFunction,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFF5B0D1B), width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(1, 3.0),
                              blurRadius: 4.0,
                            ),
                          ],
                          color: Color(0xFFFFFFFF),
                        ),
                        child: Center(
                          child: Icon(
                            wishlist
                                ? FontAwesomeIcons.solidBookmark
                                : FontAwesomeIcons.bookmark,
                            size: 15,
                            color: Color(0xFF811111),
                          ),
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

class AddToWishList extends StatefulWidget {
  AddToWishList({this.wishlist});
  final bool wishlist;
  @override
  _AddToWishListState createState() => _AddToWishListState();
}

class _AddToWishListState extends State<AddToWishList> {
  bool wishlist = false;
  @override
  Widget build(BuildContext context) {
    wishlist = widget.wishlist;
    return GestureDetector(
      onTap: () {
        setState(() {
          wishlist = !wishlist;
        });
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF5B0D1B), width: 3),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(1, 3.0),
              blurRadius: 4.0,
            ),
          ],
          color: !wishlist ? Color(0xFFFFFFFF) : Color(0xFFE1AC5D),
        ),
        child: Icon(
          Icons.widgets,
          size: 20,
          color: wishlist ? Color(0xFFFFFFFF) : Color(0xFFE1AC5D),
        ),
      ),
    );
  }
}
