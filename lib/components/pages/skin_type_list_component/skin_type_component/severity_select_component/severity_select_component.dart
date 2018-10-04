import 'dart:async';
import 'dart:math';
import 'package:angular/angular.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
    selector: 'bo-severity-select',
    templateUrl: 'severity_select_component.html',
    styleUrls: const ['severity_select_component.css'],
    directives: const [NgClass, NgFor],
    pipes: [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class SeveritySelectComponent implements OnDestroy {
  SeveritySelectComponent(this.msg);

  @override
  void ngOnDestroy() {
    _onLevelChangeController.close();
  }

  void onLevelClick(String event) {
    selectedLevel = event;
    final index =
        model.imageSeverity.keys.toList(growable: false).indexOf(selectedLevel);
    _onLevelChangeController.add(index + 1);
  }

  final StreamController<int> _onLevelChangeController = new StreamController();
  final WebshopMessagesService msg;

  String selectedLevel;

  @Input()
  SkinType model;

  @Input()
  set level(int value) {
    selectedLevel = model.imageSeverity.keys
        .elementAt(min((value - 1), model.imageSeverity.length - 1));
  }

  @Output('levelChange')
  Stream<int> get onLevelChange => _onLevelChangeController.stream;
}
