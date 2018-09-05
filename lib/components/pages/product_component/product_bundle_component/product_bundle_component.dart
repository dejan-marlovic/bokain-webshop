import 'dart:html' as dom;
import 'package:angular/angular.dart';
import 'package:angular/security.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../../../components/product_list_component/product_list_component.dart';
import '../../../../components/quick_links_component/quick_links_component.dart';
import '../../../../pipes/fetch_pipe.dart';
import '../../../../services/cart_service.dart';

@Component(
    selector: 'bo-product-bundle',
    templateUrl: 'product_bundle_component.html',
    styleUrls: const [
      'product_bundle_component.css'
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
      ProductListComponent,
      QuickLinksComponent,
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
class ProductBundleComponent implements OnInit {
  ProductBundleComponent(
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
  void ngOnInit() {
    dom.window.scrollTo(0, 0);

    description = sanitizationService.bypassSecurityTrustHtml(
        model.phrases[languageService.currentShortLocale].description_long);
    usageInstructions = sanitizationService.bypassSecurityTrustHtml(
        model.phrases[languageService.currentShortLocale].usage_instructions);
    importantNotice = sanitizationService.bypassSecurityTrustHtml(
        model.phrases[languageService.currentShortLocale].important_notice);

    productCategory = productCategoryService.get(model.product_category_id);
    dailyRoutine = dailyRoutineService.get(model.daily_routine_id);
    relatedProducts = productService.getMany(model.related_product_ids);
  }

  @Input()
  Product model;

  ProductCategory productCategory;
  DailyRoutine dailyRoutine;
  List<Product> relatedProducts;

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
  SafeHtml importantNotice;
}
