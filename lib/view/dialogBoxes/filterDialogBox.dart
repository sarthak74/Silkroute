import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/provider/searchProvider.dart';
import 'package:silkroute/view/pages/reseller/order_page.dart';
import 'package:silkroute/view/pages/reseller/reseller_home.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class FilterDialogBox extends StatefulWidget {
  FilterDialogBox(this.categories);
  final dynamic categories;
  @override
  _FilterDialogBoxState createState() => _FilterDialogBoxState();
}

class _FilterDialogBoxState extends State<FilterDialogBox> {
  bool loading = true, loadBrand = false;
  String category = "";

  dynamic data;

  List<String> categories = [];
  Map<String, List<String>> brands = {};
  Map<String, dynamic> filter = {};
  List<String> selBrand = [], cBrand = [];
  RangeValues _currentRangeValues;

  void loadVars() {
    setState(() {
      data = widget.categories;
      for (var x in data) {
        categories.add(x["title"]);
        brands[x["title"]] = [];
        int j = 0;
        for (var y in x["subCat"]) {
          brands[x["title"]].add(y["title"]);
          j++;
        }
      }
      filter["category"] = SearchProvider().filter["category"];
      filter["sp"] = SearchProvider().filter["sp"];

      category = filter["category"];
      cBrand = brands[category];
      _currentRangeValues = RangeValues(filter["sp"]["\u0024gte"].toDouble(),
          filter["sp"]["\u0024lte"].toDouble());
      print("$categories\n$brands\n$cBrand\n$filter");
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
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Choose Filters:",
                      style: textStyle(18, Color(0xFF5B0D1B)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Category:", style: textStyle(13, Colors.black)),
                      SizedBox(width: 20),
                      DropdownButton<String>(
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        items: categories.map((String e) {
                          return DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            print("object $val $filter");
                            category = val;
                            if (filter == null) {
                              filter["category"] =
                                  SearchProvider().filter["category"];
                              filter["sp"] = SearchProvider().filter["sp"];
                            }
                            filter["category"] = category;
                            cBrand = brands[category];
                            print("cbran $cBrand");
                          });
                        },
                        value: category,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  MultiSelectDialogField(
                    selectedItemsTextStyle: textStyle(13, Colors.white),
                    searchTextStyle: textStyle(13, Colors.black),
                    items: cBrand.map((e) => MultiSelectItem(e, e)).toList(),
                    listType: MultiSelectListType.CHIP,
                    selectedColor: Color(0xFF5B0D1B),
                    searchable: true,
                    decoration: BoxDecoration(
                      color: Color(0xFF5B0D1B).withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      border: Border.all(
                        color: Color(0xFF5B0D1B),
                        width: 2,
                      ),
                    ),
                    onConfirm: (values) {
                      if (filter == null) {
                        filter["category"] =
                            SearchProvider().filter["category"];
                        filter["sp"] = SearchProvider().filter["sp"];
                      }
                      selBrand = values;
                      filter["subCat"] = {"\u0024in": values};
                    },
                  ),
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
