import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/services/ProductListApi.dart';

class ProductListProvider extends ChangeNotifier {
  final _apicaller = ProductListApi();
  dynamic _streamController = StreamController<List<ProductList>>();
  int i = 0, len, _maxLen = 8;
  List<ProductList> _productApiResult = [];
  List<ProductList> products = [];
  static dynamic _sortBy = {"title": 1};
  static dynamic _filter = {
    "category": "Saree",
    "subCat": ["Maheshwari"],
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

  void setFilter(field, value) {
    _filter[field] = value;
  }

  Future<dynamic> getProductHelper() async {
    print("getProductHelper, $_filter");
    _productApiResult = await _apicaller.getProdListfromCat(_sortBy, _filter);
  }

  Future<void> getTwentyProduct() async {
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

  void loadMore() {
    print("Hey LoadMore");
    getTwentyProduct();
  }

  Future<void> search() async {
    _productApiResult = [];
    await getProductHelper();
    len = _productApiResult.length;
    print("length of ProdList: $len");
    loadMore();
  }

  // TODO: implement a cross button to erase productHelperResult data
}
