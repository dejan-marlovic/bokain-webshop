import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../../directives/router_link_sub_active_directive.dart';
import '../../../services/route_service.dart';

@Component(
    selector: 'bo-product-category-filter',
    templateUrl: 'product_category_filter_component.html',
    styleUrls: const ['product_category_filter_component.css'],
    directives: const [FoIconComponent, NgFor, NgIf, RouterLink, RouterLinkActive, RouterOutlet, RouterLinkSubActive],    
    pipes: const [NamePipe])
class ProductCategoryFilterComponent implements OnActivate {
  ProductCategoryFilterComponent(this.languageService,
      ProductCategoryService productCategoryService, this.routeService, this.msg)
      : categories = productCategoryService.cachedModels.values;

  @override
  void onActivate(RouterState previous, RouterState current) {    
  }
  
  String iconSize = '2.5rem';

  final Iterable<ProductCategory> categories;
  final LanguageService languageService;  
  final RouteService routeService;
  final WebshopMessagesService msg;
}
