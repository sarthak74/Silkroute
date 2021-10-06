import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silkroute/widget/subcategory_head.dart';
import 'package:silkroute/widget/product_tile.dart';
import 'package:silkroute/widget/footer.dart';
import 'package:silkroute/widget/navbar.dart';
import 'package:silkroute/widget/topbar.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List products = [];
  bool loading = true;
  dynamic product = {
    "id": 2,
    "title": "Kanjeevaram Silk Saree",
    "discount": true,
    "mrp": 20000.0,
    "discountValue": 70.0,
    "min_order": 5.0,
    "wishlist": true,
    "rating": 4.2
  };

  void loadProducts() {
    for (int i = 0; i < 3; i++) {
      dynamic data = product;
      products.add(data);
    }
    setState(() {
      loading = false;
    });
  }

  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
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

                      CategoryHead(title: "Wishlist"),

                      //////////////////////////////
                      ///                        ///
                      ///         Lists          ///
                      ///                        ///
                      //////////////////////////////

                      SizedBox(height: 20),

                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
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
                    ]),
                  ),
                  SliverFillRemaining(hasScrollBody: false, child: Container()),
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
