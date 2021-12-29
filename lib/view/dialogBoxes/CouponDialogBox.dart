import 'package:flutter/material.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:silkroute/model/services/CrateApi.dart';
import 'package:silkroute/model/services/couponApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class CouponsDialog extends StatefulWidget {
  const CouponsDialog({Key key, this.coupons}) : super(key: key);

  final dynamic coupons;

  @override
  _CouponsDialogState createState() => _CouponsDialogState();
}

class _CouponsDialogState extends State<CouponsDialog> {
  bool loading = true;

  dynamic user, bill, orderAmount, _coupons;

  void loadVars() async {
    if (widget.coupons == null) {
      // means accessing from reseller profile page
      user = await Methods().getUser();
      dynamic res = await CrateApi().getCrateItems();
      bill = res.item2.toMap();
      orderAmount = bill["totalValue"] - bill["implicitDiscount"];
      _coupons = await CouponApi().getCoupons(user["contact"], 0);
    } else {
      _coupons = widget.coupons;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (widget.coupons == null)
                        ? "Available Coupons"
                        : "Applied Coupons",
                    style: textStyle(18, Colors.black),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Icon(Icons.close),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: loading
                ? Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xFF811111),
                      ),
                    ),
                  )
                : ((_coupons.length > 0)
                    ? SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _coupons.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Card(
                              elevation: 5,
                              margin: EdgeInsets.only(
                                  bottom: 10, right: 5, left: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.network(
                                        _coupons[i]["link"],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _coupons[i]["code"],
                                            style: textStyle1(
                                              13,
                                              Colors.black,
                                              FontWeight.w700,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            _coupons[i]["description"],
                                            style: textStyle1(
                                              13,
                                              Colors.black54,
                                              FontWeight.w500,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Validity: ${_coupons[i]["validity"].toString().substring(0, 10)}',
                                            style: textStyle1(
                                              13,
                                              Colors.black54,
                                              FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Text(
                          "No coupons available",
                          style: textStyle1(20, Colors.grey, FontWeight.w500),
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}
