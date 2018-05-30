import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'frontpage_component/frontpage_component.template.dart'
    as frontpage_comp;
import 'route_paths.dart' as route_paths;
import 'skin_consultation_component/skin_consultation_component.template.dart'
    as consultation_comp;

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [
    materialDirectives,    
    coreDirectives,
    routerDirectives
  ],
  providers: const [
    materialProviders,
    ProductService,
    UserService,
    routerProvidersHash
  ],
)
class AppComponent {
  AppComponent(this.productService, this.userService) {
    userService
        .login('patrick.minogue@gmail.com', 'lok13rum')
        .then((_) => productService.streamMany());
    //dynamicPhraseService.streamLanguage('sv');
  }
  ProductService productService;
  UserService userService;


  final List<RouteDefinition> routes = [
    new RouteDefinition(
        routePath: route_paths.frontpage,
        component: frontpage_comp.FrontpageComponentNgFactory),
    new RouteDefinition(
        routePath: route_paths.skinConsultation,
        component: consultation_comp.SkinConsultationComponentNgFactory)
  ];
}
