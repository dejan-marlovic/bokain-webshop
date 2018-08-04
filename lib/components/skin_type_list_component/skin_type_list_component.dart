import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../quick_links_component/quick_links_component.dart';
import '../skin_type_table_component/skin_type_table_component.dart';

@Component(
  selector: 'bo-skin-type-list',
  templateUrl: 'skin_type_list_component.html',
  styleUrls: const ['skin_type_list_component.css'],
  directives: const [QuickLinksComponent, SkinTypeTableComponent],
  providers: const [],
  pipes: const [NamePipe],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class SkinTypeListComponent {
  SkinTypeListComponent(this._router, this.msg);

  void onSkinTypeSelect(SkinType event) {    
    _router.navigate('${msg.skin_type(2)}/${event.url_name}');
  }

  final Router _router;
  final WebshopMessagesService msg;
}