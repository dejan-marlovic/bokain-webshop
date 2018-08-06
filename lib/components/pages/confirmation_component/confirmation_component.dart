import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular/security.dart';
import 'package:bokain_models/bokain_models.dart';
import '../../../services/cart_service.dart';

@Component(
    selector: 'bo-confirmation',
    templateUrl: 'confirmation_component.html',
    styleUrls: const ['confirmation_component.css'],
    directives: const [NgIf],
    providers: const [KlarnaCheckoutService],
    pipes: const [])
class ConfirmationComponent {
  ConfirmationComponent(this._cartService, this._klarnaCheckoutService,
      this._sanitizationService) {
    klarnaOrderId = Uri.base.queryParameters['sid'];
    if (klarnaOrderId != null) {
      _registerOrderAndCustomer();
    }
  }

  Future<void> _registerOrderAndCustomer() async {
    _cartService.klarnaOrder = null;
    
    checkoutOrder =
        await _klarnaCheckoutService.getCheckoutOrder(klarnaOrderId);

    final data =
        await _klarnaCheckoutService.finalizeCheckoutOrder(klarnaOrderId);
    print(data);

    final snippet =
        'data:text/html;charset=utf-8,${Uri.encodeFull(checkoutOrder.html_snippet)}';
    klarnaHtml = _sanitizationService.bypassSecurityTrustResourceUrl(snippet);    
  }

  String klarnaOrderId;
  CheckoutOrder checkoutOrder;

  final DomSanitizationService _sanitizationService;
  SafeResourceUrl klarnaHtml;
  final KlarnaCheckoutService _klarnaCheckoutService;
  final CartService _cartService;
}
