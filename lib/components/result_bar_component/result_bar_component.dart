import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
  selector: 'bo-result-bar',
  templateUrl: 'result_bar_component.html',
  styleUrls: const ['result_bar_component.css'],
  directives: const [MaterialButtonComponent, routerDirectives],
  providers: const [],
  pipes: const [NamePipe],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class ResultBarComponent {
  ResultBarComponent(this.msg);
  final WebshopMessagesService msg;

  @Input()
  SkinType skinType;
}