import 'package:provider/provider.dart';
import 'package:silkroute/model/services/CrateApi.dart';

class CrateProvider extends ChangeNotifierProvider {
  final _apicaller = CrateApi();
  static dynamic _crateItems, _crateProducts, _crateBill;

  // realtime updating of bill

  Future<void> getCrateItems() async {
    _crateItems = await _apicaller.getCrateItems();
  }

  get crateItems async {
    if (_crateItems == null) {
      await getCrateItems();
    }
    return _crateItems;
  }

  Future<void> getCrateProducts() async {
    var items = crateItems;
    var cratePr = items.item1;
    if (_crateProducts == null) {
      _crateProducts = [];
    }
    for (var x in cratePr) {
      var data = x.toMap();
      _crateProducts.add(data);
    }
  }

  get crateProducts async {
    if (_crateProducts == null) {
      await getCrateProducts();
    }
    return _crateProducts;
  }

  Future<void> getCrateBill() async {
    var items = crateItems;
    var bill = items.item2.toMap();
    _crateBill = bill;
  }

  get crateBill async {
    if (_crateBill == null) {
      await getCrateBill();
    }
    return _crateBill;
  }
}
