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
import '../../../result_bar_component/result_bar_component.dart';

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
      ResultBarComponent,
      NgFor,
      NgIf,
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

    description =
        sanitizationService.bypassSecurityTrustHtml(phrases.description_long);
    usageInstructions =
        sanitizationService.bypassSecurityTrustHtml(phrases.usage_instructions);
    importantNotice =
        sanitizationService.bypassSecurityTrustHtml(phrases.important_notice);

    productCategory = productCategoryService.get(model.product_category_id);
    dailyRoutine = dailyRoutineService.get(model.daily_routine_id);
    relatedProducts = productService.getMany(model.related_product_ids);
    subProducts = productService.getMany(model.sub_product_ids);
  }

  String getIcon(Product product) {
    final category = productCategoryService.get(product.product_category_id);
    return category == null
        ? null
        : "category-${category.phrases['EN'].url_name}";
  }

  String getName(Product product) {
    final category = productCategoryService.get(product.product_category_id);
    if (product.volume == 0) {
      return product.phrases[languageService.currentShortLocale].name;
    } else {
      return category == null
          ? null
          : '${category.phrases[languageService.currentShortLocale].name} ${product.volume}ml';
    }
  }

  ProductPhrases get phrases =>
      model == null ? null : model.phrases[languageService.currentShortLocale];

  @Input()
  Product model;

  ProductCategory productCategory;
  DailyRoutine dailyRoutine;
  List<Product> relatedProducts;
  List<Product> subProducts;

  final String iconSize = '3rem';
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
