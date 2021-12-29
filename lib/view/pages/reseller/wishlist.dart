import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/services/WishlistApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/subcategory_head.dart';
import 'package:silkroute/view/widget/product_tile.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  LocalStorage storage = LocalStorage('silkroute');
  List<ProductList> products = [];
  bool loading = true;

  void loadVars() async {
    var pp = await WishlistApi().getProd();
    setState(() {
      products = pp;
      loading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadVars();
    });
    super.initState();
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

                      CategoryHead(
                        title: "Wishlist",
                        icon: Icon(
                          FontAwesomeIcons.solidBookmark,
                          color: Color(0xFF811111),
                          size: 25,
                        ),
                      ),

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
                        height: MediaQuery.of(context).size.height * 0.62,
                        alignment: Alignment.center,
                        child: (products.length > 0)
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: loading
                                    ? Text("Loading")
                                    : GridView.count(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        childAspectRatio: aspectRatio,
                                        crossAxisCount: 2,
                                        children: List.generate(
                                          (products == [] || products == null)
                                              ? 0
                                              : products.length,
                                          (index) {
                                            return ProductTile(
                                                product: products[index]);
                                          },
                                        ),
                                      ),
                              )
                            : Center(
                                child: Text(
                                  "No Items to show",
                                  style: textStyle(15, Colors.grey[400]),
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
