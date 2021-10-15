import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/services/ProductListApi.dart';

class SearchProvider extends ChangeNotifier {
  final _apicaller = ProductListApi();
  dynamic _streamController = StreamController<List<ProductList>>();
  int i = 0, len, _maxLen = 2;
  List<ProductList> _productApiResult = [];
  List<ProductList> products = [];
  static dynamic _sortBy = {"title": 1};
  static dynamic _filter = {
    "category": "Saree",
    "sp": {
      "\u0024gte": 1000,
      "\u0024lte": 50000,
    }
  };

  get filter {
    return _filter;
  }

  void productApiResult(value) {
    _productApiResult = value;
  }

  Stream<List<ProductList>> get productListStream {
    return _streamController.stream;
  }

  void setProductListStream(value) {
    _streamController = StreamController<List<ProductList>>();
  }

  void setSortBy(title, value) {
    _sortBy = {};
    _sortBy[title] = value;
  }

  void setFilter(filter) {
    _filter = filter;
  }

  Future<dynamic> getProductHelper(qry) async {
    _productApiResult =
        await _apicaller.getProdListfromSearch(qry, _sortBy, filter);
  }

  Future<void> getTwentyProduct(qry) async {
    len = _productApiResult.length;
    print("$_maxLen prod. $_productApiResult $len");
    dynamic toadd = (_productApiResult != null)
        ? _productApiResult.sublist(0, Math().min(len, _maxLen))
        : [];
    print("$toadd");
    if (len > _maxLen) {
      _productApiResult =
          _productApiResult.sublist(Math().min(len, _maxLen), len);
    } else {
      _productApiResult = [];
    }
    print("$_productApiResult");

    _streamController.sink.add(toadd);
  }

  void loadMore(qry) {
    print("Hey LoadMore $qry");
    getTwentyProduct(qry);
  }

  Future<void> search(qry) async {
    _productApiResult = [];
    await getProductHelper(qry);
    len = _productApiResult.length;
    print("length of ProdList: $len");
    loadMore(qry);
  }

  // TODO: implement a cross button to erase productHelperResult data
}
