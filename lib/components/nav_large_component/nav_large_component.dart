import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/model/ui/has_factory.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:fo_model/fo_model.dart';
import '../../directives/router_link_sub_active_directive.dart';
import '../../services/cart_service.dart';
import 'nav_large_component.template.dart' as nav;

@Component(
    selector: 'bo-nav-large',
    styleUrls: const ['nav_large_component.css'],
    templateUrl: 'nav_large_component.html',
    directives: const [
      DropdownMenuComponent,
      FoIconComponent,
      MaterialAutoSuggestInputComponent,
      NgFor,
      NgIf,
      routerDirectives,
      RouterLinkSubActive
    ],
    pipes: const [NamePipe])
class NavLargeComponent implements OnDestroy {
  NavLargeComponent(
      this.languageService,
      this.countryService,
      this.cartService,
      this.productService,
      this.productCategoryService,
      this.skinTypeService,
      this.router,
      this.msg) {
    _setupModels();

    _onSearchSubscription =
        searchModel.selectionChanges.listen(_onSearchChange);
  }

  @override
  void ngOnDestroy() {
    _onSearchSubscription.cancel();
  }

  void _onSearchChange(List<SelectionChangeRecord<dynamic>> changes) {
    if (changes.isNotEmpty && changes.first.added.isNotEmpty) {
      final FoModel added = changes.first.added.first;
      if (added is Product) {
        print(
            '${msg.product(2)}/${added.phrases[languageService.currentShortLocale].url_name}');
        router.navigate(
            '${msg.product(2)}/${added.phrases[languageService.currentShortLocale].url_name}');
      } else if (added is ProductCategory) {
        router.navigate(
            '${msg.product_categories_url()}/${added.phrases[languageService.currentShortLocale].url_name}');
      } else if (added is SkinType) {
        router.navigate('${msg.skin_type(2)}/${added.url_name}');
      }
    }
  }

  Future<void> _setLocale(String iso) async {
    await languageService.setLocale(iso);
    await cartService.evaluateCheckout(languageService.currentShortLocale);

    _setupModels();
  }

  void _setupModels() {
    languageMenuModel = new MenuModel([
      new MenuItemGroup(countryService.data.values
          .map((country) => new MenuItem<String>(country.name,
              action: () => _setLocale(country.language)))
          .toList(growable: false))
    ], tooltipText: msg.language());

    final optionGroups = <OptionGroup<FoModel>>[
      new OptionGroup.withLabel(
          productCategoryService.cachedModels.values.toList(growable: false),
          msg.product_category(2)),
      new OptionGroup.withLabel(
          productService.cachedModels.values
              .where((p) =>
                  p.sub_only == false &&
                  p.sub_product_ids
                      .isEmpty) // dont list bundles or sub_products
              .toList(growable: false),
          msg.product(2)),
      new OptionGroup.withLabel(
          skinTypeService.webshopData.values.toList(growable: false),
          msg.skin_type(2))
    ];

    searchOptions =
        new StringSelectionOptions<FoModel>.withOptionGroups(optionGroups);
  }

/*
  bool get skinTypesOpen =>
      router.current?.path?.startsWith(msg.skin_types_url()) == true;

  bool get productCategoriesOpen =>
      router.current?.path?.startsWith(msg.product_categories_url()) == true;
*/
  String get productCategoryLink =>
      '${msg.product_categories_url()}/${productCategoryService.cachedModels.values.first.phrases[languageService.currentShortLocale].url_name}';

  final CartService cartService;
  final LanguageService languageService;
  final CountryService countryService;
  final ProductService productService;
  final ProductCategoryService productCategoryService;
  final SkinTypeService skinTypeService;
  final WebshopMessagesService msg;
  final Router router;

  final SelectionModel searchModel = new SelectionModel<FoModel>.single();
  StringSelectionOptions<FoModel> searchOptions;

  MenuModel<MenuItem> languageMenuModel;
  StreamSubscription<List<SelectionChangeRecord>> _onSearchSubscription;

  FactoryRenderer<FoModel, SearchOptionRendererComponent> get factoryRenderer =>
      (Object d) => nav.SearchOptionRendererComponentNgFactory;
}

@Component(
  selector: 'example-renderer',
  template: r'''
        <div class="row collapse">
          <div class="s1 col text-center align-middle">
            <fo-icon *ngIf="productCategory != null" icon="category-{{productCategory.phrases['EN'].url_name}}"></fo-icon>
            <img *ngIf="product != null" [src]="product.image_uri" /> 
            <img *ngIf="skinType != null" [src]="skinType.imageProgress[0]" />
          </div>
          <div class="s11 col">
            <span>{{displayValue | name}}</span>
          </div>
        </div>
    ''',
  styles: ['fo-icon { } img { display: flex; } span { margin-left: 8px; }'],
  pipes: const [NamePipe],
  directives: [FoIconComponent, NgIf],
)
class SearchOptionRendererComponent implements RendersValue<FoModel> {
  SearchOptionRendererComponent(this.languageService);

  String displayValue = '';

  @override
  @Input()
  set value(FoModel newValue) {
    if (newValue is Product) {
      product = newValue;
      displayValue = product.phrases[languageService.currentShortLocale].name;
    } else if (newValue is ProductCategory) {
      productCategory = newValue;
      displayValue =
          productCategory.phrases[languageService.currentShortLocale].name;
    } else if (newValue is SkinType) {
      skinType = newValue;
      displayValue = skinType.label;
    } else
      displayValue = newValue.toString();
  }

  Product product;
  ProductCategory productCategory;
  SkinType skinType;

  final LanguageService languageService;
}
