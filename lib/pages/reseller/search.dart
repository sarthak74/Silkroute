import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silkroute/pages/reseller/productlist.dart';
import 'package:silkroute/widget/subcategory_head.dart';
import 'package:silkroute/widget/product_tile.dart';
import 'package:silkroute/widget/footer.dart';
import 'package:silkroute/widget/navbar.dart';
import 'package:silkroute/widget/topbar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({this.category});

  final String category;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchTextController = new TextEditingController();
  String searchText = "";
  List<int> searchResults = [];

  void loadSearchResults() {
    for (int i = 0; i < 20; i++) {
      searchResults.add(i);
    }
    setState(() {
      //loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double fh = MediaQuery.of(context).size.height;
    double fw = MediaQuery.of(context).size.width;
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
                child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          40,
                          MediaQuery.of(context).size.height * 0.04,
                          40,
                          MediaQuery.of(context).size.height * 0.04,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.black54,
                                size: MediaQuery.of(context).size.width * 0.1,
                              ),
                              padding: EdgeInsets.all(5),
                              onPressed: () {
                                setState(() {
                                  searchText = searchTextController.text;
                                  searchTextController.text = "";
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListPage(
                                      headtext: searchText,
                                      // TODO: input fetched products for search result
                                    ),
                                  ),
                                );
                              },
                            ),
                            hintText: "Search for products",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.black38,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 4,
                                color: Colors.black54,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          controller: searchTextController,
                        ),
                      ),
                    ]),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        0,
                        0,
                        0,
                        MediaQuery.of(context).size.height * 0.15,
                      ),
                      child: Icon(
                        Icons.search,
                        size: MediaQuery.of(context).size.width * 0.5,
                        color: Colors.black38,
                      ),
                    ),
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
  }
}
