import 'package:angular/di.dart';
import 'package:bokain_models/bokain_models.dart';

@Injectable()
class CartService {
  void add(String productId) {
    productRegistry[productId] ??= 0;
    productRegistry[productId]++; 
  }

  void remove(String productId) {
    if (productRegistry.containsKey(productId)) {
      productRegistry[productId]--;
    }
  }

  int get productCount {    
    var output = 0;
    for (final count in productRegistry.values) {
      output += count;
    }
    return output;
  }

  // Key: Product id Value: number of products
  final Map<String, int> productRegistry = {};

  bool shipping = true;
  CheckoutOrder klarnaOrder;
  final String currency = 'SEK';
}

