import 'package:angular/angular.dart';
import 'package:bokain_models/bokain_models.dart';

@Pipe('fetch', pure: false)
class FetchPipe extends PipeTransform {
  Object _cachedModel;

  Object transform(String id, FirestoreService service) {
    if (_service == null) {
      _service = service;      
      _service.fetch(id, force: false, cache: true).then((i) => _cachedModel = i);      
    }
    return _cachedModel;
  }
  FirestoreService _service;
}
