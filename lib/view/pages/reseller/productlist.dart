import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/glitch/NoInternetGlitch.dart';
import 'package:silkroute/provider/ProductListProvider.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/subcategory_head.dart';
import 'package:silkroute/view/widget/product_tile.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({this.headtext});

  final String headtext;

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List products = [];
  bool loading = true;

  dynamic provider = new ProductListProvider();

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   loadproduct();
    // });
    provider.loadMore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ProductListProvider(),
      builder: (context, child) {
        double aspectRatio = 1.45 *
            (MediaQuery.of(context).size.width *
                0.86 /
                MediaQuery.of(context).size.height);
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
                          //////////////////////////////
                          ///                        ///
                          ///     Category Head      ///
                          ///                        ///
                          //////////////////////////////

                          CategoryHead(title: widget.headtext),
                          // TODO: Change design of category
                          // TODO: Sort & Filter functionality

                          //////////////////////////////
                          ///                        ///
                          ///         Lists          ///
                          ///                        ///
                          //////////////////////////////

                          SizedBox(height: 20),

                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: StreamBuilder<List<ProductList>>(
                                stream: provider.productListStream,
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
                                      products.addAll(snapshot.data);
                                      return GridView.count(
                                        childAspectRatio: aspectRatio,
                                        crossAxisCount: 2,
                                        children: List.generate(
                                          products == [] ? 0 : products.length,
                                          (index) {
                                            return ProductTile(
                                                product: products[index]);
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
                              GestureDetector(
                                onTap: provider.loadMore,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Load More",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 15,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
