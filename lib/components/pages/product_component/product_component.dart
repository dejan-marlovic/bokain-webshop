import 'dart:html' as dom;
import 'package:angular/angular.dart';
import 'package:angular/security.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../../pipes/fetch_pipe.dart';
import '../../../services/cart_service.dart';

@Component(
    selector: 'bo-product',
    templateUrl: 'product_component.html',
    styleUrls: const [
      'product_component.css'
    ],
    directives: const [
      MaterialButtonComponent,
      MaterialExpansionPanel,
      MaterialExpansionPanelSet,
      NgFor,
      NgIf,
      SafeInnerHtmlDirective
    ],
    providers: const [],
    pipes: const [
      FetchPipe,
      NamePipe
    ])
class ProductComponent implements OnActivate {
  ProductComponent(
      this.cartService,
      this.languageService,
      this.ingredientService,
      this.productService,
      this.sanitizationService,
      this.msg);

  @override
  void onActivate(RouterState previous, RouterState current) {
    dom.window.scrollTo(0,0);
    /// Figure out model
    if (current.parameters['url_name'] != null) {
      model = productService.cachedModels.values.firstWhere(
          (p) => _match(p, current.parameters['url_name']),
          orElse: () => null);

      if (model != null) {
        description = sanitizationService.bypassSecurityTrustHtml(
            model.phrases[languageService.currentShortLocale].description_long);
        usageInstructions = sanitizationService.bypassSecurityTrustHtml(model
            .phrases[languageService.currentShortLocale].usage_instructions);
      }
    }
  }

  bool _match(Product product, String url_name) {
    for (final lang in languageService.data.keys) {
      if (product?.phrases[lang.toUpperCase()]?.url_name == url_name)
        return true;
    }
    return false;
  }

  Product model;

  final CartService cartService;
  final DomSanitizationService sanitizationService;
  final IngredientService ingredientService;
  final LanguageService languageService;
  final ProductService productService;
  final WebshopMessagesService msg;

  SafeHtml description;
  SafeHtml usageInstructions;
}
