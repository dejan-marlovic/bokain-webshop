import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../../quick_links_component/quick_links_component.dart';
import '../../../skin_type_table_component/skin_type_table_component.dart';

@Component(
  selector: 'bo-product-category-bundle',
  templateUrl: 'product_category_bundle_component.html',
  styleUrls: const ['product_category_bundle_component.css'],
  directives: const [QuickLinksComponent, SkinTypeTableComponent],
  pipes: const [NamePipe],  
  changeDetection: ChangeDetectionStrategy.OnPush
)
class ProductCategoryBundleComponent {
  ProductCategoryBundleComponent(this.skinTypeService, this._router, this.msg);

  void onSkinTypeSelect(SkinType event) {    
    _router.navigate('${msg.product(2)}/${msg.bundle(2)}/${event.url_name}');
  }

  final SkinTypeService skinTypeService;
  final Router _router;
  final WebshopMessagesService msg;

}