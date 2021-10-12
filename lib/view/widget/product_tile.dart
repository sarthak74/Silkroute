import 'dart:convert';

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
  List<String> wishlists = [];

  void wishlistFunction() async {
    String pid = widget.product.id;
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

  void loadVars() {
    setState(() {
      user = storage.getItem('user');
    });
    print("id: ${widget.product.id}");
    List<dynamic> xy = user['wishlist'];
    for (dynamic x in xy) {
      setState(() {
        wishlists.add(x.toString());
      });
    }
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
    if (widget.product.discount) {
      sp = Math.getSp(mrp, discountValue);
    }

    return GestureDetector(
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
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  image: AssetImage("assets/images/1.png"),
                  fit: BoxFit.fill,
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.22,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                            color: !wishlists.contains(widget.product.id)
                                ? Color(0xFFFFFFFF)
                                : Color(0xFFE1AC5D),
                          ),
                          child: Icon(
                            Icons.widgets,
                            size: 20,
                            color: wishlists.contains(widget.product.id)
                                ? Color(0xFFFFFFFF)
                                : Color(0xFFE1AC5D),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

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
              height: MediaQuery.of(context).size.height * 0.11,
              width: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              ("-" + discountValue.toString() + "%").toString(),
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
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 3,
                                ),
                              ),
                            ),
                          ],
                        ),
                  Text(
                    "Min Order Quantity: 2",
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
