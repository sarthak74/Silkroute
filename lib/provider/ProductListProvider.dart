import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/glitch/Glitch.dart';
import 'package:silkroute/model/helper/ProductListHelper.dart';

class ProductListProvider extends ChangeNotifier {
  final _helper = ProductListHelper();
  final _streamController = StreamController<Either<Glitch, ProductList>>();
  int i = 0, len;
  dynamic _productHelperResult;

  Stream<Either<Glitch, ProductList>> get productListStream {
    return _streamController.stream;
  }

  Future<dynamic> getProductHelper() async {
    _productHelperResult = await _helper.getProductList();
  }

  Future<void> getTwentyProduct() async {
    if (_productHelperResult == null) {
      await getProductHelper();
      len = _productHelperResult.length;
    }

    if (i >= len) {
      return;
    }
    dynamic toadd = _productHelperResult.sublist(i, i + Math().min(len, 20));
    i += Math().min(len, 20);
    _streamController.add(toadd);
  }

  void loadMore() {
    getTwentyProduct();
  }

  // TODO: implement a cross button to erase productHelperResult data
}
