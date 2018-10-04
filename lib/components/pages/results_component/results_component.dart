import 'package:angular/angular.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
  selector: 'bo-results',
  templateUrl: 'results_component.html',
  styleUrls: const ['results_component.css'],
  directives: const [NgFor],
  pipes: const [NamePipe],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class ResultsComponent {
  ResultsComponent(this.skinTypeService, this.msg);

  final SkinTypeService skinTypeService;
  final WebshopMessagesService msg;
}