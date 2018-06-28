import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:intl/intl.dart';

@Component(
    selector: 'bo-product-category-filter',
    templateUrl: 'product_category_filter_component.html',
    styleUrls: const ['product_category_filter_component.css'],
    directives: const [NgFor],
    providers: const [])
class ProductCategoryFilterComponent implements OnActivate {
  ProductCategoryFilterComponent(
      this._productCategoryService, this._productService);

  @override
  void onActivate(RouterState previous, RouterState current) {
    if (current.parameters['id'] != null) {
      final lang = Intl.shortLocale(Intl.getCurrentLocale());
      final category = _productCategoryService.cachedModels.values.firstWhere(
          (category) =>
              category.phrases[lang].url_name == current.parameters['id'],
          orElse: () => null);

      if (category != null) {
        products = _productService.cachedModels.values
            .where((product) => product.product_category_id == product.id)
            .toList(growable: false);
      }
    }
  }

  List<Product> products = [];
  String selectedProductId;
  final ProductCategoryService _productCategoryService;
  final ProductService _productService;
}
