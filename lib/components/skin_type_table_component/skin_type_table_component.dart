import 'dart:async';
import 'package:angular/angular.dart';
import 'package:bokain_models/bokain_models.dart';
import 'skin_type_cell_component.dart';

@Component(
  selector: 'bo-skin-type-table',
  templateUrl: 'skin_type_table_component.html',
  styleUrls: const ['skin_type_table_component.css'],
  directives: const [NgFor, SkinTypeCellComponent],  
  pipes: const []
)
class SkinTypeTableComponent implements OnDestroy {
  SkinTypeTableComponent(this.skinTypeService);

  @override
  void ngOnDestroy() {
    onTriggerController?.close();
  }

  final SkinTypeService skinTypeService;
  final StreamController<SkinType> onTriggerController = new StreamController();
  
  @Output('trigger')
  Stream<SkinType> get onTrigger => onTriggerController.stream;

}