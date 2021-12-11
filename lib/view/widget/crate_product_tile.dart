import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/services/CrateApi.dart';

class CrateProductTile extends StatefulWidget {
  const CrateProductTile({this.product, this.index});

  final dynamic product;
  final int index;

  @override
  _CrateProductTileState createState() => _CrateProductTileState();
}

class _CrateProductTileState extends State<CrateProductTile> {
  bool removing = false;
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
    num mrp = widget.product['mrp'];
    num discountValue = widget.product['discountValue'];
    String sp;
    if (widget.product['discount']) {
      sp = Math.getSp(mrp, discountValue);
    }

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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ///////  REMOVE BUTTON

                    GestureDetector(
                      onTap: () {
                        removeHandler();
                      },
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
                              removing ? "Removing" : "Remove",
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
