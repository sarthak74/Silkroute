import 'package:flutter/material.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/shiprocketApi.dart';
import 'package:silkroute/view/dialogBoxes/request_return_dialog.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/my_circular_progress.dart';

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
                          Navigator.pop(context, false);
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
  // widget.dimensions == selected packages
  int packs = 0;
  var name = ["Length", "Breadth", "Height", "Weight"];
  var dim = ["l", "b", "h", "w"];
  var dict = {"l": 0.0, "b": 0.0, "h": 0.0, "w": 0.0};
  dynamic cd = [];
  bool loading = false;

  bool validate(dimensions) {
    return true;
    int i = 0;
    for (var x in dimensions) {
      for (var d in dim) {
        if ((x[d] ?? 0) < 0.5) {
          Toast().notifyErr("${x['name']} has incorrect dimensions");
          return false;
        }
      }
      i++;
    }
    return true;
  }

  void schedulePickupHandler() async {
    if (validate(widget.dimensions)) {
      setState(() {
        loading = true;
      });

      var shipres =
          await ShiprocketApi().createOrderFromPackage(widget.dimensions);
      print("shipres: $shipres");
      setState(() {
        loading = false;
      });
      Navigator.pop(context, shipres);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: MyCircularProgress())
        : Container(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              children: <Widget>[
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
                ListView.builder(
                  itemCount: widget.dimensions.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    dynamic temp = dict;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Text(
                          "${widget.dimensions[index]['name']}",
                          style:
                              textStyle1(10, Colors.black, FontWeight.normal),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: name
                                .map((dimension) => Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
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
                                          contentPadding:
                                              new EdgeInsets.symmetric(
                                            horizontal: 0.0,
                                            vertical: 0,
                                          ),
                                          labelText: dimension,
                                          labelStyle: textStyle1(10,
                                              Colors.black45, FontWeight.bold),
                                          prefixStyle: new TextStyle(
                                            color: Colors.black,
                                          ),
                                          hintStyle: textStyle1(10,
                                              Colors.black45, FontWeight.w500),
                                          hintText: "Enter ${dimension}",
                                        ),
                                        style: textStyle1(
                                            12, Colors.black, FontWeight.w500),
                                        onChanged: (val) {
                                          temp[dim[name.indexOf(dimension)]] =
                                              double.parse(val.toString());
                                          for (var d in dim) {
                                            widget.dimensions[index][d] =
                                                temp[d];
                                          }
                                          // print("$temp\n${widget.dimensions}");
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
                SizedBox(height: 20),
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
