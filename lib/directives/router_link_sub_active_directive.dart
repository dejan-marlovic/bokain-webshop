// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'package:collection/collection.dart';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

/// Extends default angular directive 'routerlinkActive' with including sub-links
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
    var isActive = false;
    if (routerState != null) {
      if (routerState.path.isEmpty) return;
      final routeSegments = routerState.path.split('/')..remove('');
      for (var link in links) {
        final url = link.url;
        final urlSegments = url.path.split('/')..remove('');

        bool checkPathRecursive(
            List<String> urlSeg, List<String> routeSeg, int index) {
          if (index > routeSeg.length - 2 && urlSeg[0] == routeSeg[0]) {
            return true;
          } else if (urlSeg[index] != routeSeg[index]) {
            return false;
          } else {
            return checkPathRecursive(urlSeg, routeSeg, index + 1);
          }
        }

        if (!checkPathRecursive(urlSegments, routeSegments, 0)) continue;

        // Only compare query parameters if specified in the [routerLink].
        if (url.queryParameters.isNotEmpty &&
            !const MapEquality()
                .equals(url.queryParameters, routerState.queryParameters)) {
          continue;
        }
        // The link or sublink matches the current router state and should be activated.
        isActive = true;
        break;
      }
    }
    _element.classes.toggleAll(_classes, isActive);
  }
}
