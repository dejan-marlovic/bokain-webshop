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
  CartItemComponent(this.cartService, this.msg);

  void ngOnDestroy() {
    countChangeController.close();
  }

  void remove() {
    cartService.productRegistry.remove(product.id);
  }

  String get lang => Intl.shortLocale(Intl.getCurrentLocale());

  final StreamController<int> countChangeController = new StreamController();
  final CartService cartService;
  final MessagesService msg;

  @Input()
  Product product;

  @Input()
  int count = 0;

  @Output('countChange')
  Stream<int> get countChange => countChangeController.stream;
}
