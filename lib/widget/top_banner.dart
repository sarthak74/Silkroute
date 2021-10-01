import 'package:flutter/material.dart';

class TopBanner extends StatefulWidget {
  TopBanner(this.title, this.description);
  final String title, description;
  TopBannerState createState() => TopBannerState();
}

class TopBannerState extends State<TopBanner> {
  @override
  Widget build(BuildContext context) {
    // change();
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.teal,
            Colors.teal[200],
          ],
        ),
      ),
      child: new Align(
        alignment: Alignment.topLeft,
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                new Column(
                  children: <Widget>[
                    new SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    new Text(
                      widget.title,
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
