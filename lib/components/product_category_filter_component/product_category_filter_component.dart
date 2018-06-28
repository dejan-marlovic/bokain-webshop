import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';

@Component(
  selector: 'bo-product-category-filter',
  templateUrl: 'product_category_filter_component.html',
  styleUrls: const ['product_category_filter_component.css'],
  directives: const [NgFor],
  providers: const []
)
class ProductCategoryFilterComponent implements OnActivate {
  ProductCategoryFilterComponent(this._productCategoryService, this._productService);
  
  @override
  void onActivate(RouterState previous, RouterState current) {
    if (current.parameters['id'] != null) {
      //_productCategoryService.cachedModels.values.first.name

      /*
      final skinTypeId = _skinTypeService.data.keys.firstWhere(
          (id) =>
              _skinTypeService.data[id].url_name == current.parameters['id'],
          orElse: () => null);
1
      if (skinTypeId != null) {
        products = _productService.cachedModels.values
            .where((product) => product.skin_type_ids.contains(skinTypeId))
            .toList(growable: false);
      }*/

    }
  }

  List<Product> products = [];
  String selectedProductId;
  final ProductCategoryService _productCategoryService;
  final ProductService _productService;
}