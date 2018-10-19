import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import '../../../../services/meta_data_service.dart';
import '../../../product_list_component/product_list_component.dart';

@Component(
    selector: 'bo-product-category',
    templateUrl: 'product_category_component.html',
    styleUrls: const ['product_category_component.css'],
    directives: const [NgFor, NgIf, ProductListComponent],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.Default)
class ProductCategoryComponent implements OnActivate {
  ProductCategoryComponent(this.languageService, this._productService,
      this._productCategoryService, this._metaDataService, this._msg);

  @override
  void onActivate(RouterState previous, RouterState current) {
    final category = current.parameters['url_name'];

    model = _productCategoryService.cachedModels.values.firstWhere(
        (cat) =>
            category ==
            cat.phrases[languageService.currentShortLocale].url_name,
        orElse: () => null);

    if (model == null) {
      products = _productService.cachedModels.values
          .where((p) => !p.sub_only && p.sub_product_ids.isEmpty);
      title = _msg.our_products();
      description = _msg.our_products_description();
    } else {
      products = _productService.cachedModels.values.where((product) =>
          product.product_category_id == model.id && !product.sub_only);
      title = model.phrases[languageService.currentShortLocale]?.name;
      description =
          model.phrases[languageService.currentShortLocale]?.description;

      _metaDataService
        ..description =
            model.phrases[languageService.currentShortLocale]?.meta_description
        ..keywords =
            model.phrases[languageService.currentShortLocale].meta_keywords;
    }
  }

  Iterable<Product> products;
  String selectedProductId;
  final LanguageService languageService;
  final ProductService _productService;
  final ProductCategoryService _productCategoryService;
  final MetaDataService _metaDataService;
  final WebshopMessagesService _msg;

  ProductCategory model;
  String title;
  String description;
}
