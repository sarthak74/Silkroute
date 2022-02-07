import 'package:flutter/material.dart';
import 'package:silkroute/model/core/package.dart';
import 'package:silkroute/model/services/packagesApi.dart';
import 'package:silkroute/provider/PackageProvider.dart';
import 'package:silkroute/view/pages/merchant/merchant_order_detail.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/my_circular_progress.dart';

String packageId;

class PackageDetail extends StatefulWidget {
  const PackageDetail({Key key, this.package, this.packageProvider})
      : super(key: key);
  final dynamic package;
  final PackageProvider packageProvider;

  @override
  _PackageDetailState createState() => _PackageDetailState();
}

class _PackageDetailState extends State<PackageDetail> {
  @override
  Widget build(BuildContext context) {
    Package package = widget.package;
    packageId = widget.package.id;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),

      // contentPadding: EdgeInsets.all(20),

      child: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "${package.name}  Details",
                      style: textStyle1(
                        13,
                        Colors.black,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.black87,
                          size: 30,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              (package.items == null ||
                      package.items == [] ||
                      package.items.length == 0)
                  ? Text(
                      "Empty Package",
                      style: textStyle1(
                        12,
                        Colors.black54,
                        FontWeight.w500,
                      ),
                    )
                  : PackageItems(
                      items: package.items,
                      packageProvider: widget.packageProvider),
            ],
          ),
        ),
      ),
    );
  }
}

class PackageItems extends StatefulWidget {
  const PackageItems({Key key, this.items, this.packageProvider})
      : super(key: key);
  final dynamic items;
  final PackageProvider packageProvider;

  @override
  _PackageItemsState createState() => _PackageItemsState();
}

class _PackageItemsState extends State<PackageItems> {
  bool loading = true;
  dynamic items = {}, orders = [];
  void loadVars() async {
    print("--c-- ${widget.items}");
    setState(() {
      loading = true;
    });
    var c = widget.items;
    for (var x in c) {
      if (items[x['orderId']] == null) {
        items[x['orderId']] = [];
      }
      items[x['orderId']].add(x["productId"]);
    }
    await items.forEach((k, v) => orders.add({"id": k, "items": v}));

    setState(() {
      loading = false;
    });
  }

  void initState() {
    super.initState();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            height: 25,
            width: 25,
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xff811111),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int pack_i) {
              return PackageOrder(
                  order: orders[pack_i],
                  packageProvider: widget.packageProvider);
            },
          );
  }
}

class PackageOrder extends StatefulWidget {
  const PackageOrder({Key key, this.order, this.packageProvider})
      : super(key: key);
  final dynamic order;
  final PackageProvider packageProvider;

  @override
  _PackageOrderState createState() => _PackageOrderState();
}

class _PackageOrderState extends State<PackageOrder> {
  @override
  Widget build(BuildContext context) {
    var order = widget.order;
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Color(0xfff6f6f6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Order ID: ",
                    style: textStyle1(
                      11,
                      Colors.black,
                      FontWeight.w500,
                    ),
                  ),
                  Text(
                    order['id'],
                    style: textStyle1(
                      11,
                      Colors.black,
                      FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 5),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => MerchantOrderDetail(
                  //       order: widget.order,
                  //     ),
                  //   ),
                  // );
                },
                child: Icon(
                  Icons.double_arrow_outlined,
                  color: Colors.black,
                  size: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          PackageOrderItems(
            items: order['items'],
            orderId: order['id'],
            packageProvider: widget.packageProvider,
          ),
        ],
      ),
    );
  }
}

class PackageOrderItems extends StatefulWidget {
  const PackageOrderItems(
      {Key key, this.items, this.orderId, this.packageProvider})
      : super(key: key);
  final dynamic items, orderId;
  final PackageProvider packageProvider;
  @override
  _PackageOrderItemsState createState() => _PackageOrderItemsState();
}

class _PackageOrderItemsState extends State<PackageOrderItems> {
  bool removing = false;
  dynamic items;
  void removeItemFromPackHandler(int index) async {
    setState(() {
      removing = true;
    });
    var data = {
      "orderId": widget.orderId,
      "productId": widget.items[index],
      "packageId": packageId
    };
    await widget.packageProvider.removeAnItem(data);
    setState(() {
      widget.items.remove(widget.items[index]);
      items = widget.items;
      removing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    items = widget.items;
    return removing
        ? MyCircularProgress(width: 20, height: 20)
        : ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            itemBuilder: (BuildContext context, int item_i) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Item ID: ",
                        style: textStyle1(
                          10,
                          Colors.black,
                          FontWeight.w500,
                        ),
                      ),
                      Text(
                        items[item_i],
                        style: textStyle1(
                          10,
                          Colors.black,
                          FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      await removeItemFromPackHandler(item_i);
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline_sharp,
                        color: Colors.red,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
  }
}
