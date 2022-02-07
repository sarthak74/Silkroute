import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silkroute/model/core/package.dart';
import 'package:silkroute/model/services/packagesApi.dart';
import 'package:silkroute/provider/PackageProvider.dart';
import 'package:silkroute/view/pages/merchant/packages.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/my_circular_progress.dart';

class SingleSelectPackageDialog extends StatefulWidget {
  const SingleSelectPackageDialog({Key key}) : super(key: key);

  @override
  _SingleSelectPackageDialogState createState() =>
      _SingleSelectPackageDialogState();
}

class _SingleSelectPackageDialogState extends State<SingleSelectPackageDialog> {
  bool loading = true;
  Future<List<Package>> futurepackages;
  List<Package> packages;
  PackageProvider packageProvider;

  void loadVars() async {
    setState(() {
      loading = true;
    });
    packages = await PackagesApi().getAllPackages();
    setState(() {
      loading = false;
    });
  }

  void addPackageHandler() async {
    // var res = await PackagesApi().create();
    // loadVars();
    packageProvider.createPackage();
  }

  @override
  void initState() {
    super.initState();
    // loadVars();
  }

  @override
  void didChangeDependencies() {
    // loadVars();
    super.didChangeDependencies();
    packageProvider = Provider.of<PackageProvider>(context);
    futurepackages = packageProvider.getAllPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),

      // contentPadding: EdgeInsets.all(20),

      child: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Select a package",
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
            SizedBox(height: 5),
            FutureBuilder(
                future: futurepackages,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.3,
                        ),
                        MyCircularProgress(
                          width: 30.0,
                          height: 30.0,
                        ),
                      ],
                    );
                  }

                  packages = snapshot.data;
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: addPackageHandler,
                              child: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Color(0xFF811111),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "*All packages full? Create a new one!",
                                style: textStyle1(
                                  11,
                                  Colors.black,
                                  FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      SingleSelectPackageList(packages: packages),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class SingleSelectPackageList extends StatefulWidget {
  const SingleSelectPackageList({Key key, this.packages}) : super(key: key);
  final dynamic packages;

  @override
  _SingleSelectPackageListState createState() =>
      _SingleSelectPackageListState();
}

class _SingleSelectPackageListState extends State<SingleSelectPackageList> {
  @override
  Widget build(BuildContext context) {
    List<Package> packages = widget.packages;
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
      child: SingleChildScrollView(
        child: ListView.builder(
          itemCount: packages.length,
          padding: EdgeInsets.only(top: 10),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int pack_i) {
            return SingleSelectPackageTile(package: packages[pack_i]);
          },
        ),
      ),
    );
  }
}

class SingleSelectPackageTile extends StatefulWidget {
  const SingleSelectPackageTile({Key key, this.package}) : super(key: key);
  final dynamic package;

  @override
  _SingleSelectPackageTileState createState() =>
      _SingleSelectPackageTileState();
}

class _SingleSelectPackageTileState extends State<SingleSelectPackageTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, widget.package);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Color(0xfff6f6f6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.package.name,
                    style: textStyle1(
                      12,
                      Colors.black,
                      FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Items: ",
                        style: textStyle1(10, Colors.black54, FontWeight.w500),
                      ),
                      Text(
                        (widget.package.items ?? []).length.toString(),
                        style: textStyle1(10, Colors.black54, FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {},
                child: Icon(
                  Icons.double_arrow_rounded,
                  size: 18,
                  color: Colors.black45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
