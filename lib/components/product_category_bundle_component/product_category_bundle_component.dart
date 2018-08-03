import 'package:angular/angular.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../skin_type_table_component/skin_type_table_component.dart';

@Component(
  selector: 'bo-product-category-bundle',
  templateUrl: 'product_category_bundle_component.html',
  styleUrls: const ['product_category_bundle_component.css'],
  directives: const [SkinTypeTableComponent],
  pipes: const [NamePipe],
  providers: const [],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class ProductCategoryBundleComponent {
  ProductCategoryBundleComponent(this.skinTypeService, this.msg);

  void onSkinTypeTrigger(SkinType event) {
    print(event.url_name);
  }

  final SkinTypeService skinTypeService;
  final WebshopMessagesService msg;

}