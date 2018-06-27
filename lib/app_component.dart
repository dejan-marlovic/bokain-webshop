import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:intl/intl.dart';
import 'services/menu_selection_service.dart';

import 'components/footer_large_component/footer_large_component.dart';
import 'components/frontpage_component/frontpage_component.template.dart'
    as frontpage_comp; 
import 'components/nav_large_component/nav_large_component.dart';
import 'components/skin_consultation_component/skin_consultation_component.template.dart'
    as consultation_comp;
import 'route_paths.dart' as route_paths;

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [FooterLargeComponent, MaterialInputComponent, NavLargeComponent, NgIf, routerDirectives],
  providers: const [    
    materialProviders,
    MenuSelectionService,
    MessagesService,
    SkinTypeService,    
    ProductCategoryService,
    ProductService,
    UserLogService,
    UserService,
    routerProvidersHash,
    foProviders
  ],
  pipes: const []
)
class AppComponent {
  AppComponent(this.productCategoryService, this.productService, this.userService, this.msg) {
    userService.login('patrick.minogue@gmail.com', 'lok13rum').then(_loadResources);    
  }

  void _loadResources(String token) async {    
    await productCategoryService.fetchQuery(productCategoryService.collection.where('status', '==', 'active'));
    await productService.fetchQuery(productService.collection.where('status', '==', 'active'));
    _loaded = true;
  }

  bool get loaded => _loaded;

  final ProductCategoryService productCategoryService;
  final ProductService productService;
  final UserService userService;
  final MessagesService msg;

  final List<RouteDefinition> routes = [
    new RouteDefinition(
        routePath: route_paths.frontpage,
        component: frontpage_comp.FrontpageComponentNgFactory),
    new RouteDefinition(
        routePath: route_paths.skinConsultation,
        component: consultation_comp.SkinConsultationComponentNgFactory)
  ];
  
  bool _loaded = false;
}
