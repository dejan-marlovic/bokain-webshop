import 'dart:html' as dom;

class MetaDataService {
  set description(String value) {
    _removeOldTags('description');

    if (value != null) {
      dom.document.head.append(new dom.MetaElement()
        ..name = 'description'
        ..content = value);
    }
  }

  set keywords(String value) {
    _removeOldTags('keywords');
    if (value != null) {
      dom.document.head.append(new dom.MetaElement()
        ..name = 'keywords'
        ..content = value);
    }
  }

  void _removeOldTags(String name) {
    final oldTags = dom.document.head
        .querySelectorAll('meta')
        .where((e) =>
            e.attributes.containsKey('name') && e.attributes['name'] == name)
        .toList(growable: false);

    for (final e in oldTags) {
      e.remove();
    }
  }
}
