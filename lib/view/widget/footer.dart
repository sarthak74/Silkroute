import 'package:flutter/material.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/core/User.dart';
import 'package:silkroute/model/services/ProductListApi.dart';
import 'package:silkroute/provider/ProductListProvider.dart';
import 'package:silkroute/view/pages/reseller/category.dart';
import 'package:silkroute/view/pages/reseller/reseller_home.dart';

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/reseller_home");
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.shop),
                Text("Market"),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryPage(
                      categories: ResellerHome.categoriess,
                      category: ResellerHome.categoriess[0]),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.widgets),
                Text("Categories"),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/search");
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.search),
                Text("Search"),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/wishlist");
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.widgets),
                Text("Wishlist"),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/crate");
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.shopping_cart),
                Text("Crate"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
