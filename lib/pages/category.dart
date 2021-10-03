import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silkroute/widget/category_head.dart';
import 'package:silkroute/widget/category_product_tile.dart';
import 'package:silkroute/widget/footer.dart';
import 'package:silkroute/widget/navbar.dart';
import 'package:silkroute/widget/topbar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({this.category});

  final String category;

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List products = [];
  bool loading = true;

  void loadProducts() {
    for (int i = 0; i < 20; i++) {
      products.add(i.toString());
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
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
      child: Scaffold(
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

                      CategoryHead(title: widget.category),

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
                                  crossAxisCount: 2,
                                  children: List.generate(
                                    products == [] ? 0 : products.length,
                                    (index) {
                                      return CategoryProductTile(
                                          id: products[index]);
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
