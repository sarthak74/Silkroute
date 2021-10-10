import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/services/ProductListApi.dart';

class ProductListProvider extends ChangeNotifier {
  final _apicaller = ProductListApi();
  final _streamController = StreamController<List<ProductList>>();
  int i = 0, len;
  dynamic _productApiResult;
  List<ProductList> products = [];

  Stream<List<ProductList>> get productListStream {
    return _streamController.stream;
  }

  Future<dynamic> getProductHelper() async {
    _productApiResult = await _apicaller.getProductList();
  }

  Future<void> getTwentyProduct() async {
    print("20 prod.");
    if (_productApiResult == null) {
      await getProductHelper();
      len = _productApiResult.length;
      print("length of ProdList: $len");
    }

    if (i >= len) {
      return;
    }
    dynamic toadd = _productApiResult.sublist(i, Math().min(len, i + 20));

    i = Math().min(len, i + 20);
    _streamController.sink.add(toadd);
  }

  void loadMore() {
    print("Hey LoadMore");
    getTwentyProduct();
  }

  // TODO: implement a cross button to erase productHelperResult data
}
