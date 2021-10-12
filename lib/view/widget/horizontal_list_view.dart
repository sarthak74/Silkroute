import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/view/pages/reseller/category.dart';

class HorizontalListView extends StatefulWidget {
  HorizontalListView(this.title, this.productList);
  final List<dynamic> productList;
  final String title;

  _HorizontalListViewState createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  LocalStorage storage = LocalStorage("silkroute");
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.black54,
                ),
                iconSize: 18,
                onPressed: null,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: widget.productList.map((product) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 75.0,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 75,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(37.5)),
                        ),
                        child: ClipRRect(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryPage(
                                      categories: widget.productList,
                                      category: product),
                                ),
                              );
                            },
                            child: Image.network(
                              product["url"],
                              // width: 300,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(child: Text(product["title"])),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
