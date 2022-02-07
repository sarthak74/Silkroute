import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silkroute/provider/ProductListProvider.dart';
import 'package:silkroute/view/pages/reseller/product.dart';
import 'package:silkroute/view/pages/reseller/productlist.dart';
import 'package:silkroute/view/widget/custom_network_image.dart';

class CategoryTile extends StatefulWidget {
  const CategoryTile({this.category, this.subCat});

  final dynamic subCat;
  final String category;

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    print("sasa-${widget.subCat}");
    return GestureDetector(
      onTap: () {
        setState(() {
          ProductListProvider().filter["subCat"] = [widget.subCat['title']];
          print("subCats: ${ProductListProvider().filter["subCat"]}");
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductListPage(
                  category: widget.category, subCat: widget.subCat['title'])),
        );
      },
      // child: Container(
      //   margin: EdgeInsets.symmetric(
      //     horizontal: MediaQuery.of(context).size.width * 0.02,
      //     vertical: MediaQuery.of(context).size.width * 0.03,
      //   ),
      //   decoration: BoxDecoration(
      //     // borderRadius: BorderRadius.all(
      //     //   Radius.circular(20),
      //     // ),
      //     image: DecorationImage(
      //       image: NetworkImage(widget.subCat['url'] + "?raw=true"),
      //       fit: BoxFit.fill,
      //     ),
      //   ),
      //   alignment: Alignment.center,
      // ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.width * 0.03,
        ),
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.all(
            //   Radius.circular(20),
            // ),

            ),
        child: CustomNetworkImage(
            url: widget.subCat['url'] + "?raw=true".toString()),
      ),
    );
  }
}
