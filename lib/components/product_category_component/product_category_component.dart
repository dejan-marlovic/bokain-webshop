import 'package:angular/angular.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import '../product_list_component/product_list_component.dart';

@Component(
    selector: 'bo-product-category',
    templateUrl: 'product_category_component.html',
    styleUrls: const ['product_category_component.css'],
    directives: const [NgFor, NgIf, ProductListComponent],
    providers: const [],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ProductCategoryComponent implements OnInit {
  ProductCategoryComponent(this.languageService, this._productService);

  @override
  void ngOnInit() {
    products = _productService.cachedModels.values.where((product) =>
        product.product_category_id == model.id && !product.sub_only);
  }

  Iterable<Product> products;
  String selectedProductId;
  final LanguageService languageService;
  final ProductService _productService;

  @Input()
  ProductCategory model;
}
