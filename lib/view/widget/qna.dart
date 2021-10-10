import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class QnA extends StatefulWidget {
  const QnA({this.faq});
  final dynamic faq;

  @override
  _QnAState createState() => _QnAState();
}

class _QnAState extends State<QnA> {
  bool isProfileExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 10),
      decoration: BoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              isProfileExpanded = !isExpanded;
            });
          },
          expandedHeaderPadding: EdgeInsets.all(0),
          animationDuration: Duration(milliseconds: 500),
          children: [
            ExpansionPanel(
              backgroundColor: Colors.grey[200],
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.question_answer,
                          size: 20, color: Colors.black54),
                      SizedBox(width: 10),
                      Text(
                        widget.faq["question"],
                        style: textStyle(13, Colors.grey[700]),
                      ),
                    ],
                  ),
                );
              },
              body: ListTile(
                title: Text(
                  widget.faq["answer"],
                  style: textStyle(13, Colors.grey[500]),
                ),
              ),
              isExpanded: isProfileExpanded,
            ),
          ],
        ),
      ),
    );
  }
}
