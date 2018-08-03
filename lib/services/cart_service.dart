import 'dart:async';
import 'package:angular/di.dart';
import 'package:angular/security.dart';
import 'package:bokain_models/bokain_models.dart';

@Injectable()
class CartService {
  CartService(
      this._klarnaCheckoutService,
      this._customerService,
      this._languageService,
      this._productService,
      this._settingsService,
      this._sanitizationService,
      this._msg);

  void add(String productId) {
    productRegistry[productId] ??= 0;
    productRegistry[productId]++;
    evaluateCheckout(_languageService.currentShortLocale);
  }

  void remove(String productId, {bool removeAll = false}) {
    if (productRegistry.containsKey(productId)) {
      productRegistry[productId]--;
    }
    if (removeAll || productRegistry[productId] < 1) {
      productRegistry.remove(productId);
    }
    evaluateCheckout(_languageService.currentShortLocale);
  }

  /// Evaluates which (if any) checkout to display, Klarna or Braintree
  Future<void> evaluateCheckout(String locale) async {
    klarnaHtml = null;

    if (productRegistry.isEmpty) {
      return;
    }

    if (locale == 'SV') {
      await _updateKlarnaCheckout();
    }
  }

  Future<void> _updateKlarnaCheckout() async {
    
    final settings = _settingsService.get('1');

    final webshopUrl = settings.webshop_url;
    final functionsUrl = settings.functions_url;

    KlarnaAddress billingAddress;
    Customer customer;
    try {
      customer = await _customerService.fetch(FirestoreService.currentUserId,
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
        ..country = 'SE'
        ..phone = '+46765260000'
        ..email = 'test@minoch.com';
    } else {
      billingAddress = new KlarnaAddress()
        ..given_name = customer.firstname
        ..family_name = customer.lastname
        ..email = customer.email
        ..phone = customer.phone
        ..street_address = customer.address.street
        ..postal_code = customer.address.zip
        ..city = customer.address.city
        ..country = customer.address.country;
    }

    var totalAmount =
        0.0; // total order amount, including tax and discounts (not shipping)
    var totalTaxAmount = 0.0; // total tax amount

    final orderLines = <OrderLine>[];
    for (final productId in productRegistry.keys) {
      final product = _productService.get(productId);

      final orderLine = new OrderLine()
        ..type = 'physical'
        ..reference = product.article_no
        ..merchant_data = product.id
        ..name = product.phrases[_languageService.currentShortLocale].name
        ..quantity = productRegistry[productId]
        ..quantity_unit = _msg.pcs()
        ..unit_price = (product.price[currency] * 100).round()
        ..tax_rate = 2000
        ..total_discount_amount = 0
        ..product_url =
            '$webshopUrl/products${product.phrases[_languageService.currentShortLocale].url_name}'
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

    final merchantUrls = new MerchantUrls()
      ..checkout = '$webshopUrl/${_msg.cart_url()}'
      ..confirmation = '$webshopUrl/confirmation'
      ..push = '$functionsUrl/finalizeKlarnaCheckoutOrder'
      ..terms = '$webshopUrl/${_msg.standard_terms_url()}';

    final checkboxOptions = new CheckboxOptions()
      ..checked = false
      ..required = true
      ..text = _msg.i_accept_the_terms();
    final checkoutOptions = new CheckoutOptions()
      ..additional_checkbox = checkboxOptions;

    ShippingOption shippingOption;
    if (shipping) {
      shippingOption = new ShippingOption()
        ..id = 'standard'
        ..name = _msg.standard()
        ..description = _msg.shipping_description()
        ..preselected = true
        ..price = settings.shipping[currency] * 100;

      shippingOption.tax_amount = shippingOption.price -
          shippingOption.price * 10000 ~/ (10000 + shippingOption.tax_rate);
    } else {
      shippingOption = new ShippingOption()
        ..id = 'free'
        ..name = _msg.free()
        ..description = _msg.shipping_description()
        ..preselected = true
        ..price = 0
        ..tax_amount = 0;
    }

    if (klarnaOrder == null) {
      klarnaOrder ??=
          await _klarnaCheckoutService.createCheckoutOrder(new CheckoutOrder()
            ..order_id = null
            ..purchase_currency = 'SEK'
            ..purchase_country = 'SE'
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
            ..shipping_countries = ['SE']
            ..options = checkoutOptions
            ..shipping_options = [shippingOption]
            ..gui = new Gui());

      klarnaOrder.merchant_urls
        ..checkout =
            '$webshopUrl/${_msg.cart_url()}?sid=${klarnaOrder.order_id}'
        ..confirmation = '$webshopUrl/confirmation?sid=${klarnaOrder.order_id}'
        ..push =
            '$functionsUrl/finalizeKlarnaCheckoutOrder?sid=${klarnaOrder.order_id}&push=1'
        ..terms = '$webshopUrl/${_msg.standard_terms_url()}';
      klarnaOrder =
          await _klarnaCheckoutService.updateCheckoutOrder(klarnaOrder);
    } else {
      klarnaOrder
        ..order_amount = totalAmount.round()
        ..order_tax_amount = totalTaxAmount.round()
        ..order_lines = orderLines
        ..shipping_options = [shippingOption];
      klarnaOrder =
          await _klarnaCheckoutService.updateCheckoutOrder(klarnaOrder);
    }

    final snippet =
        'data:text/html;charset=utf-8,${Uri.encodeFull(klarnaOrder.html_snippet)}';

    klarnaHtml = _sanitizationService.bypassSecurityTrustResourceUrl(snippet);
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
  SafeResourceUrl klarnaHtml;
  CheckoutOrder klarnaOrder;
  final DomSanitizationService _sanitizationService;
  final KlarnaCheckoutService _klarnaCheckoutService;
  final CustomerService _customerService;
  final SettingsService _settingsService;
  final LanguageService _languageService;
  final ProductService _productService;
  final WebshopMessagesService _msg;
  String currency = 'SEK';
}
