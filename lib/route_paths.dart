/// RoutePaths for bokain webshop
/// make sure the names of messages are consistent with messages defined in WebshopMessagesService

library route_paths;

import 'package:angular_router/angular_router.dart';
import 'package:intl/intl.dart';

RoutePath get aboutUs =>
    RoutePath(path: Intl.message('about-us', name: 'about_us_url'));

RoutePath get cart => RoutePath(path: Intl.message('cart', name: 'cart_url'));

RoutePath get confirmation =>
    RoutePath(path: Intl.message('confirmation', name: 'confirmation'));

RoutePath get customerSupport => RoutePath(
    path: Intl.message('customer-support', name: 'customer_support_url'));

RoutePath get faq => RoutePath(path: Intl.message('faq', name: 'faq_url'));

RoutePath get frontpage => RoutePath(path: 'index.html', useAsDefault: true);

RoutePath get partners =>
    RoutePath(path: Intl.message('partners', name: 'partners_url'));

RoutePath get products => RoutePath(
    path: "${Intl.plural(2, one:'product', other: 'products', name: 'product', args: <int>[2])}/:url_name");

RoutePath get profile =>
    RoutePath(path: Intl.message('profile', name: 'my_profile_url'));

RoutePath get results =>
    RoutePath(path: Intl.message('results', name: 'results_url'));

RoutePath get skinConsultation => RoutePath(
    path: Intl.message('skin-consultation', name: 'skin_consultation_url'));

RoutePath get skinGuide =>
    RoutePath(path: Intl.message('skin-guide', name: 'skin_guide_url'));

RoutePath get skinTest =>
    RoutePath(path: Intl.message('skin-test', name: 'skin_test_url'));

RoutePath get skinTypeList =>
    RoutePath(path: Intl.message('skin-types', name: 'skin_types_url'));

RoutePath get skinType => RoutePath(
    path: "${Intl.message('skin-types', name: 'skin_types_url')}/:url_name");

RoutePath get standardTerms =>
    RoutePath(path: Intl.message('standard-terms', name: 'standard_terms_url'));

RoutePath get productCategories => RoutePath(
    path: Intl.message('product-categories', name: 'product_categories_url'));

RoutePath get productCategory =>
    RoutePath(path: ':url_name', parent: productCategories);

RoutePath get productCategoryBundles => RoutePath(
    path: Intl.plural(2,
        one: 'bundle', other: 'bundles', name: 'bundle', args: <int>[2]),
    parent: productCategories);

RoutePath get productCategoryProduct =>
    RoutePath(path: ':category_url_name/:url_name', parent: productCategories);
