import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class CouponsDialog extends StatefulWidget {
  const CouponsDialog({Key key, this.coupons}) : super(key: key);

  final dynamic coupons;

  @override
  _CouponsDialogState createState() => _CouponsDialogState();
}

class _CouponsDialogState extends State<CouponsDialog> {
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
                    "Applied Coupons",
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
            child: (widget.coupons.length > 0)
                ? SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.coupons.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Card(
                          elevation: 5,
                          margin:
                              EdgeInsets.only(bottom: 10, right: 5, left: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.network(
                                    widget.coupons[i]["link"],
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
                                        widget.coupons[i]["code"],
                                        style: textStyle1(
                                          13,
                                          Colors.black,
                                          FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        widget.coupons[i]["description"],
                                        style: textStyle1(
                                          13,
                                          Colors.black54,
                                          FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Amount: ₹${widget.coupons[i]["amount"]}',
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
                      style: textStyle(20, Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
