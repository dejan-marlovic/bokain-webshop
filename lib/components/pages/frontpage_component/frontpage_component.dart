import 'dart:html' as dom;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../product_list_component/product_list_component.dart';

@Component(
    selector: 'frontpage-component',
    templateUrl: 'frontpage_component.html',
    styleUrls: const [
      'frontpage_component.css'
    ],
    directives: const [
      coreDirectives,
      FoIconComponent,
      MaterialButtonComponent,
      ProductListComponent,
      routerDirectives
    ],    
    pipes: const [
      NamePipe
    ])
class FrontpageComponent implements OnActivate {
  FrontpageComponent(this.languageService, this.productCategoryService,
      this.productService, this.msg)
      : popularProducts = new List<Product>.from(productService
            .cachedModels.values
            .where((p) => !p.sub_only && p.product_category_id != 'bundle')
            .take(4));

  @override
  void onActivate(RouterState previous, RouterState current) {
    dom.window.scrollTo(0, 0);
  }

  final LanguageService languageService;
  final ProductCategoryService productCategoryService;
  final ProductService productService;
  final WebshopMessagesService msg;
  final List<Product> popularProducts;
  final String iconSize = '6rem';
}
