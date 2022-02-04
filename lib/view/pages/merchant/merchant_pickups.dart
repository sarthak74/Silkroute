import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/model/services/MerchantApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/my_circular_progress.dart';

class MerchantPickups extends StatefulWidget {
  const MerchantPickups({Key key}) : super(key: key);

  @override
  _MerchantPickupsState createState() => _MerchantPickupsState();
}

class _MerchantPickupsState extends State<MerchantPickups> {
  bool loading = true;
  dynamic pickups = [];
  void loadVars() async {
    setState(() {
      loading = true;
    });
    pickups = await MerchantApi().getAllPickups();
    print("pickups: $pickups");
    setState(() {
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
    return loading
        ? Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.3,
              ),
              MyCircularProgress(
                width: 30.0,
                height: 30.0,
              ),
            ],
          )
        : Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "YOUR PICKUPS",
                  style: textStyle1(
                    13,
                    Colors.black,
                    FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10),
              (pickups == null || pickups.length == 0)
                  ? Text(
                      "No packages, Create one now!",
                      style: textStyle1(
                        12,
                        Colors.black54,
                        FontWeight.w500,
                      ),
                    )
                  : PickupList(pickups: pickups),
            ],
          );
  }
}

class PickupList extends StatefulWidget {
  const PickupList({Key key, this.pickups}) : super(key: key);
  final dynamic pickups;

  @override
  _PickupListState createState() => _PickupListState();
}

class _PickupListState extends State<PickupList> {
  @override
  Widget build(BuildContext context) {
    dynamic pickups = widget.pickups;
    dynamic shipids = pickups.keys.toList();
    // print("shids: $pickups");
    return Container(
      height: MediaQuery.of(context).size.height * 0.58,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        itemCount: shipids.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int pack_i) {
          dynamic shiprocket = pickups[shipids[pack_i]]["shiprocket"];
          dynamic order = pickups[shipids[pack_i]]["orders"];
          Set<String> packs = <String>{};
          order.forEach((id, items) =>
              items.forEach((item) => packs.add(item['package'])));
          var docs = {
            "Label": shiprocket['label_url'],
            "Manifest": shiprocket['manifest_url'],
            "Invoice": shiprocket['invoice_url']
          };
          return InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                color: Color(0xfff6f6f6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Shipment Id: ",
                              style: textStyle1(
                                11,
                                Colors.black,
                                FontWeight.w500,
                              ),
                            ),
                            Text(
                              shipids[pack_i].toString(),
                              style: textStyle1(
                                11,
                                Colors.black,
                                FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              "Est. Time: ",
                              style: textStyle1(
                                10,
                                Colors.black,
                                FontWeight.w500,
                              ),
                            ),
                            Text(
                              DateFormat('dd-MM-yy').format(DateTime.parse(
                                      shiprocket['pickup_scheduled_date']
                                              ['date']
                                          .toString()
                                          .split(' ')[0]
                                          .toString())) +
                                  " (${shiprocket['pickup_scheduled_date']['date'].toString().split(' ')[1].substring(0, 5)})",
                              style: textStyle1(
                                10,
                                Colors.black54,
                                FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Token No.: ",
                              style: textStyle1(
                                10,
                                Color(0xff811111),
                                FontWeight.w500,
                              ),
                            ),
                            Text(
                              shiprocket['pickup_token_number']
                                  .split(":")[1]
                                  .toString(),
                              style: textStyle1(
                                10,
                                Colors.black54,
                                FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(width: 1),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        await Helpers().pickupDetails(
                            context,
                            pickups[shipids[pack_i]]['orders'],
                            docs,
                            shiprocket['applied_weight']);
                      },
                      child: Icon(
                        Icons.double_arrow_rounded,
                        size: 18,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
