import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/MerchantOrderItem.dart';

import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/services/MerchantApi.dart';
import 'package:silkroute/model/services/ProductListApi.dart';

class MerchantReturnOrderProvider extends ChangeNotifier {
  final _apicaller = MerchantApi();
  dynamic _streamController = StreamController<List<MerchantOrderItem>>();
  int i = 0, len, _maxLen = 5;
  List<MerchantOrderItem> _merchantApiResult = [];
  List<MerchantOrderItem> orders = [];
  // var dateTime = DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now());
  static dynamic _sortBy = {"createdDate": 1};
  static dynamic _filter;

  dynamic getfilter() {
    if (_filter == null) {
      _filter = {
        "createdDate": {
          "\u0024lte": DateFormat('yyyy-MM-dd hh:mm')
              .format(DateTime.now().add(Duration(days: 1))),
          "\u0024gte": DateFormat('yyyy-MM-dd hh:mm')
              .format(DateTime.now().subtract(Duration(days: 500)))
        }
      };
    }
    return _filter;
  }

  get filter {
    return getfilter();
  }

  void productApiResult(value) {
    _merchantApiResult = value;
  }

  Stream<List<MerchantOrderItem>> get productListStream {
    return _streamController.stream;
  }

  void setProductListStream(value) {
    _streamController = StreamController<List<MerchantOrderItem>>();
  }

  void setSortBy(title, value) {
    _sortBy = {};
    _sortBy[title] = value;
  }

  void setFilter(field, value) {
    _filter[field] = value;
  }

  Future<dynamic> getOrderHelper() async {
    _merchantApiResult = await _apicaller.getMerchantOrders(_sortBy, filter, 1);
  }

  Future<void> getTwentyOrders() async {
    len = _merchantApiResult.length;
    // print("$_maxLen order $_merchantApiResult $len");
    dynamic toadd = (_merchantApiResult != null)
        ? _merchantApiResult.sublist(0, Math().min(len, _maxLen))
        : [];
    print("$toadd");
    if (len > _maxLen) {
      _merchantApiResult =
          _merchantApiResult.sublist(Math().min(len, _maxLen), len);
    } else {
      _merchantApiResult = [];
    }
    print("$_merchantApiResult");

    _streamController.sink.add(toadd);
  }

  void loadMore() async {
    print("Hey LoadMore orders");
    getTwentyOrders();
  }

  Future<void> search() async {
    _merchantApiResult = [];

    await getOrderHelper();
    len = _merchantApiResult.length;
    loadMore();
  }
}
