import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:intl/intl.dart';
import '../../services/menu_selection_service.dart';

@Component(
  selector: 'bo-nav-large',
  styleUrls: const ['nav_large_component.css'],
  templateUrl: 'nav_large_component.html',
  directives: const [MaterialInputComponent, NgFor, NgIf, routerDirectives],
)
class NavLargeComponent {
  NavLargeComponent(ProductService productService,
      ProductCategoryService productCategoryService, this.menuSelection, this.skinTypeService, this._router)
      : productCategories = productService.cachedModels.values
            .map((p) => productCategoryService.get(p.product_category_id))
            .toSet()
            .where((category) => category != null)
            .toList(growable: false);

  void onMenuSelection(String value, [String route]) {
    menuSelection.selection = value;
    
    if (route != null) _router.navigate(route);
  }

  final List<ProductCategory> productCategories;
  final MenuSelectionService menuSelection;
  final SkinTypeService skinTypeService;
  final Router _router;
  

  final String cart = Intl.message('cart', name: 'cart', desc: 'shopping cart');
  final String customerSupport =
      Intl.message('customer support', name: 'customer support');
  final String filterByProblemSkin =
      Intl.message('filter by problem skin', name: 'filter by problem skin');
  final String filterByProductCategory = Intl.message(
      'filter by product category',
      name: 'filter by product category');
  final String skinConsultation =
      Intl.message('skin consultation', name: 'skin consultation');
  final String skinGuide = Intl.message('skin guide', name: 'skin guide');
  final String login = Intl.message('login', name: 'login');
  final String language = Intl.message('language', name: 'language');
}
