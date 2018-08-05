import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../product_bundlebox_component/product_bundlebox_component.dart';
import '../product_list_component/product_list_component.dart';
import '../quick_links_component/quick_links_component.dart';
import 'severity_select_component.dart';

@Component(
    selector: 'bo-skin-type',
    templateUrl: 'skin_type_component.html',
    styleUrls: const ['skin_type_component.css'],
    directives: const [
      NgFor,
      NgIf,
      MaterialButtonComponent,
      ProductBundleBoxComponent,
      ProductListComponent,
      QuickLinksComponent,
      routerDirectives,
      SeveritySelectComponent
    ],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class SkinTypeComponent implements OnActivate {
  SkinTypeComponent(this._productService, this._skinTypeService,
      this._changeDetectorRef, this.msg);

  @override
  void onActivate(RouterState previous, RouterState current) {
    if (current.parameters['url_name'] != null) {
      model = _skinTypeService.webshopData.values.firstWhere(
          (skinType) => skinType.url_name == current.parameters['url_name'],
          orElse: () => null);

      skinTypeProducts = _productService.cachedModels.values
          .where((product) =>
              product.product_category_id == 'bundle' &&
              product.skin_type_ids.first == model.id)
          .toList(growable: false);

      _evaluateProducts();
      _changeDetectorRef.markForCheck();
    }
  }

  void onSeverityLevelChange(int level) {
    severityLevel = level;
    _evaluateProducts();
    _changeDetectorRef.markForCheck();
  }

  void _evaluateProducts() {
    final products =
        skinTypeProducts.where((p) => p.bundle_severity == severityLevel);
    smallProduct = products.firstWhere((p) => p.bundle_size == 'small',
        orElse: () => null);
    largeProduct = products.firstWhere((p) => p.bundle_size == 'large',
        orElse: () => null);    
  }

  Product smallProduct;
  Product largeProduct;

  SkinType model;
  List<Product> skinTypeProducts;
  int severityLevel = 2;
  final ChangeDetectorRef _changeDetectorRef;
  final ProductService _productService;
  final SkinTypeService _skinTypeService;
  final WebshopMessagesService msg;
}
