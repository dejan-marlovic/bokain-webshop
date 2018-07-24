import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular/security.dart';
import 'package:bokain_models/bokain_models.dart';

@Component(
    selector: 'bo-confirmation',
    templateUrl: 'confirmation_component.html',
    styleUrls: const ['confirmation_component.css'],
    directives: const [NgIf],
    providers: const [KlarnaCheckoutService],
    pipes: const [])
class ConfirmationComponent {
  ConfirmationComponent(this._klarnaCheckoutService, this._customerService,
      this._orderservice, this._sanitizationService) {
    orderId = Uri.base.queryParameters['sid'];
    if (orderId != null) {
      _registerOrderAndCustomer();
    }
  }

  Future<void> _registerOrderAndCustomer() async {
    checkoutOrder = await _klarnaCheckoutService.getCheckoutOrder(orderId);

    final address = new Address()
      ..name =
          '${checkoutOrder.billing_address.given_name} ${checkoutOrder.billing_address.family_name}'
      ..street = checkoutOrder.billing_address.street_address
      ..zip = checkoutOrder.billing_address.postal_code
      ..city = checkoutOrder.billing_address.city
      ..country = checkoutOrder.billing_address.country;

    final productIds = <String>[];
    for (final orderLine in checkoutOrder.order_lines) {
      if (orderLine.type == 'physical') {
        productIds.addAll(new List.generate(
            orderLine.quantity, (i) => orderLine.merchant_data));
      }
    }

    final order = new Order()
      ..id = checkoutOrder.order_id
      ..address = address
      ..product_ids = productIds
      ..currency = 'SEK'
      ..subtotal = checkoutOrder.order_amount.toDouble()
      ..state = checkoutOrder.status; // should be 'CHECKOUT_INCOMPLETE'

    final customer = new Customer()
      ..email = checkoutOrder.billing_address.email
      ..phone = checkoutOrder.billing_address.phone
      ..phone_country = '+46'
      ..firstname = checkoutOrder.billing_address.given_name
      ..lastname = checkoutOrder.billing_address.family_name
      ..street = checkoutOrder.billing_address.street_address
      ..postal_code = checkoutOrder.billing_address.postal_code
      ..city = checkoutOrder.billing_address.city
      ..country = checkoutOrder.billing_address.country
      ..language = 'sv';

    if (checkoutOrder.customer.date_of_birth != null) {
      customer.social_number =
          "${checkoutOrder.customer.date_of_birth.replaceAll('-', '')}0000";
    }

    try {
      order.customer_id = await _customerService.register(customer);
    } on EmailAlreadyRegisteredException catch (e) {
      order.customer_id = checkoutOrder.billing_address.email;
    }

    await _orderservice.set(order);

    final snippet =
        'data:text/html;charset=utf-8,${Uri.encodeFull(checkoutOrder.html_snippet)}';
    klarnaHtml = _sanitizationService.bypassSecurityTrustResourceUrl(snippet);
  }

  String orderId;
  CheckoutOrder checkoutOrder;

  final DomSanitizationService _sanitizationService;
  SafeResourceUrl klarnaHtml;
  final CustomerService _customerService;
  final KlarnaCheckoutService _klarnaCheckoutService;
  final OrderService _orderservice;
}
