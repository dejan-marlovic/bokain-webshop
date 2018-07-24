import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:intl/intl.dart';
import '../../services/cart_service.dart';

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
class CartItemComponent implements OnDestroy {
  CartItemComponent(this.cartService, this.languageService, this.settingsService, this.msg);

  void ngOnDestroy() {
    _changeController.close();    
  }

  void remove() {
    cartService.productRegistry.remove(product.id);
    _changeController.add(product.id);
  }

  void onCountChange(int value) {
    cartService.productRegistry[product.id] = value;    
    _changeController.add(product.id);    
  }

  final StreamController<String> _changeController = new StreamController();
  
  final LanguageService languageService;
  final CartService cartService;
  final SettingsService settingsService;
  final MessagesService msg;  

  @Input()
  Product product;

  @Output('change')
  Stream<String> get countChange => _changeController.stream;  
}
