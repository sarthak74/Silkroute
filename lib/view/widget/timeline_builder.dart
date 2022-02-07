import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:timelines/timelines.dart';

class TimelineBuilder extends StatefulWidget {
  const TimelineBuilder({Key key, this.list, this.currentStatus})
      : super(key: key);
  final List<String> list;
  final String currentStatus;

  @override
  _TimelineBuilderState createState() => _TimelineBuilderState();
}

class _TimelineBuilderState extends State<TimelineBuilder> {
  @override
  Widget build(BuildContext context) {
    var si = widget.list.indexOf(widget.currentStatus);

    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0,
        color: Color(0xFF811111),
        indicatorTheme: IndicatorThemeData(
          position: 0,
          size: 20.0,
        ),
        connectorTheme: ConnectorThemeData(
          thickness: 2.5,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        itemCount: widget.list.length,
        connectionDirection: ConnectionDirection.before,
        contentsBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8, left: 8),
            child: Text(
              widget.list[index],
              style: textStyle1(
                10,
                Colors.black87,
                si == index ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          );
        },
        indicatorBuilder: (_, index) {
          if (si >= index) {
            return DotIndicator(
              color: Color(0xFF811111),
              size: 18,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 12.0,
              ),
            );
          } else {
            return OutlinedDotIndicator(
              size: 18,
              borderWidth: 2.5,
            );
          }
        },
        connectorBuilder: (_, index, ___) => SolidLineConnector(
          color: si >= index ? Color(0xFF811111) : null,
        ),
      ),
    );
  }
}
