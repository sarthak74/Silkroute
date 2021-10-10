import 'package:provider/provider.dart';
import 'package:silkroute/model/services/WishlistApi.dart';

class WishlistProvider extends ChangeNotifierProvider {
  final _apicaller = WishlistApi();
}
