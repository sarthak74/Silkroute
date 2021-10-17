import 'package:flutter/material.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/services/MerchantHomeAPI.dart';
import 'package:silkroute/provider/ProductListProvider.dart';
import 'package:silkroute/view/pages/reseller/order_page.dart';
import 'package:silkroute/view/widget/product_tile.dart';

class AllProducts extends StatefulWidget {
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  List<ProductList> _products;
  dynamic _productProvider = new ProductListProvider();
  bool loading = true;

  void loadVars() async {
    var pr = await MerchantHomeApi().getEightProducts();
    setState(() {
      _products = pr;
      loading = false;
    });
  }

  @override
  void initState() {
    loadVars();
    _productProvider.search();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "ALL PRODUCTS",
                style: textStyle(
                  18,
                  Colors.black54,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: null,
                child: Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          loading
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.2,
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
              : GridView.count(
                  childAspectRatio: Math().aspectRatio(context),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: List.generate(
                    _products == [] ? 0 : _products.length,
                    (index) {
                      return ProductTile(
                        product: _products[index],
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
