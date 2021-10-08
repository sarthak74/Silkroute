import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/methods/math.dart';

class CrateProductTile extends StatefulWidget {
  const CrateProductTile({this.product});

  final dynamic product;

  @override
  _CrateProductTileState createState() => _CrateProductTileState();
}

class _CrateProductTileState extends State<CrateProductTile> {
  @override
  Widget build(BuildContext context) {
    num mrp = widget.product['mrp'];
    num discountValue = widget.product['discountValue'];
    String sp;
    if (widget.product['discount']) {
      sp = Math.getSp(mrp, discountValue);
    }
    bool stockAlert = false;
    if (widget.product['stock'] <= 10) {
      stockAlert = true;
    }
    String stock = widget.product['stock'].toString();
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      color: Colors.grey[200],
      height: MediaQuery.of(context).size.height * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/1.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.59,
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.product['title'],
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  ("Quantity: " + widget.product['quantity'].toString())
                      .toString(),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                widget.product['discount']
                    ? Row(
                        children: <Widget>[
                          Text(
                            ("₹" + mrp.toString()).toString(),
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
                            ("-" + discountValue.toString() + "%").toString(),
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 15,
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                stockAlert
                    ? Row(
                        children: <Widget>[
                          Icon(Icons.alarm, color: Colors.red, size: 15),
                          Text(
                            ("  Hurry! only " + stock + " left in stock")
                                .toString(),
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ///////  REMOVE BUTTON

                    GestureDetector(
                      onTap: null,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey[400],
                        ),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.delete, size: 15),
                            Text(
                              "Remove",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///////  MODIFY BUTTON

                    GestureDetector(
                      onTap: null,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey[400],
                        ),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.edit, size: 15),
                            Text(
                              "Modify",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
