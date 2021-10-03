import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    //loadProducts();
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.84),

              
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
