import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import '../../../../product_list_component/product_list_component.dart';

@Component(
    selector: 'bo-product-category-bundle-skin-type-component',
    templateUrl: 'product_category_bundle_skin_type_component.html',
    styleUrls: const ['product_category_bundle_skin_type_component.css'],
    directives: const [ProductListComponent],
    providers: const [],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ProductCategoryBundleSkinTypeComponent implements OnActivate {
  ProductCategoryBundleSkinTypeComponent(this._productService,
      this._skinTypeService, this._changeDetectorRef, this.msg);

  @override
  void onActivate(RouterState previous, RouterState current) {
    final label = current.path.split('/').last;

    final skinType = _skinTypeService.webshopData.values
        .firstWhere((s) => s.url_name == label, orElse: () => null);

    title = msg.bundles_for_title(skinType?.label);
    description = msg.bundles_for_description(skinType?.label);

    products = _productService.cachedModels.values
        .where((p) => p.product_category_id == 'bundle' && p.skin_type_ids.contains(skinType.id));

    _changeDetectorRef.markForCheck();


    /*
    if (products.isEmpty) {
      _router.navigate('index.html');
    }            
    */
  }

  String title;
  String description;

  Iterable<Product> products;
  final ProductService _productService;
  final SkinTypeService _skinTypeService;
  final WebshopMessagesService msg;
  final ChangeDetectorRef _changeDetectorRef;
}
