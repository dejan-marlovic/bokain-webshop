import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'components/frontpage_component/frontpage_component.template.dart'
    as frontpage_comp;
import 'components/skin_consultation_component/skin_consultation_component.template.dart'
    as consultation_comp;
import 'route_paths.dart' as route_paths;

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [materialDirectives, coreDirectives, routerDirectives],
  providers: const [
    materialProviders,
    MessagesService,        
    PhraseService,
    ProductService,
    UserService,
    routerProvidersHash
  ],
  pipes: const []
)
class AppComponent {
  AppComponent(this.productService, this.userService, this.msg) {
    userService.login('patrick.minogue@gmail.com', 'lok13rum').then((_) => loaded = true);    
  }  
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

  bool loaded = false;
}
