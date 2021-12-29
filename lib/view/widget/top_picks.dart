import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/model/services/ProductListApi.dart';
import 'package:silkroute/model/services/WishlistApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/pages/reseller/product.dart';

class TopPicks extends StatefulWidget {
  @override
  _TopPicksState createState() => _TopPicksState();
}

class _TopPicksState extends State<TopPicks> {
  bool loading = true, wishlist = false;
  int selected = 0;
  List products = [];
  // String url = Math().ip() + "/images/616ff5ab029b95081c237c89-color-0";
  // String url = Math().ip() + "/images/" + widget.products.id + "-main-" + 0;
  String url =
      "https://raw.githubusercontent.com/sarthak74/Yibrance-imgaes/master/category-Suit.png";
  LocalStorage storage = LocalStorage('silkroute');

  Future<void> loadImages() async {
    products = await ProductListApi().getTopPicks();
    print("top picks: $products");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadImages().then((value) async {
        // print("images: $images");
        // print("user -- , $user");
        setState(() {
          loading = false;
        });
      });
    });
  }

  List<String> urls = [
    "https://raw.githubusercontent.com/sarthak74/Yibrance-imgaes/master/category-Suit.png",
    "https://raw.githubusercontent.com/sarthak74/Yibrance-imgaes/master/category-Saree.png"
  ];

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            widthFactor: 1,
            heightFactor: 1,
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: Color(0xFF811111),
                strokeWidth: 2,
              ),
            ),
          )
        : (products == null || products.length == 0)
            ? Container()
            : Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "TOP PICKS",
                          style:
                              textStyle1(15, Colors.black54, FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_downward,
                            color: Colors.black54,
                          ),
                          iconSize: 18,
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: MediaQuery.of(context).size.width -
                        75 -
                        MediaQuery.of(context).size.width * 0.05,
                    alignment: Alignment.topCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: MediaQuery.of(context).size.width -
                              100 -
                              MediaQuery.of(context).size.width * 0.05,
                          child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (BuildContext context, int index) {
                              // String url = Math().ip() + "/images/" + widget.products.id + "-main-" + index.toString();

                              url = urls[index % 2];
                              return Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected = index;
                                      });
                                    },
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black,
                                            width: (selected == index) ? 2 : 0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          (selected == index)
                                              ? BoxShadow(
                                                  color: Color(0xFFC6C2C2),
                                                  offset: Offset(2.0, 3.0),
                                                  blurRadius: 4.0,
                                                )
                                              : BoxShadow(
                                                  color: Color(0xFFFFFFFF),
                                                  offset: Offset(0.0, 0.0),
                                                  blurRadius: 0.0,
                                                ),
                                        ],
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image:
                                              CachedNetworkImageProvider(url),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (index < products.length - 1)
                                    SizedBox(
                                        height:
                                            (MediaQuery.of(context).size.width -
                                                    100 -
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05 -
                                                    240) /
                                                3)
                                ],
                              );
                            },
                          ),
                        ),
                        // SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductPage(
                                    id: (products[selected].id).toString()),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width -
                                100 -
                                MediaQuery.of(context).size.width * 0.05,
                            height: MediaQuery.of(context).size.width -
                                100 -
                                MediaQuery.of(context).size.width * 0.05,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    NetworkImage(urls[selected % 2].toString()),
                                fit: BoxFit.contain,
                              ),
                              border: Border.all(
                                  width: 0.2, color: Color(0xFF811111)),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
  }
}
