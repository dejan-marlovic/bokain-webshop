import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:intl/intl.dart';
import '../icon_component/icon_component.dart';
import '../product_category_bundle_component/product_category_bundle_component.dart';
import '../product_category_component/product_category_component.dart';

@Component(
    selector: 'bo-product-category-filter',
    templateUrl: 'product_category_filter_component.html',
    styleUrls: const [
      'product_category_filter_component.css'
    ],
    directives: const [
      IconComponent,
      NgFor,
      NgIf,      
      ProductCategoryBundleComponent,
      ProductCategoryComponent,
      routerDirectives
    ],
    providers: const [],
    pipes: const [      
      NamePipe
    ])
class ProductCategoryFilterComponent implements OnActivate {
  ProductCategoryFilterComponent(
      this.languageService, this._productCategoryService, this.msg)
      : categories = _productCategoryService.cachedModels.values;

  @override
  void onActivate(RouterState previous, RouterState current) {
    if (current.parameters['id'] != null) {
      final lang = Intl.shortLocale(Intl.getCurrentLocale()).toUpperCase();
      category = _productCategoryService.cachedModels.values.firstWhere(
          (category) =>
              category.phrases[lang].url_name == current.parameters['id'],
          orElse: () => null);
    }
  }

  ProductCategory category;
  String iconSize = '2.5rem';
  final Iterable<ProductCategory> categories;
  final LanguageService languageService;
  final ProductCategoryService _productCategoryService;
  final WebshopMessagesService msg;
}
