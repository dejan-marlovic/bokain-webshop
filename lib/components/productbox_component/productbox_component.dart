import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:intl/intl.dart';
import '../../services/cart_service.dart';

@Component(
    selector: 'bo-productbox',
    styleUrls: const ['productbox_component.css'],
    templateUrl: 'productbox_component.html',
    directives: const [MaterialButtonComponent, MaterialIconComponent])
class ProductBoxComponent {
  ProductBoxComponent(this.cartService, this.router);

  void addToCart() {
    cartService.add(model.id);    
  }

  void openProduct() {
    router.navigate('products/${model.phrases[lang].url_name}');
  }

  String get lang => Intl.shortLocale(Intl.getCurrentLocale()).toUpperCase();

  @Input('model')
  Product model;

  final CartService cartService;
  final Router router;
}
