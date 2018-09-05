// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

/// Extends default angular directive 'routerlinkActive' so that it's considered active as soon as url contains its value
@Directive(
  selector: '[routerLinkSubActive]',
)
class RouterLinkSubActive implements AfterViewInit, OnDestroy {
  final Element _element;
  final Router _router;

  StreamSubscription _routeChanged;
  List<String> _classes;

  @ContentChildren(RouterLink)
  List<RouterLink> links;

  RouterLinkSubActive(this._element, this._router);

  @override
  void ngOnDestroy() => _routeChanged?.cancel();

  @override
  void ngAfterViewInit() {
    _routeChanged = _router.onRouteActivated.listen(_update);
    _update(_router.current);
  }

  @Input()
  // ignore: avoid_setters_without_getters
  set routerLinkSubActive(Object classes) {
    if (classes is String) {
      _classes = [classes];
    } else if (classes is List<String>) {
      _classes = classes;
    }
  }

  void _update(RouterState routerState) {    
    final isActive = routerState != null &&
        routerState.path.isNotEmpty &&
        routerState.path.contains(links.first.url.toString());

    _element.classes.toggleAll(_classes, isActive);
  }
}
