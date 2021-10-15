import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/services/ProductListApi.dart';
import 'package:silkroute/model/services/ResellerHomeApi.dart';
import 'package:silkroute/provider/searchProvider.dart';
import 'package:silkroute/view/dialogBoxes/filterDialogBox.dart';
import 'package:silkroute/view/dialogBoxes/sortDialogBox.dart';
// import 'package:silkroute/view/pages/reseller/order_page.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/pages/reseller/productlist.dart';
import 'package:silkroute/view/widget/show_dialog.dart';
import 'package:silkroute/view/widget/subcategory_head.dart';
import 'package:silkroute/view/widget/product_tile.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({this.category});

  final String category;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchTextController = new TextEditingController();
  String _searchText = "";
  List _products = [];
  dynamic _searchProvider = SearchProvider();

  bool loading = true;
  bool _btnShow = false;
  bool _sortShow = false;
  bool _filterShow = false;
  Icon radioOn, radioOff;
  List<dynamic> categories;

  void loadVars() async {
    List<dynamic> categoriess = await ResellerHomeApi().getCategories();
    setState(() {
      categories = categoriess;
      _products = [];

      radioOn = Icon(Icons.radio_button_checked);
      radioOff = Icon(Icons.radio_button_off);
      loading = false;
    });
  }

  @override
  void initState() {
    loadVars();
    super.initState();
  }

  void sortFunction() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (context, _a1, _a2, _child) {
        return ScaleTransition(
          child: _child,
          scale: CurvedAnimation(parent: _a1, curve: Curves.bounceOut),
        );
      },
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, a1, a2) {
        return ShowDialog(SortDialogBox(), 0);
      },
    );
    setState(() {
      _sortShow = true;
    });
  }

  void filterFunction() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (context, _a1, _a2, _child) {
        return ScaleTransition(
          child: _child,
          scale: CurvedAnimation(parent: _a1, curve: Curves.bounceOut),
        );
      },
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, a1, a2) {
        return ShowDialog(FilterDialogBox(categories), 0);
      },
    );
    setState(() {
      _filterShow = true;
    });
  }

  void refreshList() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      // _searchProvider.setSortBy();
      _searchText = _searchTextController.text;
      print("\nsearchText: $_searchText\n");

      _products = [];
      _searchProvider.productApiResult(null);
    });
    if (_searchText.length > 0) {
      await _searchProvider.setProductListStream(0);
      await _searchProvider.search(_searchText);
      setState(() {
        _btnShow = true;
      });
      print("loadState $_btnShow");
    }
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => SearchProvider(),
      builder: (context, child) {
        double aspectRatio = 1.45 *
            (MediaQuery.of(context).size.width *
                0.86 /
                MediaQuery.of(context).size.height);
        double fh = MediaQuery.of(context).size.height;
        double fw = MediaQuery.of(context).size.width;
        _products = [];
        return loading
            ? Text("Loading")
            : GestureDetector(
                onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  drawer: Navbar(),
                  primary: false,
                  body: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/1.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        //////////////////////////////
                        ///                        ///
                        ///         TopBar         ///
                        ///                        ///
                        //////////////////////////////

                        TopBar(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),

                        Expanded(
                          child: CustomScrollView(slivers: [
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                    40,
                                    5,
                                    40,
                                    5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.69,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText: "Search for products",
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 2,
                                                  color: Colors.black38,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 3,
                                                  color: Colors.black54,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      20, 5, 5, 5)),
                                          controller: _searchTextController,
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Icon(
                                          Icons.search,
                                          color: Colors.black54,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                        ),
                                        onTap: refreshList,
                                      ),
                                    ],
                                  ),
                                ),

                                //// SORTING AND FILTERING

                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.07),
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          sortFunction();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.sort, size: 25),
                                            Text(
                                              " Sort",
                                              style:
                                                  textStyle(13, Colors.black),
                                            )
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          filterFunction();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.tungsten, size: 25),
                                            Text(
                                              " Filter",
                                              style:
                                                  textStyle(13, Colors.black),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                //////////////////////////////
                                ///                        ///
                                ///         Lists          ///
                                ///                        ///
                                //////////////////////////////

                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    vertical:
                                        MediaQuery.of(context).size.width *
                                            0.01,
                                  ),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.53,
                                    child: StreamBuilder<List<ProductList>>(
                                      stream: _searchProvider.productListStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text("");
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return Text("Fetched");
                                        } else if (snapshot.hasError) {
                                          return Text("Error");
                                        } else {
                                          if (snapshot.data != null) {
                                            _products.addAll(snapshot.data);

                                            return GridView.count(
                                              childAspectRatio: aspectRatio,
                                              crossAxisCount: 2,
                                              children: List.generate(
                                                _products == []
                                                    ? 0
                                                    : _products.length,
                                                (index) {
                                                  return ProductTile(
                                                      product:
                                                          _products[index]);
                                                },
                                              ),
                                            );
                                          } else {
                                            return Text("No more data to show");
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                //////// LOAD MORE BUTTON

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _sortShow
                                        ? GestureDetector(
                                            onTap: () {
                                              refreshList();
                                              setState(() {
                                                _sortShow = false;
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 10, 20, 10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Apply Sort",
                                                    style: textStyle(
                                                        13, Colors.black),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    size: 15,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(width: 20),
                                    _btnShow
                                        ? GestureDetector(
                                            onTap: () => _searchProvider
                                                .loadMore(_searchText),
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 10, 20, 10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Load More",
                                                    style: textStyle(
                                                        13, Colors.black),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    size: 15,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(width: 20),
                                    _filterShow
                                        ? GestureDetector(
                                            onTap: () {
                                              refreshList();

                                              _filterShow = false;
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 10, 20, 10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Apply Filters",
                                                    style: textStyle(
                                                        13, Colors.black),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    size: 15,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),

                                SizedBox(height: 30),
                              ]),
                            ),
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Container(),
                            ),
                          ]),
                        ),

                        //////////////////////////////
                        ///                        ///
                        ///         Footer         ///
                        ///                        ///
                        //////////////////////////////
                        Footer(),
                      ],
                    ),
                  ),
                  // bottomNavigationBar: Footer(),
                ),
              );
      });
}
