import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/services/CrateApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/pages/reseller/product.dart';

class CrateProductTile extends StatefulWidget {
  const CrateProductTile({this.product, this.index});

  final dynamic product;
  final int index;

  @override
  _CrateProductTileState createState() => _CrateProductTileState();
}

class _CrateProductTileState extends State<CrateProductTile> {
  bool removing = false;
  Widget afterQuantity = Text("");
  void removeHandler() async {
    setState(() {
      removing = true;
    });
    String id = widget.product["id"];
    print("remve product: $id");
    await CrateApi().removeCrateItem(id);
    print("removed");
    setState(() {
      removing = false;
    });
    Navigator.popAndPushNamed(context, "/crate");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    num mrp = widget.product['mrp'], stock = widget.product['stock'];
    num discountValue = widget.product['discountValue'],
        qty = widget.product['quantity'];
    String sp;
    mrp *= qty;

    if (widget.product['discount']) {
      sp = Math.getSp(mrp, discountValue);
    }

    if (stock == 0) {
      afterQuantity = Text(
        "Out of stock!",
        style: textStyle1(
          12,
          Colors.red,
          FontWeight.w500,
        ),
      );
    } else if (stock < qty) {
      afterQuantity = Row(
        children: <Widget>[
          Icon(
            Icons.warning,
            size: 12,
            color: Colors.red[800],
          ),
          Text(
            " Only ${widget.product['stock'].toString()} available",
            style: textStyle1(
              12,
              Colors.red[800],
              FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      color: Colors.grey[200],
      // height: MediaQuery.of(context).size.height * 0.12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Image.asset(
              "assets/images/unnamed.png",
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
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
                  Row(
                    children: <Widget>[
                      Text(
                        ("Quantity: ").toString(),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        (widget.product['quantity'].toString()).toString(),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  afterQuantity,
                  widget.product['discount']
                      ? Row(
                          children: <Widget>[
                            Text(
                              ("₹" + mrp.toString()).toString(),
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Color(0xFF5B0D1B),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
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
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              ("-" + discountValue.toString() + "%").toString(),
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
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
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ///////  REMOVE BUTTON

                GestureDetector(
                  onTap: () {
                    removeHandler();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.delete, size: 17),
                  ),
                ),

                SizedBox(height: 10),

                ///////  MODIFY BUTTON

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          id: (widget.product['id']).toString(),
                          crateData: widget.product,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.edit, size: 17),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
