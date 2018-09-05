import 'package:angular/angular.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
    selector: 'bo-not-found',
    templateUrl: 'not_found_component.html',
    styleUrls: const ['not_found_component.css'],
    directives: const [],
    providers: const [],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class NotFoundComponent {
  NotFoundComponent(this.msg);

  final WebshopMessagesService msg;
}
