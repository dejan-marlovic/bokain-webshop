import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'quick_link_card_component.dart';

@Component(
  selector: 'bo-quick-links',
  templateUrl: 'quick_links_component.html',
  styleUrls: const ['quick_links_component.css'],
  directives: const [QuickLinkCardComponent],
  providers: const [],
  pipes: const [NamePipe],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class QuickLinksComponent {
  QuickLinksComponent(this.router, this.msg);



  final Router router;
  final WebshopMessagesService msg;
  
}