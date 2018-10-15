import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../../services/cart_service.dart';

@Component(
  selector: 'bo-cart-item',
  templateUrl: 'cart_item_component.html',
  styleUrls: ['cart_item_component.css'],
  directives: const [
    FoNumberInputComponent,
    formDirectives,
    MaterialButtonComponent,
    MaterialIconComponent
  ],
  pipes: const [NamePipe],
)
class CartItemComponent {
  CartItemComponent(
      this.cartService, this.languageService, this.settingsService, this.msg);

  void remove() {
    cartService.remove(product.id.toString(), removeAll: true);
  }

  void onCountChange(int value) {
    if (value > cartService.productRegistry[product.id]) {
      final count = value - cartService.productRegistry[product.id];
      for (var i = 0; i < count; i++) {
        cartService.add(product.id.toString(), showPreview: false);
      }
    } else {
      final count = cartService.productRegistry[product.id] - value;
      for (var i = 0; i < count; i++) {
        cartService.remove(product.id.toString());
      }
    }
  }

  final LanguageService languageService;
  final CartService cartService;
  final SettingsService settingsService;
  final WebshopMessagesService msg;

  @Input()
  Product product;
}
