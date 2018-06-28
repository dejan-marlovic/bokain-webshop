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

  SkinTypeFilterComponent(this._productService);

  /*
products = _productService.cachedModels.values.where((product) =>
            product.skin_type_ids
                .contains(skinType)).toList(growable: false);
*/
  

  @override
  void onActivate(RouterState previous, RouterState current) {
    print(current.path);

  }

  List<Product> products = [];
  String selectedProductId;
  final ProductService _productService;
}
