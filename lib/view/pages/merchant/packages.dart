import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/model/core/package.dart';
import 'package:silkroute/model/services/packagesApi.dart';
import 'package:silkroute/provider/PackageProvider.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/my_circular_progress.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

class Packages extends StatefulWidget {
  const Packages({Key key}) : super(key: key);

  @override
  _PackagesState createState() => _PackagesState();
}

PackageProvider packageProvider;

class _PackagesState extends State<Packages> {
  String contact;
  bool loading = true;
  Future<List<Package>> futurepackages;
  List<Package> packages;

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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });
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
    // final packages = Provider.of<PackageProvider>(context);
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: FutureBuilder<List<Package>>(
          future: packageProvider.getAllPackages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Column(
                children: [
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "YOUR PACKAGES",
                        style: textStyle1(
                          13,
                          Colors.black,
                          FontWeight.w500,
                        ),
                      ),
                      InkWell(
                        onTap: addPackageHandler,
                        child: Container(
                          padding: EdgeInsets.all(8),
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
                    ],
                  ),
                ),
                SizedBox(height: 10),
                (packages == null || packages.length == 0)
                    ? Text(
                        "No packages, Create one now!",
                        style: textStyle1(
                          12,
                          Colors.black54,
                          FontWeight.w500,
                        ),
                      )
                    : PackageList(packages: packages),
              ],
            );
          }),
    );
  }
}

class PackageList extends StatefulWidget {
  const PackageList({Key key, this.packages}) : super(key: key);
  final dynamic packages;

  @override
  _PackageListState createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {
  List<bool> selected = [];
  bool loading = true;
  dynamic packages;
  int count = 0;

  void loadVars() async {
    setState(() {
      loading = true;
    });
    packages = widget.packages;
    for (int i = 0; i < packages.length; i++) {
      selected.add(false);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    loadVars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? MyCircularProgress(marginTop: 50)
        : Column(
            children: <Widget>[
              (count > 0)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              color: Color(0xFF811111),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Schedule Pickup",
                              style: textStyle1(
                                12,
                                Colors.white,
                                FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              count = 0;
                              for (int i = 0; i < selected.length; i++) {
                                selected[i] = false;
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 22,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(height: 0),
              if (count > 0) SizedBox(height: 10),
              Container(
                height: count == 0
                    ? MediaQuery.of(context).size.height * 0.58
                    : MediaQuery.of(context).size.height * 0.52,
                child: ListView.builder(
                  itemCount: packages.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int pack_i) {
                    Package package = packages[pack_i];
                    return Dismissible(
                      background: Container(
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: AlignmentDirectional.centerStart,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: InkWell(
                        onLongPress: () {
                          if (package.items.length == 0) {
                            return;
                          }
                          if (count > 0) {
                            return;
                          }
                          setState(() {
                            selected[pack_i] =
                                (selected[pack_i] == true) ? false : true;
                            if (selected[pack_i])
                              count++;
                            else
                              count--;
                          });
                        },
                        onTap: () {
                          if (package.items.length == 0) {
                            return;
                          }
                          if (count == 0) {
                            return;
                          }
                          setState(() {
                            selected[pack_i] =
                                (selected[pack_i] == true) ? false : true;
                            if (selected[pack_i])
                              count++;
                            else
                              count--;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color:
                                (selected.length > pack_i && selected[pack_i])
                                    ? Colors.grey[400]
                                    : Color(0xFFF6F6F6),
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
                                      package.name,
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
                                          style: textStyle1(10, Colors.black54,
                                              FontWeight.w500),
                                        ),
                                        Text(
                                          (package.items ?? [])
                                              .length
                                              .toString(),
                                          style: textStyle1(10, Colors.black54,
                                              FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () async {
                                    await Helpers().packageDetails(
                                        context, package, packageProvider);
                                  },
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
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
