import 'package:flutter/material.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/view/dialogBoxes/request_return_dialog.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class SchedulePickupDialog extends StatefulWidget {
  const SchedulePickupDialog({Key key, this.dimensions}) : super(key: key);
  final dynamic dimensions;
  @override
  _SchedulePickupDialogState createState() => _SchedulePickupDialogState();
}

class _SchedulePickupDialogState extends State<SchedulePickupDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
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
                      "Schedule Pickup",
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
              SizedBox(height: 10),
              Column(
                children: <Widget>[
                  GetDimensionstoSchedulePickup(dimensions: widget.dimensions),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GetDimensionstoSchedulePickup extends StatefulWidget {
  const GetDimensionstoSchedulePickup({Key key, this.dimensions})
      : super(key: key);
  final dynamic dimensions;

  @override
  _GetDimensionstoSchedulePickupState createState() =>
      _GetDimensionstoSchedulePickupState();
}

class _GetDimensionstoSchedulePickupState
    extends State<GetDimensionstoSchedulePickup> {
  bool gettingPackage = true;
  int packs = 0;
  var name = ["Length", "Breadth", "Height", "Weight"];
  var dim = ["l", "b", "h", "w"];
  var dict = {"l": 0.0, "b": 0.0, "h": 0.0, "w": 0.0};
  dynamic cd = [];

  bool validate(dimensions) {
    int i = 0;
    for (var x in dimensions) {
      for (var d in dim) {
        if (x[d] < 0.5) {
          Toast().notifyErr("Package $i has incorrect dimensions");
          return false;
        }
      }
      i++;
    }
    return true;
  }

  bool schedulePickupHandler() {
    if (!validate(cd)) {
      return false;
    }
    int i = 0;
    for (var x in cd) {
      if (i == widget.dimensions.length) {
        widget.dimensions.add(dict);
      }
      for (var d in dim) {
        widget.dimensions[i][d] = x[d];
      }

      i++;
    }
    print(widget.dimensions);
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        children: <Widget>[
          if (gettingPackage)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  "Enter number of packages ready",
                  style: textStyle1(
                    11,
                    Colors.black54,
                    FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 80,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      isDense: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(
                          color: Color(0xFF811111),
                          width: 2,
                        ),
                        // borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      contentPadding: new EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 0,
                      ),
                      labelText: "Packages",
                      labelStyle:
                          textStyle1(10, Colors.black45, FontWeight.w500),
                      prefixStyle: new TextStyle(
                        color: Colors.black,
                      ),
                      hintStyle:
                          textStyle1(10, Colors.black45, FontWeight.w500),
                      hintText: "Enter a number",
                    ),
                    style: textStyle1(10, Colors.black, FontWeight.w500),
                    onChanged: (val) {
                      if (val.length == 0) {
                        val = "0";
                      }
                      packs = int.parse(val.toString());
                    },
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: InkWell(
                    onTap: () {
                      if (packs <= 0) {
                        Toast().notifyErr("Invalid number of packages");
                        return;
                      }
                      for (int i = 0; i < packs; i++) {
                        cd.add(dict);
                      }
                      print(cd);
                      setState(() {
                        gettingPackage = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF811111),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (gettingPackage == false)
            Container(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: <Widget>[
                  Text(
                    "*Packages Dimensions(cm) and weight(kg)",
                    style: textStyle1(
                      10,
                      Colors.black54,
                      FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          if (gettingPackage == false)
            ListView.builder(
              itemCount: packs,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                dynamic temp = dict;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Text(
                      "Package ${(index + 1).toString()}:",
                      style: textStyle1(10, Colors.black, FontWeight.normal),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: name
                            .map((dimension) => Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                  // padding: EdgeInsets.only(
                                  //     right: dimension != name[2]
                                  //         ? MediaQuery.of(context).size.width * 0.08
                                  //         : 0),
                                  // width: MediaQuery.of(context).size.width * 0.15,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Color(0xFF811111),
                                          width: 2,
                                        ),
                                        // borderRadius: BorderRadius.all(Radius.circular(30)),
                                      ),
                                      contentPadding: new EdgeInsets.symmetric(
                                        horizontal: 0.0,
                                        vertical: 0,
                                      ),
                                      labelText: dimension,
                                      labelStyle: textStyle1(
                                          10, Colors.black45, FontWeight.bold),
                                      prefixStyle: new TextStyle(
                                        color: Colors.black,
                                      ),
                                      hintStyle: textStyle1(
                                          10, Colors.black45, FontWeight.w500),
                                      hintText: "Enter ${dimension}",
                                    ),
                                    style: textStyle1(
                                        12, Colors.black, FontWeight.w500),
                                    onChanged: (val) {
                                      temp[dim[name.indexOf(dimension)]] =
                                          double.parse(val.toString());
                                      cd[index] = temp;
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            ),
          if (gettingPackage == false) SizedBox(height: 20),
          if (gettingPackage == false)
            InkWell(
              onTap: () {
                schedulePickupHandler();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  color: Color(0xff811111),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "Schedule Pickup",
                  style: textStyle1(
                    12,
                    Colors.white,
                    FontWeight.normal,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
