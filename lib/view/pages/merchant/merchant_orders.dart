import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';
import 'package:silkroute/view/widget2/footer.dart';

class MerchantOrders extends StatefulWidget {
  const MerchantOrders({Key key}) : super(key: key);

  @override
  _MerchantOrdersState createState() => _MerchantOrdersState();
}

class _MerchantOrdersState extends State<MerchantOrders> {
  List orders = [];
  bool loading = true;

  void loadVars() {
    setState(() {
      dynamic order = {
        "id": "1",
        "title": "Kanjeevaram Silk Saree",
        "dispatchDate": "16/11/2021",
        "invoiceNumber": "RTGF14173314",
        "paymentStatus": "Completed"
      };
      for (int i = 0; i < 10; i++) {
        orders.add(order);
      }
      loading = false;
    });
  }

  @override
  void initState() {
    loadVars();
    super.initState();
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),

              Expanded(
                child: loading
                    ? Text("Loading")
                    : CustomScrollView(slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Icon(
                              Icons.receipt_long,
                              size: MediaQuery.of(context).size.height * 0.1,
                            ),
                            SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: orders.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/1.png"),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.59,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              orders[i]["title"],
                                              style:
                                                  textStyle(12, Colors.black),
                                            ),
                                            Text(
                                              "Dispatch Date: " +
                                                  orders[i]["dispatchDate"],
                                              style:
                                                  textStyle(12, Colors.black45),
                                            ),
                                            Text(
                                              "Invoice No.: " +
                                                  orders[i]["invoiceNumber"],
                                              style:
                                                  textStyle(12, Colors.black45),
                                            ),
                                            Text(
                                              "Payment Status: " +
                                                  orders[i]["paymentStatus"],
                                              style:
                                                  textStyle(12, Colors.black45),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          ]),
                        ),
                        SliverFillRemaining(
                            hasScrollBody: false, child: Container()),
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
      ),
    );
  }
}
