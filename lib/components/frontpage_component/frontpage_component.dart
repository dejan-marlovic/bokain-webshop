import 'package:angular/angular.dart';
import 'package:bokain_models/bokain_models.dart';
import '../productbox_component/productbox_component.dart';

@Component(
    selector: 'frontpage-component',
    templateUrl: 'frontpage_component.html',
    styleUrls: const ['frontpage_component.css'],
    directives: const [coreDirectives, ProductBoxComponent],
    providers: const [])
class FrontpageComponent {
  FrontpageComponent(this.productService)
      : popularProducts =
            new List<Product>.from(productService.cachedModels.values)              
              ..take(4);

  String selectedProductId;
  final ProductService productService;

  final List<Product> popularProducts;
}
