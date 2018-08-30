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
class ProductBoxComponent implements OnInit {
  ProductBoxComponent(this.cartService, this.router, this._msg);

  @override
  void ngOnInit() {
    rootUrl ??= _msg.product(2);
  }

  void addToCart() {
    cartService.add(model.id);
  }

  void openProduct() {
    router.navigate('$rootUrl/${model.phrases[lang].url_name}');    
  }

  String get lang => Intl.shortLocale(Intl.getCurrentLocale()).toUpperCase();

  @Input()
  Product model;

  @Input()
  String rootUrl;

  final CartService cartService;
  final CoreMessagesService _msg;
  final Router router;
}
