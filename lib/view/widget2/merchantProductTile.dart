import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/services/WishlistApi.dart';
import 'package:silkroute/view/pages/merchant/edit_product.dart';
import 'package:silkroute/view/pages/reseller/product.dart';

class MerchantProductTile extends StatefulWidget {
  const MerchantProductTile({Key key, this.product}) : super(key: key);
  final ProductList product;

  @override
  _MerchantProductTileState createState() => _MerchantProductTileState();
}

class _MerchantProductTileState extends State<MerchantProductTile> {
  @override
  Widget build(BuildContext context) {
    num mrp = widget.product.mrp;
    String ti = widget.product.title;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProduct(product: widget.product),
          ),
        );
      },
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
                  offset: Offset(0.0, 4.0),
                  blurRadius: 4.0,
                ),
              ],
              // shape: BoxShape.rectangle,
              color: Color.fromRGBO(0, 0, 0, 0.3),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  widget.product.images[0].toString(),
                ),
                fit: BoxFit.fill,
              ),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.015,
              vertical: 5,
            ),
            width: MediaQuery.of(context).size.width * 0.42,
            height: MediaQuery.of(context).size.width * 0.42,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            // child: Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Text(
            //       ("4.2").toString(),
            //       style: GoogleFonts.poppins(
            //         textStyle: TextStyle(
            //           color: Colors.grey[200],
            //           fontSize: 10,
            //           fontWeight: FontWeight.w800,
            //         ),
            //       ),
            //     ),
            //     Icon(
            //       Icons.star,
            //       size: 13,
            //       color: Colors.grey[200],
            //     )
            //   ],
            // ),
          ),

          // SizedBox(height: 7),

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
                  offset: Offset(0, 4.0),
                  blurRadius: 4.0,
                )
              ],
              color: Color(0xFFFAF5ED),
            ),

            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.015,
            ),
            height: 50,
            // constraints: BoxConstraints(maxHeight: 60, minHeight: 40),
            // width: MediaQuery.of(context).size.width * 0.41,
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.product.title +
                      (ti[0] == "V" ? " asjckn jsdn asjk asjkn asjc sdds" : ""),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Stock: ",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          "${widget.product.stockAvailability}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      ("₹" + mrp.toString()).toString(),
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Color(0xFF811111),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
