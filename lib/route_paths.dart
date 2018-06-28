library route_paths;

import 'package:angular_router/angular_router.dart';
import 'package:intl/intl.dart';

final RoutePath frontpage =
    new RoutePath(path: 'index.html', useAsDefault: true);

final RoutePath productCategoryFilter = new RoutePath(
    // ignore: prefer_interpolation_to_compose_strings    
    path: url(Intl.plural(2,
        one: 'product category',
        other: 'product categories',
        name: 'product category')) + '/:id');

final RoutePath skinConsultation = new RoutePath(
    path: url(Intl.plural(1,
        one: 'skin consultation',
        other: 'skin consultations',
        name: 'skin consultation')));

final RoutePath skinTypeFilter = new RoutePath(
    // ignore: prefer_interpolation_to_compose_strings
    path: url(Intl.plural(2,
            one: 'skin type', other: 'skin types', name: 'skin type')) +
        '/:id');

String url(String value) => Uri.encodeFull(value.replaceAll(' ', '-'));
