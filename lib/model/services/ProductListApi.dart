import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class ProductListApi {
  String endpoint = "server.com";
  Future<Either<Exception, String>> getProductList() async {
    try {
      final queryParameters = {
        "api_key": "YOUR_API_HERE",
      };
      final uri = Uri.https(endpoint, "/x/y/z", queryParameters);
      final response = await http.get(uri);
      return Right(response.body);
    } catch (e) {
      return (Left(e));
    }
  }
}
