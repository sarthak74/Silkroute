import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/product.dart';
import 'package:silkroute/view/pages/reseller/productlist.dart';

class CategoryTile extends StatefulWidget {
  const CategoryTile({this.id});

  final String id;

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductListPage(headtext: widget.id)),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.width * 0.03,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
          color: Colors.grey[500],
        ),
        alignment: Alignment.center,
        child: Text(
          widget.id,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
