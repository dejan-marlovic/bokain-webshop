import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
  selector: 'bo-result-bar',
  templateUrl: 'result_bar_component.html',
  styleUrls: const ['result_bar_component.css'],
  directives: const [MaterialButtonComponent, NgFor, NgIf],  
  pipes: const [NamePipe],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class ResultBarComponent implements OnInit {
  ResultBarComponent(this.msg);
  final WebshopMessagesService msg;

  void ngOnInit() {
    visibleProgress = skinType.imageProgress.isEmpty ? [] : [skinType.imageProgress.first];
  }

  void showMore() {
    visibleProgress.add(skinType.imageProgress[visibleProgress.length]);
    visibleProgress = new List.from(visibleProgress);
  }

  List<List<String>> visibleProgress = [];

  @Input()
  SkinType skinType;
}