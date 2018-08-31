import 'package:angular/angular.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../productbox_component/productbox_component.dart';

@Component(
    selector: 'bo-product-list',
    templateUrl: 'product_list_component.html',
    styleUrls: const ['product_list_component.css'],
    directives: const [NgFor, NgIf, ProductBoxComponent],    
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ProductListComponent {
  ProductListComponent(this.msg) {
    rootUrl ??= msg.product(2);
  }

  final WebshopMessagesService msg;

  @Input()
  Iterable<Product> products;

  @Input()
  String title;

  @Input()
  String description;

  @Input()
  String rootUrl;
}
