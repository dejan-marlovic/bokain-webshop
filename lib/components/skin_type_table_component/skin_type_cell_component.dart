import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
  selector: 'bo-skin-type-cell',
  templateUrl: 'skin_type_cell_component.html',
  styleUrls: const ['skin_type_cell_component.css'],
  directives: const [MaterialButtonComponent, NgStyle],  
  pipes: const [NamePipe]
)
class SkinTypeCellComponent implements OnDestroy {
  SkinTypeCellComponent(this.msg);

  @override
  void ngOnDestroy() {
    onTriggerController?.close();
  }

  String get background => "url('${model.imageSeverity[1]}')";

  final CoreMessagesService msg;
  final StreamController<SkinType> onTriggerController = new StreamController();

  @Input()
  SkinType model;

  @Output('trigger')
  Stream<SkinType> get onTrigger => onTriggerController.stream;


}