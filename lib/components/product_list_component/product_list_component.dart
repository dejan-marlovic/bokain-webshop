import 'package:angular/angular.dart';
import 'package:angular/security.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../productbox_component/productbox_component.dart';

@Component(
    selector: 'bo-product-list',
    templateUrl: 'product_list_component.html',
    styleUrls: const ['product_list_component.css'],
    directives: const [
      NgFor,
      NgIf,
      ProductBoxComponent,
      SafeInnerHtmlDirective
    ],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ProductListComponent implements OnInit {
  ProductListComponent(this._sanitizer, this.msg);

  @override
  void ngOnInit() {
    if (description != null) {
      descriptionHtml = _sanitizer.bypassSecurityTrustHtml(description);
    }
  }

  SafeHtml descriptionHtml;
  final WebshopMessagesService msg;
  final DomSanitizationService _sanitizer;

  @Input()
  Iterable<Product> products;

  @Input()
  String title;

  @Input()
  String description;
}
