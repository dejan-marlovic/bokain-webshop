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
      FoTabComponent,
      FoTabPanelComponent,
      FoIconComponent,
      MaterialButtonComponent,
      MaterialChipComponent,
      MaterialChipsComponent,
      MaterialExpansionPanel,
      MaterialExpansionPanelSet,
      NgFor,
      NgIf,
      NgSwitch,
      NgSwitchWhen,
      SafeInnerHtmlDirective
    ],
    pipes: const [
      FetchPipe,
      NamePipe
    ])
class ProductComponent implements OnActivate {
  ProductComponent(
      this.cartService,
      this.dailyRoutineService,
      this.languageService,
      this.ingredientService,
      this.productService,
      this.productCategoryService,
      this.skinTypeService,
      this.sanitizationService,
      this.msg);

  @override
  void onActivate(RouterState previous, RouterState current) {
    dom.window.scrollTo(0, 0);

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

        productCategory = productCategoryService.get(model.product_category_id);
        
        dailyRoutine = dailyRoutineService.get(model.daily_routine_id);
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
  ProductCategory productCategory;
  DailyRoutine dailyRoutine;

  final CartService cartService;
  final DailyRoutineService dailyRoutineService;
  final DomSanitizationService sanitizationService;
  final IngredientService ingredientService;
  final LanguageService languageService;
  final ProductService productService;
  final ProductCategoryService productCategoryService;
  final SkinTypeService skinTypeService;
  final WebshopMessagesService msg;

  SafeHtml description;
  SafeHtml usageInstructions;
}
