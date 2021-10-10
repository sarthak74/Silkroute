import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/model/core/Bill.dart';
import 'package:silkroute/model/core/CrateListItem.dart';

class CrateApi {
  LocalStorage storage = LocalStorage('silkroute');
  String endpoint = "http://192.168.43.220:4000";

  Future<Tuple<List<CrateListItem>, Bill>> getCrateItems() async {
    try {
      var data = {
        // userid
      };
      var url = Uri.parse(endpoint + '/CrateApi/getAllProducts');
      final res = await http.post(url, body: data);
      var decodedRes2 = jsonDecode(res.body);
      List<CrateListItem> resp = [];
      for (var i in decodedRes2[0]) {
        CrateListItem r = CrateListItem.fromMap(i);
        resp.add(r);
      }
      Bill bill = Bill.fromMap(decodedRes2[1]);

      return Tuple<List<CrateListItem>, Bill>(resp, bill);
    } catch (e) {
      print("error - $e");
      return e;
    }
  }

  setCrateItems() async {
    try {
      var data = {
        // list of cratelistitems (only id, quantity, & color)
        // rest calculate in backend and fill db
      };
      var url = Uri.parse(endpoint + '/CrateApi/setItems');
      final res = await http.post(url, body: data);
      print(res.statusCode);
    } catch (e) {
      print("error - $e");
    }
  }
}

class Tuple<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple(
    this.item1,
    this.item2,
  );
}
