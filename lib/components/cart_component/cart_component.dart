import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../services/cart_service.dart';
import 'cart_item_component.dart';


@Component(
    selector: 'bo-cart',
    templateUrl: 'cart_component.html',
    styleUrls: const ['cart_component.css'],
    directives: const [
      CartItemComponent,
      formDirectives,
      MaterialButtonComponent,
      MaterialIconComponent,
      materialInputDirectives,
      NgFor
    ],
    providers: const [KlarnaCheckoutService],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class CartComponent implements OnActivate, OnDeactivate {
  CartComponent(
      this.cartService,
      this._checkoutService,
      this.languageService,
      this.productService,
      this.settingsService,
      this._changeDetectorRef,
      this.msg);

  @override
  void onActivate(RouterState previous, RouterState current) {
    _evaluateCheckout(languageService.currentShortLocale);
    localeChangeSubscription =
        languageService.localeChanges.listen(_evaluateCheckout);
  }

  @override
  void onDeactivate(RouterState previous, RouterState current) {
    localeChangeSubscription.cancel();
  }

  /// Evaluates which (if any) checkout to display, Klarna or Braintree
  Future<void> _evaluateCheckout(String locale) async {
    if (locale == 'sv') {
      await updateKlarnaCheckout();
    }

    _changeDetectorRef?.detectChanges();
  }

  Future<void> updateKlarnaCheckout() async {
    final orderAmount = subtotal;
    final order = new CheckoutOrder()
      ..purchase_currency = 'sek'
      ..purchase_country = 'SV'
      ..locale = 'sv-SE'
      ..order_amount = (orderAmount * 100).round()
      ..order_tax_amount = (orderAmount * 20).round()      
      ..shipping_options = [
        
      ];
    await _checkoutService.createCheckoutOrder(order);
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

  StreamSubscription<String> localeChangeSubscription;
  final CartService cartService;
  final KlarnaCheckoutService _checkoutService;
  final LanguageService languageService;
  final ProductService productService;
  final SettingsService settingsService;
  final ChangeDetectorRef _changeDetectorRef;
  final MessagesService msg;
}
