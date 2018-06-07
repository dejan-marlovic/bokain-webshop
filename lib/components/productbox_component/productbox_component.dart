import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
    selector: 'bo-productbox',
    styleUrls: const ['productbox_component.css'],
    templateUrl: 'productbox_component.html',
    directives: const [coreDirectives, materialDirectives],
    providers: const [LanguageService],
    pipes: const [AsyncPipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ProductBoxComponent implements OnInit, OnDestroy {
  ProductBoxComponent(this._phrasesService, this._languageService);

  @override
  void ngOnInit() {
    final langId = _languageService.data.keys.firstWhere(
        (id) => _languageService.data[id].iso639_1 == PhraseService.language);
    if (model == null ||
        _phrasesService.customData['products'][model.id] == null) {
      phrasesModel = new ProductPhrases();
    } else {
      final custom =
          new Map.from(_phrasesService.customData['products'][model.id])
              .cast<String, String>()
                ..removeWhere((key, value) => !key.endsWith('_$langId'));

      phrasesModel = new ProductPhrases.fromJson(custom.map((key, value) =>
          new MapEntry(key.substring(0, key.indexOf('_$langId')), value)));
    }
  }

  @override
  void ngOnDestroy() {
    addButtonClickController.close();
  }

  ProductPhrases phrasesModel;

  @Input('model')
  Product model;

  @Output('addButtonClick')
  Stream<String> get addButtonClickOutput => addButtonClickController.stream;

  final LanguageService _languageService;
  final PhrasesService _phrasesService;

  final StreamController<String> addButtonClickController =
      new StreamController();
}
