import 'dart:html' as dom;
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import '../not_found_component/not_found_component.dart';
import 'product_bundle_component/product_bundle_component.dart';
import 'sub_product_component/sub_product_component.dart';

@Component(
    selector: 'bo-product',
    templateUrl: 'product_component.html',
    styleUrls: const ['product_component.css'],
    directives: const [NgIf, NotFoundComponent, ProductBundleComponent, SubProductComponent])
class ProductComponent implements OnActivate {
  ProductComponent(this.languageService, this.productService);

  @override
  void onActivate(RouterState previous, RouterState current) {
    dom.window.scrollTo(0, 0);
    
    /// Figure out model
    if (current.parameters['url_name'] != null) {
      model = productService.cachedModels.values.firstWhere(
          (p) => _match(p, current.parameters['url_name']),
          orElse: () => null);
    }

    if (model == null) {
      showNotFound = true;
    }
  }

  bool _match(Product product, String url_name) {
    for (final lang in languageService.data.keys) {
      if (product?.phrases[lang.toUpperCase()]?.url_name == url_name)
        return true;
    }
    return false;
  }

  Product model;
  bool showNotFound = false;
  final LanguageService languageService;
  final ProductService productService;
}
