import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../services/cart_service.dart';
import 'cart_item_component.dart';

@Component(
    selector: 'bo-cart',
    templateUrl: 'cart_component.html',
    styleUrls: const [
      'cart_component.css'
    ],
    directives: const [
      CartItemComponent,
      formDirectives,
      MaterialButtonComponent,
      MaterialIconComponent,      
      materialInputDirectives,
      NgFor
    ],
    providers: const [
      KlarnaCheckoutService
    ],
    pipes: const [
      NamePipe
    ])
class CartComponent {
  CartComponent(
      this.cartService, this._checkoutService, this.productService, this.settingsService, this.msg) {
    // _checkoutService.createCheckoutOrder(new CheckoutOrder());
  }

  double get subtotal {
    var output = 0.0;
    for (final productId in cartService.productRegistry.keys) {
      final count = cartService.productRegistry[productId];
      final product = productService.get(productId);
      output += product.price[cartService.currency] * count;
    }
    output += settingsService.get('1').shipping[cartService.currency];

    return output;
  }

  String discountCode;

  final CartService cartService;
  final KlarnaCheckoutService _checkoutService;
  final ProductService productService;
  final SettingsService settingsService;
  final MessagesService msg;
}
