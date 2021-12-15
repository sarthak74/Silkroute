import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/CrateApi.dart';
import 'package:silkroute/model/services/ProductListApi.dart';
import 'package:silkroute/model/services/WishlistApi.dart';
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
  const ProductPage({this.id});

  final String id;

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
                                      ProductCounter(product: productDetails),
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
        ),
        // bottomNavigationBar: Footer(),
      ),
    );
  }
}

class ProductCounter extends StatefulWidget {
  const ProductCounter({this.product});
  final dynamic product;

  @override
  _ProductCounterState createState() => _ProductCounterState();
}

class _ProductCounterState extends State<ProductCounter> {
  num counter, min, max, gap;
  bool loading = true, addingtoCrate = false;
  List proColors = [];
  String
      // url = Math().ip() + "/images/616ff5ab029b95081c237c89-color-0",
      url =
          "https://raw.githubusercontent.com/sarthak74/Yibrance-imgaes/master/category-Suit.png",
      _qty = "";
  LocalStorage storage = LocalStorage('silkroute');
  TextEditingController _qtyController = TextEditingController();

  void inc() {
    setState(() {
      counter = max;
    });
  }

  void dec() {
    setState(() {
      counter = min;
    });
  }

  void loadVars() {
    setState(() {
      counter = widget.product['min'];
      min = widget.product['min'];
      max = widget.product['totalSet'];

      // ignore: todo
      // TODO: proColors is list of colors/images of product in set

      proColors = widget.product["colors"];

      loading = false;
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
    var data = {
      'id': widget.product['_id'].toString(),
      'contact': storage.getItem('contact'),
      'quantity': _qty,
      'colors': proColors.sublist(0, counter),
      'mrp': widget.product['mrp'].toString(),
      'merchantContact': widget.product['userContact'].toString(),
      'disValue': widget.product['discountValue'].toString(),
      'discount': widget.product['discount'].toString(),
      'title': widget.product['title'].toString(),
      'stock': widget.product['stockAvailability'].toString()
    };

    print("addToCrateHandler: $data");

    await CrateApi().setCrateItems(data);

    setState(() {
      widget.product['stockAvailability'] -= int.parse(_qtyController.text);
      _qtyController.text = "";

      addingtoCrate = false;
      Toast().notifySuccess("Added to Crate");
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
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // COUNTER

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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 2, color: Colors.black),
                ),
                padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                child: Text(
                  loading ? "." : counter.toString(),
                  style: textStyle(
                    14,
                    Colors.black,
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

          //  COLORS
          SizedBox(height: 15),
          Align(
            alignment: Alignment.topLeft,
            child: loading
                ? Text("Loading")
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 25,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: counter,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 25,
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.5)),
                            image: DecorationImage(
                              image: NetworkImage(url),
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          SizedBox(height: 15),

          Row(
            children: <Widget>[
              Container(
                width: 92,
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
                    hintText: "Enter Quantity",
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
                onTap: addToCrateHandler,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
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
                          : Text("Add to Crate",
                              style: textStyle(13, Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
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
                                ("-" +
                                        widget.product['discountValue']
                                            .toString() +
                                        "%")
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
                        ("Set of " +
                                ((widget.product['totalSet'] == null)
                                        ? widget.product['min']
                                        : widget.product['totalSet'])
                                    .toString())
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
      setState(() {
        wishlists.add(pid);
        user['wishlist'] = wishlists;
        storage.setItem('user', user);
      });
    } else {
      setState(() {
        wishlists.remove(pid);
        user['wishlist'] = wishlists;
        storage.setItem('user', user);
      });
    }

    await WishlistApi().setWishlist();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadImages().then((value) async {
        // print("images: $images");
        var user = await storage.getItem('user');
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
          print("images: $images");
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
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: 10),
            padding: EdgeInsets.all(10),
            height: 300,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 280,
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
                              width: MediaQuery.of(context).size.width * 0.18,
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
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(url),
                                  fit: BoxFit.fill,
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: 280,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(url.toString()),
                      fit: BoxFit.fill,
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
                              Border.all(color: Color(0xFF5B0D1B), width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(1, 3.0),
                              blurRadius: 4.0,
                            ),
                          ],
                          color:
                              !wishlist ? Color(0xFFFFFFFF) : Color(0xFFE1AC5D),
                        ),
                        child: Icon(
                          Icons.widgets,
                          size: 20,
                          color:
                              wishlist ? Color(0xFFFFFFFF) : Color(0xFFE1AC5D),
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
