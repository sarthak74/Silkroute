import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/model/core/MerchantOrderItem.dart';
import 'package:silkroute/model/services/MerchantApi.dart';

import 'package:silkroute/view/dialogBoxes/merchantOrderSortDialogBox.dart';
import 'package:silkroute/view/pages/reseller/product.dart';
import 'package:silkroute/view/widget/merchantOrderTile.dart';
import 'package:silkroute/view/widget/merchantReturnOrderTile.dart';
import 'package:silkroute/view/widget/my_circular_progress.dart';
import 'package:silkroute/view/widget/show_dialog.dart';

class ReturnOrders extends StatefulWidget {
  const ReturnOrders({Key key}) : super(key: key);

  @override
  _ReturnOrdersState createState() => _ReturnOrdersState();
}

class _ReturnOrdersState extends State<ReturnOrders> {
  List _orders = [];
  bool loading = true;
  bool _btnShow = false;
  bool _sortShow = false;
  bool _filterShow = false;

  void loadVars() async {
    setState(() {
      loading = true;
    });
    // List orderss = await MerchantReturnOrderProvider().getTwentyOrders();
    _orders = await MerchantApi().getMerchantReturnOrders();
    print("_return orders: $_orders");
    setState(() {
      // orders = orderss;
      _btnShow = false;
      loading = false;
    });
  }

  void sortFunction() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionBuilder: (context, _a1, _a2, _child) {
        return ScaleTransition(
          child: _child,
          scale: CurvedAnimation(parent: _a1, curve: Curves.bounceOut),
        );
      },
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, a1, a2) {
        return ShowDialog(MerchantorderSortDialogBox(), 0);
      },
    );
    setState(() {
      _sortShow = true;
    });
  }

  void refreshList() async {
    setState(() {
      _btnShow = false;
    });
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      _orders = [];
    });

    setState(() {
      _btnShow = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // Container(
          //   margin: EdgeInsets.symmetric(
          //       vertical: 2,
          //       horizontal: MediaQuery.of(context).size.width * 0.05),
          //   height: 30,
          //   width: MediaQuery.of(context).size.width,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: <Widget>[
          //       GestureDetector(
          //         onTap: () {
          //           sortFunction();
          //         },
          //         child: Row(
          //           children: [
          //             Icon(Icons.sort, size: 25),
          //             Text(
          //               " Sort",
          //               style: textStyle(13, Colors.black),
          //             )
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // SizedBox(height: 20),

          //// ORDER LIST

          loading
              ? MyCircularProgress()
              : Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                  ),
                  height: MediaQuery.of(context).size.height * 0.58,
                  child: SingleChildScrollView(
                    child: MerchantReturnOrderTile(orders: _orders),
                  ),
                ),
        ],
      ),
    );
  }
}
