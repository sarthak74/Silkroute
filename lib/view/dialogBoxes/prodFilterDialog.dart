import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/provider/ProductListProvider.dart';
import 'package:silkroute/provider/searchProvider.dart';
import 'package:silkroute/view/pages/reseller/order_page.dart';
import 'package:silkroute/view/pages/reseller/reseller_home.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ProdFilterDialogBox extends StatefulWidget {
  ProdFilterDialogBox(this.categories);
  final dynamic categories;
  @override
  _ProdFilterDialogBoxState createState() => _ProdFilterDialogBoxState();
}

class _ProdFilterDialogBoxState extends State<ProdFilterDialogBox> {
  bool loading = true, loadBrand = false;
  RangeValues _currentRangeValues;
  dynamic filter;

  void loadVars() {
    setState(() {
      filter = SearchProvider().filter;
      _currentRangeValues = RangeValues(filter["sp"]["\u0024gte"].toDouble(),
          filter["sp"]["\u0024lte"].toDouble());
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Price Range: ",
                        style: textStyle(13, Colors.black),
                      ),
                      SizedBox(width: 10),
                      Text(("(" +
                              _currentRangeValues.start.round().toString() +
                              " - " +
                              _currentRangeValues.end.round().toString() +
                              ")")
                          .toString())
                    ],
                  ),
                  RangeSlider(
                    values: _currentRangeValues,
                    min: 1000,
                    inactiveColor: Color(0xFF5b0D1B).withOpacity(0.1),
                    max: 50000,
                    divisions: 10,
                    activeColor: Color(0xFF5b0D1B),
                    labels: RangeLabels(
                      _currentRangeValues.start.round().toString(),
                      _currentRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        if (filter == null) filter = {};
                        _currentRangeValues = values;
                        filter["sp"] = {
                          "\u0024gte": _currentRangeValues.start.round(),
                          "\u0024lte": _currentRangeValues.end.round(),
                        };
                        ProductListProvider().setFilter("sp", filter["sp"]);
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        print("filter optns $filter");
                        setState(() {
                          SearchProvider().setFilter(filter);
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
                          "Filter",
                          style: textStyle(15, Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
