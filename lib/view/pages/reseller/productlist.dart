import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/glitch/NoInternetGlitch.dart';
import 'package:silkroute/model/services/ResellerHomeApi.dart';
import 'package:silkroute/provider/ProductListProvider.dart';
import 'package:silkroute/view/dialogBoxes/filterDialogBox.dart';
import 'package:silkroute/view/dialogBoxes/prodFilterDialog.dart';
import 'package:silkroute/view/dialogBoxes/prodSortDialog.dart';
import 'package:silkroute/view/dialogBoxes/sortDialogBox.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/show_dialog.dart';
import 'package:silkroute/view/widget/subcategory_head.dart';
import 'package:silkroute/view/widget/product_tile.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({this.category, this.subCat});
  final String category;
  final String subCat;

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List _products = [];
  bool loading = true;
  bool _btnShow = true;
  bool _sortShow = false;
  bool _filterShow = false;
  bool noMore = false;

  dynamic _searchProvider = new ProductListProvider();
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
        return ShowDialog(ProdSortDialogBox(), 0);
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
        return ShowDialog(ProdFilterDialogBox(categories), 0);
      },
    );
    setState(() {
      _filterShow = true;
    });
  }

  void refreshList() async {
    setState(() {
      _btnShow = false;
    });
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      _products = [];
      _searchProvider.productApiResult(null);
    });
    await _searchProvider.setProductListStream(0);
    await _searchProvider.search();
    setState(() {
      _btnShow = true;
    });
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   loadproduct();
    // });
    super.initState();
    loadVars();
    _searchProvider.search();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ProductListProvider(),
      builder: (context, child) {
        double aspectRatio = 1.45 *
            (MediaQuery.of(context).size.width *
                0.86 /
                MediaQuery.of(context).size.height);
        _products = [];
        return GestureDetector(
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  Expanded(
                    child: loading
                        ? Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF5B0D1B),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : CustomScrollView(slivers: [
                            SliverList(
                              delegate: SliverChildListDelegate([
                                //////////////////////////////
                                ///                        ///
                                ///     Category Head      ///
                                ///                        ///
                                //////////////////////////////

                                CategoryHead(title: widget.subCat),

                                Container(
                                  margin: EdgeInsets.only(
                                    top: 8,
                                    left: MediaQuery.of(context).size.width *
                                        0.07,
                                    right: MediaQuery.of(context).size.width *
                                        0.07,
                                  ),
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
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: SingleChildScrollView(
                                    child: StreamBuilder<List<ProductList>>(
                                      stream: _searchProvider.productListStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text("Loading");
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return Text("Fetched");
                                        } else if (snapshot.hasError) {
                                          return Text("Error");
                                        } else {
                                          if (snapshot.data != null) {
                                            _products.addAll(snapshot.data);

                                            noMore = (snapshot.data.length == 0)
                                                ? true
                                                : false;

                                            return Column(
                                              children: [
                                                GridView.count(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
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
                                                ),
                                                SizedBox(height: 20),
                                                noMore
                                                    ? Center(
                                                        child: Text(
                                                        "No More Data to show",
                                                        style: textStyle1(
                                                          15,
                                                          Colors.black54,
                                                          FontWeight.w500,
                                                        ),
                                                      ))
                                                    : Container()
                                              ],
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

                                SizedBox(height: 5),

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
                                                  10, 5, 10, 5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Apply Sort",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(width: 10),
                                    _btnShow
                                        ? GestureDetector(
                                            onTap: () =>
                                                _searchProvider.loadMore(),
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Load More",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(width: 10),
                                    _filterShow
                                        ? GestureDetector(
                                            onTap: () {
                                              refreshList();

                                              _filterShow = false;
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Apply Filters",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
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
                                hasScrollBody: false, child: Container()),
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
