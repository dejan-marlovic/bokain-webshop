import 'package:angular/angular.dart';
import 'package:bokain_models/bokain_models.dart';

@Pipe('fetch', pure: false)
class FetchPipe extends PipeTransform {
  FetchPipe(this._changeDetector);

  Object _cachedModel;

  Object transform(String id, FirestoreService service) {
    if (_service == null) {

      void setModel(Object i) {
        _cachedModel = i;
        _changeDetector.markForCheck();
      }

      _service = service;      
      _service.fetch(id, force: false, cache: true).then(setModel);      
    }
    return _cachedModel;
  }
  FirestoreService _service;
  final ChangeDetectorRef _changeDetector;
}
