import 'package:angular/angular.dart';
import 'package:fo_components/fo_components.dart';

@Component(
  selector: 'bo-quick-link-card',
  templateUrl: 'quick_link_card_component.html',
  styleUrls: const ['quick_link_card_component.css'],
  directives: const [FoIconComponent],
  providers: const [],
  pipes: const [NamePipe],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class QuickLinkCardComponent {

  QuickLinkCardComponent();

  String iconSize = '6rem';
  
  @Input()
  String icon;

  @Input()
  String label;
}