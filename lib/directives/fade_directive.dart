import 'dart:html' as dom;
import 'package:angular/angular.dart';

@Directive(selector: '[fade]')
class FadeDirective {
  final dom.Element _element;

  @Input()
  set faded(bool value) {
    _element.style.opacity = value ? '0' : '1';
  }

  FadeDirective(this._element) {
    _element.style
      ..transition = 'all 0.3s ease'
      ..opacity = '0';
  }
}
