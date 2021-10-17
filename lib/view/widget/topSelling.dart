import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/order_page.dart';

class TopSelling extends StatefulWidget {
  @override
  _TopSellingState createState() => _TopSellingState();
}

class _TopSellingState extends State<TopSelling> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 10,
      ),
      height: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "TOP SELLING",
                style: textStyle(
                  18,
                  Colors.black54,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: null,
                child: Icon(
                  Icons.arrow_downward,
                  size: 20,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.22,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          image: AssetImage("assets/images/1.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: null,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          image: AssetImage("assets/images/1.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: null,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          image: AssetImage("assets/images/1.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: null,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage("assets/images/1.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: GestureDetector(
                  onTap: null,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
