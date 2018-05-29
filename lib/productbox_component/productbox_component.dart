import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';

@Component(
  selector: 'bo-productbox',
  styleUrls: const ['productbox_component.css'],
  templateUrl: 'productbox_component.html',
  directives: const [coreDirectives, materialDirectives],
)
class ProductBoxComponent implements OnDestroy {
  ProductBoxComponent();

  String getPhrase(String key) {
//    final data = _dynamicPhraseService.getPhrases('products', model?.id);
  //  return (data == null) ? null : data[key];
    return null;
  }

  @Input('model')
  Product model;

  @Output('addButtonClick')
  Stream<String> get addButtonClickOutput => addButtonClickController.stream;
  
  final StreamController<String> addButtonClickController =
      new StreamController();

  @override
  void ngOnDestroy() {
    addButtonClickController.close();
  }
}
