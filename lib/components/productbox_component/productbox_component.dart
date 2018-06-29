import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:intl/intl.dart';

@Component(
    selector: 'bo-productbox',
    styleUrls: const ['productbox_component.css'],
    templateUrl: 'productbox_component.html',
    directives: const [materialDirectives])
class ProductBoxComponent implements OnDestroy {
  ProductBoxComponent();

  @override
  void ngOnDestroy() {
    addButtonClickController.close();
  }

  String get lang => Intl.shortLocale(Intl.getCurrentLocale());

  @Input('model')
  Product model;

  @Output('addButtonClick')
  Stream<String> get addButtonClickOutput => addButtonClickController.stream;

  final StreamController<String> addButtonClickController =
      new StreamController();
}
