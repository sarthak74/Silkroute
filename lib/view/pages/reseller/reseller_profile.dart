import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/profile_pic_picker.dart';
import 'package:silkroute/view/widget/subcategory_head.dart';
import 'package:silkroute/view/widget/text_field.dart';
import 'package:silkroute/view/widget/topbar.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:getwidget/getwidget.dart';

TextStyle textStyle(num size, Color color) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      color: color,
      fontSize: size.toDouble(),
      fontWeight: FontWeight.bold,
    ),
  );
}

class ResellerProfile extends StatefulWidget {
  @override
  _ResellerProfileState createState() => _ResellerProfileState();
}

class _ResellerProfileState extends State<ResellerProfile> {
  LocalStorage storage = LocalStorage('silkroute');

  @override
  void initState() {
    super.initState();
  }

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
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),

              Expanded(
                child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      // PROFILE IMAGE
                      ProfileImageBar(),

                      SizedBox(height: 20),

                      // MIDDLE CONTAINER
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey[200],
                        ),
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      SizedBox(height: 20),

                      // OPTIONS LIST
                      OptionsList(),

                      SizedBox(height: 20),

                      // PROFILE DETAIL CONTAINER

                      ProfileDetailContainer(),

                      // LOGOUT BUTTON
                      LogoutButton(),
                    ]),
                  ),
                  SliverFillRemaining(hasScrollBody: false, child: Container()),
                ]),
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
      ),
    );
  }
}

class ProfileImageBar extends StatefulWidget {
  @override
  _ProfileImageBarState createState() => _ProfileImageBarState();
}

class _ProfileImageBarState extends State<ProfileImageBar> {
  LocalStorage storage = LocalStorage('silkroute');
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          top: MediaQuery.of(context).size.width * 0.1),
      child: Row(
        children: <Widget>[
          ProfilePic(storage.getItem('contact')),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                storage.getItem('name'),
                style: textStyle(15, Colors.black),
              ),
              SizedBox(height: 5),
              Text(
                'Points: 309',
                style: textStyle(12, Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LogoutButton extends StatefulWidget {
  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Methods().logout(context);
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color(0xFF5B0D1B),
        ),
        child: Text(
          "Logout",
          style: textStyle(15, Colors.white),
        ),
      ),
    );
  }
}

class OptionsList extends StatefulWidget {
  @override
  _OptionsListState createState() => _OptionsListState();
}

class _OptionsListState extends State<OptionsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.grey[200],
      ),
      child: Column(
        children: <Widget>[
          OptionRow(
            prefixIcon: Icons.receipt,
            title: "Refer & Earn",
            suffixIcon: Icons.arrow_forward,
          ),
          OptionRow(
            prefixIcon: Icons.receipt,
            title: "Coupons",
            suffixIcon: Icons.arrow_forward,
          ),
          OptionRow(
            prefixIcon: Icons.receipt,
            title: "Actions",
            suffixIcon: Icons.arrow_forward,
          ),
          OptionRow(
            prefixIcon: Icons.card_membership,
            title: "Saved Cards",
            suffixIcon: Icons.edit,
          ),
          OptionRow(
            prefixIcon: Icons.receipt,
            title: "GSTIN",
            suffixIcon: Icons.edit,
          ),
        ],
      ),
    );
  }
}

class ProfileDetailContainer extends StatefulWidget {
  @override
  _ProfileDetailContainerState createState() => _ProfileDetailContainerState();
}

class _ProfileDetailContainerState extends State<ProfileDetailContainer> {
  bool isProfileExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
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
                      Icon(Icons.person, size: 20, color: Colors.black54),
                      SizedBox(width: 10),
                      Text(
                        "Profile Details",
                        style: textStyle(15, Colors.grey[700]),
                      ),
                    ],
                  ),
                );
              },
              body: ListTile(
                title: ProfileDetailsList(),
              ),
              isExpanded: isProfileExpanded,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailsList extends StatefulWidget {
  @override
  _ProfileDetailsListState createState() => _ProfileDetailsListState();
}

class _ProfileDetailsListState extends State<ProfileDetailsList> {
  dynamic personDetail = {}, loading = true;

  void loadPerson() {
    setState(() {
      personDetail = {
        "name": "Sarthak Gupta",
        "contact": "7408159898",
        "address": "Atarra, UP",
        "email": "abulpakir@jainulabdeen.abdulkalam",
        "alternateContact": "8989518047"
      };
    });
  }

  void initState() {
    super.initState();
    loadPerson();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text("Loading")
        : Column(
            children: <Widget>[
              PersonDetailRow(data: personDetail['name']),
              PersonDetailRow(data: personDetail['contact']),
              PersonDetailRow(data: personDetail['address']),
              PersonDetailRow(data: personDetail['email']),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Divider(color: Colors.black54),
              ),
              PersonDetailRow(data: personDetail['alternateContact']),
            ],
          );
  }
}

class PersonDetailRow extends StatelessWidget {
  const PersonDetailRow({this.data});
  final String data;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01, vertical: 5),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[500], width: 2),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            this.data,
            style: textStyle(12, Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class OptionRow extends StatefulWidget {
  const OptionRow(
      {this.prefixIcon, this.title, this.suffixIcon, this.function});
  final IconData prefixIcon, suffixIcon;
  final String title;
  final Function function;
  @override
  _OptionRowState createState() => _OptionRowState();
}

class _OptionRowState extends State<OptionRow> {
  TextStyle textStyle(num size, Color color) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: color,
        fontSize: size.toDouble(),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(widget.prefixIcon, size: 18, color: Colors.black),
        Text(widget.title, style: textStyle(15, Colors.black54)),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(
              widget.suffixIcon,
              size: 18,
              color: Colors.blue,
            ),
            onPressed: widget.function,
          ),
        ),
      ],
    );
  }
}