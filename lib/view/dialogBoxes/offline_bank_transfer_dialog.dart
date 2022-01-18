import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silkroute/model/services/PaymentGatewayService.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:timer_builder/timer_builder.dart';

String formatDuration(Duration d) {
  // print(d);
  String f(int n) {
    return n.toString().padLeft(2, '0');
  }

  // We want to round up the remaining time to the nearest second
  d += Duration(microseconds: 999999);
  return "${f(d.inHours)}:${f(d.inMinutes % 60)}:${f(d.inSeconds % 60)}";
}

class OfflineBankTransferDialog extends StatefulWidget {
  const OfflineBankTransferDialog(this.orderId, {Key key}) : super(key: key);
  final String orderId;

  @override
  _OfflineBankTransferDialogState createState() =>
      _OfflineBankTransferDialogState();
}

class _OfflineBankTransferDialogState extends State<OfflineBankTransferDialog> {
  bool loading = true, error = false;
  dynamic bankDetails, details = [];
  DateTime startTime, endTime;
  List<String> fields = [
    "name",
    "bankName",
    "ifsc",
    "createdAt",
    "closeBy",
    "amountExpected",
    "accountNumber"
  ];

  Map<String, String> getTitle = {
    "name": "Name",
    "bankName": "Bank Name",
    "ifsc": "IFSC",
    "createdAt": "Created At",
    "closeBy": "Close By",
    "amountExpected": "Amount Expected",
    "accountNumber": "Account Number"
  };

  void loadVars() async {
    setState(() {
      loading = true;
    });
    final res =
        await PaymentGatewayService().createVirtualAccount(widget.orderId);
    bankDetails = res;
    print("$bankDetails");
    if (bankDetails['success'] == false) {
      error = true;
    } else {
      bankDetails = res['va_details'];
      final f = new DateFormat('yyyy-MM-dd hh:mm');
      startTime = DateTime.parse(bankDetails['createdAt'].toString());
      endTime = startTime.add(
        Duration(hours: 6),
      );
      bankDetails['closeBy'] = f.format(endTime).toString();

      bankDetails['createdAt'] = f.format(startTime).toString();

      for (var x in fields) {
        details.add({
          "title": getTitle[x].toString(),
          "value": bankDetails[x].toString()
        });
      }
      print("$details");
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
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      contentPadding: EdgeInsets.all(20),
      title: loading
          ? Center(
              widthFactor: 1,
              heightFactor: 1,
              child: CircularProgressIndicator(
                color: Color(0xFF811111),
                strokeWidth: 3,
              ),
            )
          : Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Bank Details",
                      style: textStyle1(
                        17,
                        Colors.black87,
                        FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                          size: 25,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                error
                    ? Text(
                        "Some error occurred",
                        style: textStyle1(
                          15,
                          Colors.grey,
                          FontWeight.w500,
                        ),
                      )
                    : BankDetails(details),
              ],
            ),
    );
  }

  Widget BankDetails(details) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          DataTable(
            horizontalMargin: 10,
            headingRowHeight: 0,
            showBottomBorder: true,
            columns: <DataColumn>[
              DataColumn(
                label: Text("Details"),
              ),
            ],
            rows: List<DataRow>.generate(
              details.length,
              (int index) => BankDetailRow(details[index]),
            ),
          ),
          SizedBox(height: 10),
          TimerBuilder.scheduled([DateTime.parse(bankDetails['closeBy'])],
              builder: (context) {
            // This function will be called once the alert time is reached
            var now = DateTime.now();
            var reached =
                now.compareTo(DateTime.parse(bankDetails['closeBy'])) >= 0;
            final textStyle = textStyle1(13, Colors.red, FontWeight.w500);
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  !reached
                      ? TimerBuilder.periodic(Duration(seconds: 1),
                          alignment: Duration.zero, builder: (context) {
                          // This function will be called every second until the alert time
                          var now = DateTime.now();
                          var remaining = DateTime.parse(bankDetails['closeBy'])
                              .difference(now);
                          return Text(
                            formatDuration(remaining),
                            style: textStyle,
                          );
                        })
                      : Text("Account expired", style: textStyle),
                ],
              ),
            );
          }),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  DataRow BankDetailRow(detail) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(
                  detail["title"].toString(),
                  style: textStyle1(13, Colors.black, FontWeight.w500),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  detail["value"].toString(),
                  style: textStyle1(13, Colors.black, FontWeight.w500),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
