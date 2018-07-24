import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular/security.dart';
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
      NgIf,
      NgFor,
      SafeInnerHtmlDirective
    ],
    providers: const [KlarnaCheckoutService],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class CartComponent implements OnActivate, OnDeactivate {
  CartComponent(
      this._sanitizationService,
      this.customerService,
      this.cartService,
      this._checkoutService,
      this.languageService,
      this.productService,
      this.settingsService,
      this.changeDetectorRef,
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

    changeDetectorRef?.detectChanges();
  }

  Future<void> updateKlarnaCheckout() async {
    klarnaHtml = null;
    final url = 'https://bokain-webshop-e5b4f.firebaseapp.com';

    KlarnaAddress billingAddress;
    Customer customer;
    try {
      customer = await customerService.fetch(FirestoreService.currentUserId,
          force: false, cache: true);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print(e);
    }

    if (customer == null ||
        FirestoreService.currentFirebaseUser.uid ==
            FirestoreService.defaultCustomerAuthId) {
      // TODO: remove test credentials when live
      billingAddress = new KlarnaAddress()
        ..given_name = 'Testperson-se'
        ..family_name = 'Approved'
        ..street_address = 'Stårgatan 1'
        ..postal_code = '12345'
        ..city = 'Ankeborg'
        ..phone = '+46765260000'
        ..email = 'test@minoch.com';
    } else {
      billingAddress = new KlarnaAddress()
        ..given_name = customer.firstname
        ..family_name = customer.lastname
        ..email = customer.email
        ..phone = customer.phone
        ..street_address = customer.street
        ..postal_code = customer.postal_code
        ..city = customer.city
        ..country = customer.country;
    }

    var totalAmount =
        0.0; // total order amount, including tax and discounts (not shipping)
    var totalTaxAmount = 0.0; // total tax amount

    final orderLines = <OrderLine>[];
    for (final productId in cartService.productRegistry.keys) {
      final product = productService.get(productId);

      final orderLine = new OrderLine()
        ..type = 'physical'
        ..reference = product.article_no
        ..merchant_data = product.id
        ..name = product.phrases[languageService.currentShortLocale].name
        ..quantity = cartService.productRegistry[productId]
        ..quantity_unit = msg.pcs()
        ..unit_price = (product.price['sek'] * 100).round()
        ..tax_rate = 2000
        ..total_discount_amount = 0
        ..product_url =
            '$url/products${product.phrases[languageService.currentShortLocale].url_name}'
        ..image_url = product.image_uri;

      orderLine
        ..total_amount = (orderLine.quantity * (orderLine.unit_price)) -
            orderLine.total_discount_amount
        ..total_tax_amount = orderLine.total_amount -
            orderLine.total_amount * 10000 ~/ (10000 + orderLine.tax_rate);

      totalAmount += orderLine.total_amount;
      totalTaxAmount += orderLine.total_tax_amount;
      orderLines.add(orderLine);
    }

    // TODO: set proper urls

    final merchantUrls = new MerchantUrls()
      ..checkout = '$url/${msg.cart_url()}'
      ..confirmation = '$url/confirmation'
      ..push = '$url/push'
      ..terms = '$url/${msg.standard_terms_url()}';

    final checkboxOptions = new CheckboxOptions()
      ..checked = false
      ..required = true
      ..text = msg.i_accept_the_terms();
    final checkoutOptions = new CheckoutOptions()
      ..additional_checkbox = checkboxOptions;

    ShippingOption shipping;
    if (cartService.shipping) {
      shipping = new ShippingOption.standard()
        ..price = settingsService.get('1').shipping[cartService.currency] * 100;

      shipping.tax_amount = shipping.price -
          shipping.price *
              10000 ~/
              (10000 + shipping.tax_rate); // for 25% tax rate
    } else {
      shipping = new ShippingOption.free();
    }

    order = new CheckoutOrder()
      ..order_id = order?.order_id
      ..purchase_currency = 'sek'
      ..purchase_country = 'SV'
      ..locale = 'sv-SE'
      ..billing_address = billingAddress
      ..order_amount = totalAmount.round()
      ..order_tax_amount = totalTaxAmount.round()
      ..order_lines = orderLines
      ..customer = new KlarnaCustomer()
      ..merchant_urls = merchantUrls
      ..merchant_reference1 = ''
      ..merchant_reference2 = ''
      ..merchant_data = ''
      ..shipping_countries = ['sv']
      ..options = checkoutOptions
      ..shipping_options = [shipping]
      ..gui = new Gui();

    if (order.order_id == null) {
      order = await _checkoutService.createCheckoutOrder(order);
    }
    order.merchant_urls
      ..checkout = '$url/${msg.cart_url()}?sid=${order.order_id}'
      ..confirmation = '$url/confirmation?sid=${order.order_id}'
      ..push = '$url/push?checkout_uri=${order.order_id}'
      ..terms = '$url/${msg.standard_terms_url()}';
    order = await _checkoutService.updateCheckoutOrder(order);

    final snippet =
        'data:text/html;charset=utf-8,${Uri.encodeFull(order.html_snippet)}';

    klarnaHtml = _sanitizationService.bypassSecurityTrustResourceUrl(snippet);
    changeDetectorRef.markForCheck();
  }

  SafeResourceUrl klarnaHtml;
  CheckoutOrder order;
  String discountCode;
  StreamSubscription<String> localeChangeSubscription;
  final DomSanitizationService _sanitizationService;
  final CartService cartService;
  final CustomerService customerService;
  final KlarnaCheckoutService _checkoutService;
  final LanguageService languageService;
  final ProductService productService;
  final SettingsService settingsService;
  final ChangeDetectorRef changeDetectorRef;
  final MessagesService msg;
}
