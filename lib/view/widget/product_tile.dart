import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/services/WishlistApi.dart';
import 'package:silkroute/view/pages/reseller/product.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({this.product});

  final ProductList product;

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  LocalStorage storage = LocalStorage('silkroute');
  dynamic user, productd;
  bool loading = true;
  List<String> wishlists = [];

  void wishlistFunction() async {
    String pid = widget.product.id;
    if (!(await wishlists.contains(pid))) {
      await wishlists.add(pid);
      setState(() {
        user['wishlist'] = wishlists;
      });
      await storage.setItem('user', user);
    } else {
      await wishlists.remove(pid);
      setState(() {
        user['wishlist'] = wishlists;
      });
      await storage.setItem('user', user);
    }

    await WishlistApi().setWishlist();
  }

  void loadVars() async {
    user = await storage.getItem('user');

    print("id: ${widget.product.id}");
    List<dynamic> xy = user['wishlist'];
    if (xy == null) xy = [];
    for (dynamic x in xy) {
      await wishlists.add(x.toString());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVars();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    num mrp = widget.product.mrp;
    num discountValue = widget.product.discountValue;
    String sp;

    sp = Math.getSp(mrp, discountValue);

    return loading
        ? Text("Loading...")
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductPage(id: (widget.product.id).toString()),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.015,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //////////////////////////////
                  ///                        ///
                  ///      Product Image     ///
                  ///                        ///
                  //////////////////////////////

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFC6C2C2),
                          offset: Offset(3.0, 4.0),
                          blurRadius: 4.0,
                        ),
                      ],
                      color: Color.fromARGB(0, 0, 0, 0),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          "https://images.pexels.com/photos/2246476/pexels-photo-2246476.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  ("4.2").toString(),
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Icon(Icons.star, size: 13),
                              ],
                            ),
                            GestureDetector(
                              onTap: wishlistFunction,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xFF5B0D1B), width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
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
                                    wishlists.contains(widget.product.id)
                                        ? FontAwesomeIcons.solidBookmark
                                        : FontAwesomeIcons.bookmark,
                                    size: 15,
                                    color: Color(0xFF811111),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 7),

                  //////////////////////////////
                  ///                        ///
                  ///  Product Description   ///
                  ///                        ///
                  //////////////////////////////

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          offset: Offset(3.0, 4.0),
                          blurRadius: 4.0,
                        )
                      ],
                      color: Color(0xFFFAF5ED),
                    ),
                    // height: 80,
                    width: MediaQuery.of(context).size.width * 0.40,
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.product.title,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        widget.product.discount
                            ? Row(
                                children: <Widget>[
                                  Text(
                                    ("₹" + mrp.toString()).toString(),
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Color(0xFF5B0D1B),
                                        fontSize: 10,
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
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    ("-" + discountValue.toString() + "%")
                                        .toString(),
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: <Widget>[
                                  Text(
                                    ("₹" + mrp.toString()).toString(),
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Color(0xFF5B0D1B),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        Text(
                          "Set of ${widget.product.min}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
