import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import '../productbox_component/productbox_component.dart';

@Component(
    selector: 'bo-skin-type-filter',
    templateUrl: 'skin_type_filter_component.html',
    styleUrls: const ['skin_type_filter_component.css'],
    directives: const [NgFor, ProductBoxComponent])
class SkinTypeFilterComponent implements OnActivate {
  SkinTypeFilterComponent(this._productService, this._skinTypeService);

  @override
  void onActivate(RouterState previous, RouterState current) {
    if (current.parameters['id'] != null) {
      final skinTypeId = _skinTypeService.data.keys.firstWhere(
          (id) =>
              _skinTypeService.data[id].url_name == current.parameters['id'],
          orElse: () => null);

      if (skinTypeId != null) {
        products = _productService.cachedModels.values
            .where((product) => product.skin_type_ids.contains(skinTypeId))
            .toList(growable: false);
      }
    }
  }

  List<Product> products = [];
  String selectedProductId;
  final ProductService _productService;
  final SkinTypeService _skinTypeService;
}
