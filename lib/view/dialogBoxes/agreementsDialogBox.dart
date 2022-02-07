import 'package:flutter/material.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class AgreementsDialogBox extends StatefulWidget {
  AgreementsDialogBox({this.userType});
  final String userType;
  @override
  _AgreementsDialogBoxState createState() => _AgreementsDialogBoxState();
}

class _AgreementsDialogBoxState extends State<AgreementsDialogBox> {
  List<List<String>> _agreements;
  bool loading = true;

  void loadVars() {
    setState(() {
      _agreements = Helpers().getAgreements(widget.userType);
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
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: loading
          ? Container(
              height: MediaQuery.of(context).size.height * 0.2,
              margin: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height * 0.2, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Color(0xFF5B0D1B),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topLeft,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Terms and Conditions",
                      style: textStyle(17, Colors.black),
                    ),
                    SizedBox(height: 25),
                    if (widget.userType != "Manufacturer")
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "General",
                          style: textStyle(13, Colors.black87),
                        ),
                      ),
                    SizedBox(height: 10),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _agreements[0].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.arrow_right, size: 15),
                            Expanded(
                              child: Text(
                                _agreements[0][index],
                                style: textStyle1(
                                  11,
                                  Colors.black87,
                                  FontWeight.w500,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 18),
                    if ((_agreements[1] ?? []).length > 0)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Return Policy",
                          style: textStyle(15, Colors.black87),
                        ),
                      ),
                    if ((_agreements[1] ?? []).length > 0) SizedBox(height: 10),
                    if ((_agreements[1] ?? []).length > 0)
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _agreements[1].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.arrow_right, size: 15),
                              Expanded(
                                child: Text(
                                  _agreements[1][index],
                                  style: textStyle1(
                                    11,
                                    Colors.black87,
                                    FontWeight.w500,
                                  ),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    SizedBox(height: 18),
                  ],
                ),
              ),
            ),
    );
  }
}
