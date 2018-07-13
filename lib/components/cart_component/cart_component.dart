import 'package:angular/angular.dart';
//import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../services/cart_service.dart';
import 'cart_item_component.dart';

@Component(
    selector: 'bo-cart',
    templateUrl: 'cart_component.html',
    styleUrls: const ['cart_component.css'],
    directives: const [CartItemComponent, NgFor],
    pipes: const [NamePipe])
class CartComponent {
  CartComponent(this.cartService, this.productService, this.msg);

  int get subtotal {
    var output = 0.0;
    for (final productId in cartService.productRegistry.keys) {
      final count = cartService.productRegistry[productId];
      final product = productService.get(productId);

      switch (cartService.currency) {
        case Currency.eur:
          output += product.price_eur;
          break;

        case Currency.sek:
          output += product.price_sek;
          break;

        case Currency.usd:
          output += product.price_usd;
          break;
      }
    }

    return 0;
  }

  final CartService cartService;
  final ProductService productService;
  final MessagesService msg;
}
