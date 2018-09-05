import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import '../../../../product_list_component/product_list_component.dart';
import '../../../not_found_component/not_found_component.dart';

@Component(
    selector: 'bo-product-category-bundle-skin-type-component',
    templateUrl: 'product_category_bundle_skin_type_component.html',
    styleUrls: const ['product_category_bundle_skin_type_component.css'],
    directives: const [NgIf, NotFoundComponent, ProductListComponent],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ProductCategoryBundleSkinTypeComponent implements OnActivate {
  ProductCategoryBundleSkinTypeComponent(this._productService,
      this._skinTypeService, this._changeDetectorRef, this.msg);

  @override
  void onActivate(RouterState previous, RouterState current) {
    currentPath = current.path;

    final label = current.parameters['skin_type'];

    final skinType = _skinTypeService.webshopData.values
        .firstWhere((s) => s.url_name == label, orElse: () => null);

    if (skinType == null) {
      showNotFound = true;
    } else {
      title = msg.bundles_for_title(skinType?.label);
      description = msg.bundles_for_description(skinType?.label);

      products = _productService.cachedModels.values.where((p) =>
          p.product_category_id == 'bundle' &&
          p.skin_type_ids.contains(skinType.id));
    }
    _changeDetectorRef.markForCheck();
  }

  String title;
  String description;
  String currentPath;
  bool showNotFound = false;
  Iterable<Product> products;
  final ProductService _productService;
  final SkinTypeService _skinTypeService;
  final WebshopMessagesService msg;
  final ChangeDetectorRef _changeDetectorRef;
}
