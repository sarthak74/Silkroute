import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/model/core/package.dart';
import 'package:silkroute/model/services/packagesApi.dart';

class PackageProvider extends ChangeNotifier {
  List<Package> _packages = [];
  Future<List<Package>> futurePacks;

  Future<List<Package>> fetchAllPackages() async {
    futurePacks = PackagesApi().getAllPackages();
    _packages = await futurePacks;
    return futurePacks;
  }

  Future<List<Package>> getAllPackages() async {
    if (_packages == [] || _packages.length == 0 || _packages == null) {
      return fetchAllPackages();
    }

    return futurePacks;
  }

  List<Package> getStoredPackages() {
    return _packages;
  }

  void removeAnItem(data) async {
    /*
      data = {productId, orderId, packageId}
    */
    dynamic item = {"orderId": data['orderId'], "productId": data['productId']};
    var temp = _packages, flag = false;
    for (int i = 0; i < _packages.length; i++) {
      if (_packages[i].id == data['packageId']) {
        var ind = 0;
        ind = _packages[i].items.toList().indexOf(item);

        for (int j = 0; j < _packages[i].items.length; j++) {
          if (jsonEncode(_packages[i].items[j]) == jsonEncode(item)) {
            ind = j;
            break;
          }
        }
        await _packages[i].items.removeAt(ind);
        flag = (_packages[i].items.length == 0);
        // print("_packages[i]: ${_packages[i]}");
        break;
      }
    }

    var res = await PackagesApi().removeItem(data);
    if (res == null || res == false) {
      _packages = temp;
      return;
    }
    notifyListeners();
  }

  void addPackage(Package newPack) {
    _packages.add(newPack);
    notifyListeners();
  }

  void createPackage() async {
    var res = await PackagesApi().create();
    if (res['success'] == false) {
      return;
    }
    var pack = res['data'];
    Package newPack = new Package(
      id: pack['id'],
      name: pack['name'],
      state: pack['state'],
      contact: pack['contact'],
      items: [],
    );
    addPackage(newPack);
  }

  void addItemsToPack(packId, items) async {
    var res = await PackagesApi().addItem(packId, items);
    if (res == null || res == false) {
      return;
    }
    for (int i = 0; i < _packages.length; i++) {
      if (_packages[i].id == packId) {
        items.forEach((item) => _packages[i].items.add(item));
        notifyListeners();
        break;
      }
    }
  }

  void clear(id) async {
    print("clearing $id");
    var res = await PackagesApi().clear(id);
    if (res['success'] == false) {
      print("failed clearing $id");
      return;
    }
    for (int i = 0; i < _packages.length; i++) {
      if (_packages[i].id == id) {
        _packages[i].items.clear();
      }
    }
    print("success clearing $id");
    notifyListeners();
  }

  void delete(Package package) async {
    print("deleting ${package.id}");
    var res = await PackagesApi().delete(package.id);
    if (res['success'] == false) {
      print("failed deleting ${package.id}");
      return;
    }
    print("packages: $_packages");
    await _packages.remove(package);
    print("packages: $_packages");
    print("success clearing ${package.id}");
    // notifyListeners();
  }
}
