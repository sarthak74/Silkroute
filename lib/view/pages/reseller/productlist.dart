import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  dynamic product = {
    "id": 1,
    "title": "Kanjeevaram Silk Saree",
    "discount": true,
    "mrp": 20000.0,
    "discountValue": 70.0,
    "min_order": 5.0,
    "wishlist": false,
    "rating": 4.2
  };

  void loadproduct() {
    dynamic provider = ProductListProvider();
    provider.productListStream.listen((snapshot) {
      snapshot.fold((l) {
        if (l is NoInternetGlitch) {
          print("No Internet");
          //Implement UI to handle NoInternet
        }
      }, (r) => {products.add(r)});
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //loadproduct();
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ProductListProvider(),
      builder: (context, child) {
        final provider = Provider.of<ProductListProvider>(context);
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
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: loading
                                  ? Text("Loading Loading")
                                  : GridView.count(
                                      childAspectRatio: aspectRatio,
                                      crossAxisCount: 2,
                                      children: List.generate(
                                        products == [] ? 0 : products.length,
                                        (index) {
                                          return ProductTile(
                                              product: products[index]);
                                        },
                                      ),
                                    ),
                            ),
                          ),

                          GestureDetector(
                            onTap: provider.loadMore,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Text(
                                "Load More",
                                style: textStyle(12, Colors.black),
                              ),
                            ),
                          ),
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
