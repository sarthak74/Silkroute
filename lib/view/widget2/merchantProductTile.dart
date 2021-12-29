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
                  offset: Offset(3.0, 4.0),
                  blurRadius: 4.0,
                ),
              ],
              color: Color.fromRGBO(0, 0, 0, 0.3),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  "https://images.pexels.com/photos/2246476/pexels-photo-2246476.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
                ),
                fit: BoxFit.fill,
              ),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.015,
              vertical: 5,
            ),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.4,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  ("4.2").toString(),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(
                  Icons.star,
                  size: 13,
                  color: Colors.grey[200],
                )
              ],
            ),
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
                  offset: Offset(3.0, 4.0),
                  blurRadius: 4.0,
                )
              ],
              color: Color(0xFFFAF5ED),
            ),

            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.015,
            ),
            height: 60,
            // width: MediaQuery.of(context).size.width * 0.41,
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Text(
                    widget.product.title +
                        " asjcn sajn ajscn askcn aslcn kslc ks",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Stock: ${widget.product.stockAvailability}",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
