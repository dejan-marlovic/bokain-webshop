library route_paths;

import 'package:angular_router/angular_router.dart';
import 'package:intl/intl.dart';

final RoutePath frontpage =
    new RoutePath(path: 'index.html', useAsDefault: true);

final RoutePath productCategoryFilter = new RoutePath(    
    path: "${Intl.message('product-categories', name: 'product_categories_url')}/:id");

final RoutePath skinConsultation = new RoutePath(
    path:
        "${Intl.message('skin-consultation', name: 'skin_consultation_url')}");

final RoutePath skinTypeFilter = new RoutePath(
    path: "${Intl.message('skin-types', name: 'skin_types_url')}/:id");
