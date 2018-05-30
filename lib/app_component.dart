import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
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
    PhraseService,
    PhrasesService,
    ProductService,
    UserService,
    routerProvidersHash
  ],
)
class AppComponent {
  AppComponent(this.phrasesService, this.productService, this.userService) {
    
    userService
        .login('patrick.minogue@gmail.com', 'lok13rum')
        .then((_) {
          phrasesService.fetchAll('sv').then((value) {     
            PhraseService.language = 'sv';       
            PhraseService.data = value;
            productService.streamMany();

            loaded = true;
          });
        });
    //dynamicPhraseService.streamLanguage('sv');
  }
  final PhrasesService phrasesService;
  final ProductService productService;
  final UserService userService;


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
