import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/model/ui/has_factory.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:fo_model/fo_model.dart';
import 'search_component.template.dart' as search;

@Component(
    selector: 'bo-search',
    templateUrl: 'search_component.html',
    styleUrls: const ['search_component.css'],
    directives: const [
      MaterialAutoSuggestInputComponent,
      materialInputDirectives
    ],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class SearchComponent implements OnDestroy {
  SearchComponent(
      this.languageService,
      this.productService,
      this.productCategoryService,
      this.skinTypeService,
      this._router,
      this.msg) {
    _setupModels();
    _onSearchSubscription =
        searchModel.selectionChanges.listen(_onSearchChange);
  }

  @Input()
  String popupPosition = 'below'; // below or above

  List<RelativePosition> get positions => popupPosition == 'below'
      ? RelativePosition.AdjacentBottomEdge
      : RelativePosition.AdjacentTopEdge;

  @override
  void ngOnDestroy() {
    _onSearchSubscription.cancel();
  }

  void _onSearchChange(List<SelectionChangeRecord<dynamic>> changes) {
    String getProductCategoryUrl(Product product) {
      final category = productCategoryService.get(product.product_category_id);

      if (category == null) {
        /// We're dealing with a product category, add it's skin type to the url
        try {
          final skinType = skinTypeService.webshopData[product.skin_type_ids.first];
          return '${msg.bundle(2)}/${skinType.url_name}';
        } on StateError catch (e) {
          print(e);
          return '';
        }      
      }
      else {
        return category.phrases[languageService.currentShortLocale].url_name;
      }
    }

    if (changes.isNotEmpty && changes.first.added.isNotEmpty) {
      final FoModel added = changes.first.added.first;
      if (added is Product) {
        _router.navigate(
            '${msg.product(2)}/${getProductCategoryUrl(added)}/${added.phrases[languageService.currentShortLocale].url_name}');
      } else if (added is ProductCategory) {
        _router.navigate(
            '${msg.product(2)}/${added.phrases[languageService.currentShortLocale].url_name}');
      } else if (added is SkinType) {
        _router.navigate('${msg.skin_types_url()}/${added.url_name}');
      }
    }
  }

  FactoryRenderer<FoModel, SearchOptionRendererComponent> get factoryRenderer =>
      (Object d) => search.SearchOptionRendererComponentNgFactory;

  StreamSubscription<List<SelectionChangeRecord>> _onSearchSubscription;

  void _setupModels() {
    final optionGroups = <OptionGroup<FoModel>>[
      new OptionGroup.withLabel(
          productCategoryService.cachedModels.values.toList(growable: false),
          msg.product_category(2)),
      new OptionGroup.withLabel(
          productService.cachedModels.values
              .where((p) =>
                  p.sub_only == false) // dont list sub_products
              .toList(growable: false),
          msg.product(2)),
      new OptionGroup.withLabel(
          skinTypeService.webshopData.values.toList(growable: false),
          msg.skin_type(2))
    ];

    searchOptions =
        new StringSelectionOptions<FoModel>.withOptionGroups(optionGroups);
  }

  final SelectionModel searchModel = new SelectionModel<FoModel>.single();
  StringSelectionOptions<FoModel> searchOptions;

  final LanguageService languageService;
  final ProductService productService;
  final ProductCategoryService productCategoryService;
  final SkinTypeService skinTypeService;
  final Router _router;
  final WebshopMessagesService msg;
}

@Component(
  selector: 'search-item-renderer',
  template: r'''
        <div class="row collapse">
          <div class="s1 col text-center align-middle">
            <fo-icon *ngIf="productCategory != null" icon="category-{{productCategory.phrases['EN'].url_name}}"></fo-icon>
            <img *ngIf="product != null" [src]="product.image_uri" /> 
            <img *ngIf="skinType != null" [src]="skinType.imageProgress[0][0]" />
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
