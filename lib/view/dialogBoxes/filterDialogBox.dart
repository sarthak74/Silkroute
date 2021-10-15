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

  dynamic data, filter;
  List<String> categories = [];
  Map<String, List<String>> brands = {};
  List<String> selBrand = [], cBrand = [];
  RangeValues _currentRangeValues = const RangeValues(1000, 50000);

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
      category = categories[0];
      cBrand = brands[category];
      print("$categories\n$brands\n$cBrand");
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Category: ", style: textStyle(13, Colors.black)),
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
                            print("object $val");
                            category = val;
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
                      selBrand = values;
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Price Range",
                    style: textStyle(13, Colors.black),
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
                        _currentRangeValues = values;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
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
