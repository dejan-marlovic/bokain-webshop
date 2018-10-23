import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular/security.dart';
import 'package:bokain_models/bokain_models.dart';
import '../../../services/cart_service.dart';

@Component(
    selector: 'bo-confirmation',
    templateUrl: 'confirmation_component.html',
    styleUrls: const ['confirmation_component.css'],
    directives: const [MaterialSpinnerComponent, NgIf],
    providers: const <Object>[KlarnaCheckoutService],
    pipes: const [])
class ConfirmationComponent {
  ConfirmationComponent(this._cartService, this._languageService,
      this._klarnaCheckoutService, this._sanitizationService) {
    klarnaOrderId = Uri.base.queryParameters['sid'];
    if (klarnaOrderId != null) {
      _cartService
        ..klarnaOrder = null
        ..productRegistry = {}
        ..evaluateCheckout(_languageService.currentShortLocale);
      _finalizeOrder();
    }
  }

  Future<void> _finalizeOrder() async {
    await _klarnaCheckoutService.finalizeCheckoutOrder(klarnaOrderId);

    checkoutOrder =
        await _klarnaCheckoutService.getCheckoutOrder(klarnaOrderId);

    final dataUrl =
        Uri.encodeFull(checkoutOrder.html_snippet).replaceAll('#', '%23');

    klarnaHtml = _sanitizationService.bypassSecurityTrustResourceUrl(dataUrl);
  }

  String klarnaOrderId;
  CheckoutOrder checkoutOrder;

  final DomSanitizationService _sanitizationService;
  SafeResourceUrl klarnaHtml;
  final KlarnaCheckoutService _klarnaCheckoutService;
  final CartService _cartService;
  final LanguageService _languageService;
}
