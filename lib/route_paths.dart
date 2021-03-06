/// RoutePaths for bokain webshop
/// make sure the names of messages are consistent with messages defined in WebshopMessagesService

library route_paths;

import 'package:angular_router/angular_router.dart';
import 'package:intl/intl.dart';

final RoutePath empty = new RoutePath(path: '');

RoutePath get aboutUs =>
    RoutePath(path: Intl.message('about-us', name: 'about_us_url'));

RoutePath get cart => RoutePath(path: Intl.message('cart', name: 'cart_url'));

RoutePath get confirmation =>
    RoutePath(path: 'confirmation');

RoutePath get customerSupport => RoutePath(
    path: Intl.message('customer-support', name: 'customer_support_url'));

RoutePath get faq => RoutePath(path: Intl.message('faq', name: 'faq_url'));

RoutePath get frontpage => RoutePath(path: 'index.html', useAsDefault: true);

RoutePath get partners =>
    RoutePath(path: Intl.message('partners', name: 'partners_url'));

RoutePath get product => RoutePath(
        path:
            "${Intl.plural(2, one: 'product', other: 'products', name: 'product', args: <int>[
      2
    ])}/:url_name");

RoutePath get profile =>
    RoutePath(path: Intl.message('profile', name: 'my_profile_url'));

RoutePath get results =>
    RoutePath(path: Intl.message('results', name: 'results_url'));

RoutePath get skinConsultation => RoutePath(
    path: Intl.message('skin-consultation', name: 'skin_consultation_url'));

RoutePath get skinGuide =>
    RoutePath(path: Intl.message('skin-guide', name: 'skin_guide_url'));

RoutePath get skinGuideCategory =>
    RoutePath(path: "${Intl.message('skin-guide', name: 'skin_guide_url')}/:category_url");

RoutePath get skinGuideArticle =>
    RoutePath(path: "${Intl.message('skin-guide', name: 'skin_guide_url')}/:category_url/:article_url");

RoutePath get skinTest =>
    RoutePath(path: Intl.message('skin-test', name: 'skin_test_url'));

RoutePath get skinTypeList =>
    RoutePath(path: Intl.message('skin-types', name: 'skin_types_url'));

RoutePath get skinType => RoutePath(
    path: "${Intl.message('skin-types', name: 'skin_types_url')}/:url_name");

RoutePath get notFound => RoutePath(path: '404');

RoutePath get products => RoutePath(
    path: Intl.plural(2,
        one: 'product', other: 'products', name: 'products', args: [2]));

RoutePath get productCategory => RoutePath(path: ':url_name', parent: products);

RoutePath get productCategoryBundles => RoutePath(
    path: Intl.plural(2,
        one: 'bundle', other: 'bundles', name: 'bundle', args: <int>[2]),
    parent: products);

RoutePath get productCategoryBundlesSkinType => RoutePath(
    path: "${Intl.plural(2, one: 'bundle', other: 'bundles', args: [
          2
        ], name: 'bundle')}/:skin_type");

RoutePath get productCategoryBundlesSkinTypeBundle => RoutePath(
    path: "${Intl.plural(2, one: 'bundle', other: 'bundles', args: [
          2
        ], name: 'bundle')}/:skin_type/:url_name");

RoutePath get productCategoryProduct =>
    RoutePath(path: ':category_url_name/:url_name', parent: products);
