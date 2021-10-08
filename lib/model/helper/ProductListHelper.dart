import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:silkroute/model/core/ProductList.dart';
import 'package:silkroute/model/glitch/Glitch.dart';
import 'package:silkroute/model/glitch/NoInternetGlitch.dart';
import 'package:silkroute/model/services/ProductListApi.dart';

class ProductListHelper {
  final api = ProductListApi();
  Future<Either<Glitch, ProductList>> getProductList() async {
    final apiResult = await api.getProductList();
    return apiResult.fold((l) {
      // implement more errors
      return Left(NoInternetGlitch());
    }, (r) {
      final p = ProductList.fromMap(jsonDecode(r));
      return Right(p);
    });
  }
}
