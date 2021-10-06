import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silkroute/widget/subcategory_head.dart';
import 'package:silkroute/widget/category_tile.dart';
import 'package:silkroute/widget/footer.dart';
import 'package:silkroute/widget/horizontal_list_view.dart';
import 'package:silkroute/widget/navbar.dart';
import 'package:silkroute/widget/topbar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({this.category});

  final String category;

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Map<String, String>> categories = [
    {
      "title": "Saree",
      "url":
          'https://codecanyon.img.customer.envatousercontent.com/files/201787761/banner%20intro.jpg?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=70a1c7c1e090863e2ea624db76295a0f',
    },
    {
      "title": "Bridal",
      "url":
          'https://mk0adespressoj4m2p68.kinstacdn.com/wp-content/uploads/2019/07/facebook-offer-ads.jpg',
    },
    {
      "title": "Suits",
      "url":
          'https://assets.keap.com/image/upload/v1547580346/Blog%20thumbnail%20images/Screen_Shot_2019-01-15_at_12.25.23_PM.png',
    },
    {
      "title": "Shawl",
      "url":
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuX7EvcOkWOCYRFGR78Dxa2oNQb2OPCI7uqg&usqp=CAU'
    },
  ];
  List subcategories = [];
  bool loading = true;

  void loadSubcategories() {
    for (int i = 0; i < 20; i++) {
      subcategories.add(widget.category + " Type" + i.toString());
    }
    setState(() {
      loading = false;
    });
  }

  void initState() {
    super.initState();
    loadSubcategories();
  }

  @override
  Widget build(BuildContext context) {
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
                      HorizontalListView("CATEGORIES", categories),
                      //CategoryHead(title: widget.category),

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
                                    subcategories == []
                                        ? 0
                                        : subcategories.length,
                                    (index) {
                                      return CategoryTile(
                                          id: subcategories[index]);
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
