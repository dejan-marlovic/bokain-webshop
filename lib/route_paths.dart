/// RoutePaths for bokain webshop
/// make sure the names of messages are consistent with messages defined in MessagesService

library route_paths;

import 'package:angular_router/angular_router.dart';
import 'package:intl/intl.dart';

final RoutePath frontpage =
    new RoutePath(path: 'index.html', useAsDefault: true);

final RoutePath productCategoryFilter = new RoutePath(
    path:
        "${Intl.message('product-categories', name: 'product_categories_url')}/:id");

final RoutePath skinConsultation = new RoutePath(
    path:
        "${Intl.message('skin-consultation', name: 'skin_consultation_url')}");

final RoutePath skinTypeFilter = new RoutePath(
    path: "${Intl.message('skin-types', name: 'skin_types_url')}/:id");

final RoutePath profile =
    new RoutePath(path: Intl.message('profile', name: 'my_profile_url'));

final RoutePath aboutUs =
    new RoutePath(path: Intl.message('about-us', name: 'about_us_url'));

final RoutePath cart = new RoutePath(path: Intl.message('cart', name: 'cart_url'));

final RoutePath customerSupport = new RoutePath(path: Intl.message('customer-support', name: 'customer_support_url'));

final RoutePath faq = new RoutePath(path: Intl.message('faq', name: 'faq_url'));

final RoutePath partners = new RoutePath(path: Intl.message('partners', name: 'partners_url'));

final RoutePath skinGuide = new RoutePath(path: Intl.message('skin-guide', name: 'skin_guide_url'));

final RoutePath skinTest = new RoutePath(path: Intl.message('skin-test', name: 'skin_test_url'));

final RoutePath standardTerms = new RoutePath(path: Intl.message('standard-terms', name: 'standard_terms_url'));
