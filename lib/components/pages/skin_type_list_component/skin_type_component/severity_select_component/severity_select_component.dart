import 'dart:async';
import 'package:angular/angular.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
  selector: 'bo-severity-select',
  templateUrl: 'severity_select_component.html',
  styleUrls: const ['severity_select_component.css'],
  directives: const [NgClass, NgFor],  
  pipes: [NamePipe],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class SeveritySelectComponent implements OnDestroy {
  SeveritySelectComponent(this.msg);

  @override
  void ngOnDestroy() {
    _onLevelChangeController.close();
  }

  void onLevelClick(int event) {
    level = event;
    _onLevelChangeController.add(event);    
  }

  
  final List<int> levels = [1, 2, 3];
  final StreamController<int> _onLevelChangeController = new StreamController();
  final WebshopMessagesService msg;  

  @Input()
  SkinType model;

  @Input()
  int level = 2;

  @Output('levelChange')
  Stream<int> get onLevelChange => _onLevelChangeController.stream;
}