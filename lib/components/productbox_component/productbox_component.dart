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
    directives: const [
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialSpinnerComponent,
      NgIf
    ],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ProductBoxComponent {
  ProductBoxComponent(this._productCategoryService, this._skinTypeService,
      this.cartService, this.router, this._msg);

  void addToCart() {
    cartService.add(model.id.toString());
  }

  String get _productCategoryUrl {
    final category = _productCategoryService.get(model.product_category_id);

    if (category == null) {
      /// We're dealing with a product category, add it's skin type to the url
      try {
        print(model.skin_type_ids.first);
        final skinType = _skinTypeService.webshopData[model.skin_type_ids.first];
        return '${_msg.bundle(2)}/${skinType.url_name}';
      } on StateError catch (e) {
        print(e);
        return '';
      }
    } else {
      // Defualt product
      return category.phrases[lang].url_name;
    }
  }

  void openProduct() {
    router.navigate(
        '${_msg.product(2)}/$_productCategoryUrl/${model.phrases[lang].url_name}');
  }

  String get lang => Intl.shortLocale(Intl.getCurrentLocale()).toUpperCase();

  @Input()
  Product model;

  final ProductCategoryService _productCategoryService;
  final SkinTypeService _skinTypeService;
  final CartService cartService;
  final CoreMessagesService _msg;
  final Router router;
  bool imageLoaded = false;
}
