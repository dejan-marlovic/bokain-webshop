import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../product_list_component/product_list_component.dart';
import '../quick_links_component/quick_links_component.dart';
import 'severity_select_component.dart';

@Component(
    selector: 'bo-skin-type',
    templateUrl: 'skin_type_component.html',
    styleUrls: const ['skin_type_component.css'],
    directives: const [
      NgFor,
      NgIf,
      MaterialButtonComponent,
      ProductListComponent,
      QuickLinksComponent,
      SeveritySelectComponent
    ],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class SkinTypeComponent implements OnActivate {
  SkinTypeComponent(this._productService, this._skinTypeService,
      this._changeDetectorRef, this.msg);

  @override
  void onActivate(RouterState previous, RouterState current) {
    if (current.parameters['url_name'] != null) {
      model = _skinTypeService.webshopData.values.firstWhere(
          (skinType) => skinType.url_name == current.parameters['url_name'],
          orElse: () => null);

      _changeDetectorRef.markForCheck();
    }
  }

  SkinType model;
  int severityLevel = 2;
  final ChangeDetectorRef _changeDetectorRef;
  final ProductService _productService;
  final SkinTypeService _skinTypeService;
  final WebshopMessagesService msg;
}
