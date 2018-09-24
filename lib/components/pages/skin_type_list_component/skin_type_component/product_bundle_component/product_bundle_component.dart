import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../../../../services/cart_service.dart';
import '../../../../productbox_component/productbox_component.dart';

@Component(
    selector: 'bo-product-bundle',
    templateUrl: 'product_bundle_component.html',
    styleUrls: const ['product_bundle_component.css'],
    directives: const [FoIconComponent, MaterialButtonComponent, NgFor, ProductBoxComponent],    
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ProductBundleComponent implements OnInit {
  ProductBundleComponent(this.cartService, this.languageService,
      this._productService, this.productCategoryService, this.msg);

  @override
  void ngOnInit() {
    onSelect(small);
  }

  void onSelect(Product product) {
    selected = product;
    subProducts = selected == null
        ? []
        : _productService
            .getMany(selected.sub_product_ids)
            .toList(growable: false);
  }

  String getIcon(Product product) {
    final category = productCategoryService.get(product.product_category_id);
    return category == null
        ? null
        : "category-${category.phrases['EN'].url_name}";
  }

  String getName(Product product) => product.volume == null ||
          product.volume <= 0
      ? '${product.phrases[languageService.currentShortLocale].name}'
      : '${product.phrases[languageService.currentShortLocale].name} (${product.volume}ml)';

  final CartService cartService;
  final LanguageService languageService;
  final ProductService _productService;
  final ProductCategoryService productCategoryService;
  final WebshopMessagesService msg;

  ProductPhrases get phrases => selected == null
      ? null
      : selected.phrases[languageService.currentShortLocale];

  final String iconSize = '2.5rem';
  Product selected;
  List<Product> subProducts;

  @Input()
  Product small;

  @Input()
  Product large;
}
