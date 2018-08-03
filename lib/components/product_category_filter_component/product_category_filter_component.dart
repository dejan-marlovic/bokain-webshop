import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:intl/intl.dart';
import '../icon_component/icon_component.dart';
import '../productbox_component/productbox_component.dart';

@Component(
    selector: 'bo-product-category-filter',
    templateUrl: 'product_category_filter_component.html',
    styleUrls: const ['product_category_filter_component.css'],
    directives: const [IconComponent, NgFor, ProductBoxComponent, routerDirectives],
    providers: const [],
    pipes: const [NamePipe])
class ProductCategoryFilterComponent implements OnActivate {
  ProductCategoryFilterComponent(
      this._productCategoryService, this._productService, this.msg);

  @override
  void onActivate(RouterState previous, RouterState current) {
    if (current.parameters['id'] != null) {      
      final lang = Intl.shortLocale(Intl.getCurrentLocale()).toUpperCase();      
      final category = _productCategoryService.cachedModels.values.firstWhere(
          (category) =>
              category.phrases[lang].url_name == current.parameters['id'],
          orElse: () => null);

      if (category != null) {
        products = _productService.cachedModels.values
            .where((product) => product.product_category_id == category.id)
            .toList(growable: false);
      }
    }
  }

  String iconSize = '2.5rem';
  List<Product> products = [];
  String selectedProductId;
  final ProductCategoryService _productCategoryService;
  final ProductService _productService;
  final WebshopMessagesService msg;
}
