import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';
import 'package:silkroute/view/widget2/footer.dart';

class MerchantDashboard extends StatefulWidget {
  @override
  _MerchantDashboardState createState() => _MerchantDashboardState();
}

class _MerchantDashboardState extends State<MerchantDashboard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Navbar(),
        primary: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/1.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: <Widget>[
              //////////////////////////////
              ///                        ///
              ///         TopBar         ///
              ///                        ///
              //////////////////////////////

              TopBar(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF5B0D1B), width: 2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    color: Colors.white,
                  ),
                  child: CustomScrollView(slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.speed,
                                size: MediaQuery.of(context).size.height * 0.1,
                                color: Color(0xFF5B0D1B),
                              ),
                              SizedBox(height: 20),

                              //////// THIS MONTH

                              DashboardThisMonth(),

                              SizedBox(height: 20),

                              //////// THIS WEEK

                              DashboardThisWeek(),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    SliverFillRemaining(
                        hasScrollBody: false, child: Container()),
                  ]),
                ),
              ),

              //////////////////////////////
              ///                        ///
              ///         Footer         ///
              ///                        ///
              //////////////////////////////
              Footer(),
            ],
          ),
        ),
        // bottomNavigationBar: Footer(),
      ),
    );
  }
}

class DashboardThisWeek extends StatelessWidget {
  const DashboardThisWeek({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "This Week",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        "Total Earnings",
                        style: textStyle(12, Colors.black54),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        "Bonus",
                        style: textStyle(12, Colors.black54),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        "₹30999.9",
                        style: textStyle(18, Colors.black54),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        "₹3099.9",
                        style: textStyle(18, Colors.black54),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey[500],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "07 Orders Pending",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "18 Orders Completed",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardThisMonth extends StatelessWidget {
  const DashboardThisMonth({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "This Month",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            height: MediaQuery.of(context).size.height * 0.16,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        "Total Earnings",
                        style: textStyle(12, Colors.black54),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        "Bonus",
                        style: textStyle(12, Colors.black54),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        "₹5999.9",
                        style: textStyle(18, Colors.black54),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text(
                        "₹599.9",
                        style: textStyle(18, Colors.black54),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Details & Invoices",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
