import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/provider/searchProvider.dart';
import 'package:silkroute/view/pages/reseller/order_page.dart';

class SortDialogBox extends StatefulWidget {
  static int index = 0;
  SortDialogBoxState createState() => SortDialogBoxState();
}

class SortDialogBoxState extends State<SortDialogBox> {
  String _sortBy;
  num _value;

  bool loading = true;
  dynamic _sortValues;

  void loadVars() {
    setState(() {
      _sortValues = [
        {"title": "Product Name (A-Z)", "key": "title", "value": 1},
        {"title": "Product Name (Z-A)", "key": "title", "value": -1},
        {"title": "Brand Name (A-Z)", "key": "subCat", "value": 1},
        {"title": "Brand Name (Z-A)", "key": "subCat", "value": -1},
        {"title": "Price (low-high)", "key": "mrp", "value": 1},
        {"title": "Price (high-low)", "key": "mrp", "value": -1},
        {"title": "Discount (low-high)", "key": "discountValue", "value": 1},
        {"title": "Discount (high-low)", "key": "discountValue", "value": -1}
      ];
      _sortBy = _sortValues[SortDialogBox.index]["title"];
      _value = _sortValues[SortDialogBox.index]["value"];
      print("index ${SortDialogBox.index}, $_sortBy $_value");
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
        : SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Sort by:",
                    style: textStyle(18, Color(0xFF5B0D1B)),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _sortValues.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(vertical: 7),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _sortBy = _sortValues[i]["key"];
                              _value = _sortValues[i]["value"];
                              SortDialogBox.index = i;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              (SortDialogBox.index == i)
                                  ? Icon(
                                      Icons.radio_button_checked,
                                      color: Color(0xFF5B0D1B),
                                    )
                                  : Icon(Icons.radio_button_off),
                              SizedBox(width: 20),
                              Text(
                                _sortValues[i]["title"],
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      print("$_sortBy $_value");
                      setState(() {
                        SearchProvider().setSortBy(_sortBy, _value);
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                      decoration: BoxDecoration(
                        color: Color(0xFF5B0D1B),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Text(
                        "Sort",
                        style: textStyle(15, Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
