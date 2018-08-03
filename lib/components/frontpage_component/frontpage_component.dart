import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../icon_component/icon_component.dart';
import '../productbox_component/productbox_component.dart';

@Component(
    selector: 'frontpage-component',
    templateUrl: 'frontpage_component.html',
    styleUrls: const [
      'frontpage_component.css'
    ],
    directives: const [
      coreDirectives,
      IconComponent,
      MaterialButtonComponent,
      ProductBoxComponent,
      routerDirectives
    ],
    providers: const [],
    pipes: const [
      NamePipe
    ])
class FrontpageComponent {
  FrontpageComponent(this.languageService, this.productCategoryService, this.productService, this.msg)
      : popularProducts =
            new List<Product>.from(productService.cachedModels.values)..take(4);

  String selectedProductId;
  final LanguageService languageService;
  final ProductCategoryService productCategoryService;
  final ProductService productService;
  final WebshopMessagesService msg;
  final List<Product> popularProducts;
  final String iconSize = '6rem';
}
