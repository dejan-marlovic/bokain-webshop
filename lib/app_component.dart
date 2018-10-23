import 'dart:async';
import 'dart:convert' show json;
import 'dart:html' as html;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:persistent_data/persistent_data.dart' as pd;
import 'components/footer_component/footer_component.dart';
import 'components/nav_component/nav_component.dart';
import 'components/pages/about_us_component/about_us_component.template.dart'
    as about_us_comp;
import 'components/pages/cart_component/cart_component.template.dart'
    as cart_comp;
import 'components/pages/confirmation_component/confirmation_component.template.dart'
    as confirmation_comp;
import 'components/pages/customer_support_component/customer_support_component.template.dart'
    as customer_support_comp;
import 'components/pages/frontpage_component/frontpage_component.template.dart'
    as frontpage_comp;
import 'components/pages/not_found_component/not_found_component.template.dart'
    as not_found_comp;
import 'components/pages/partners_component/partners_component.template.dart'
    as partners_comp;
import 'components/pages/product_category_filter_component/bundle_component/bundle_component.template.dart'
    as product_category_bundle;
import 'components/pages/product_category_filter_component/bundle_component/skin_type_component/skin_type_component.template.dart'
    as product_category_bundle_skin_type;
import 'components/pages/product_category_filter_component/product_category_component/product_category_component.template.dart'
    as product_category_comp;
import 'components/pages/product_category_filter_component/product_category_filter_component.template.dart'
    as product_category_filter_comp;
import 'components/pages/product_component/product_component.template.dart'
    as product_comp;
import 'components/pages/profile_component/profile_component.template.dart'
    as profile_comp;
import 'components/pages/results_component/results_component.template.dart'
    as results_comp;
import 'components/pages/skin_consultation_component/skin_consultation_component.template.dart'
    as consultation_comp;
import 'components/pages/skin_guide_component/article_component/article_component.template.dart'
    as article_comp;
import 'components/pages/skin_guide_component/skin_guide_category_component.template.dart'
    as skin_guide_category_comp;
import 'components/pages/skin_guide_component/skin_guide_component.template.dart'
    as skin_guide_comp;
import 'components/pages/skin_test_component/skin_test_component.template.dart'
    as skin_test_comp;
import 'components/pages/skin_type_list_component/skin_type_component/skin_type_component.template.dart'
    as skin_type_comp;
import 'components/pages/skin_type_list_component/skin_type_list_component.template.dart'
    as skin_type_list_comp;
import 'route_paths.dart' as route_paths;
import 'services/cart_service.dart';
import 'services/config_service.dart';
import 'services/meta_data_service.dart';
import 'services/route_service.dart';

@Component(
    selector: 'my-app',
    styleUrls: const ['app_component.css'],
    templateUrl: 'app_component.html',
    directives: const [
      FooterLargeComponent,
      MaterialInputComponent,
      NavComponent,
      NgIf,
      routerDirectives
    ],
    providers: const <Object>[
      CartService,
      ConfigService,
      ConsultationMessagesService,
      CoreMessagesService,
      CountryService,
      CustomerLogService,
      CustomerService,
      DailyRoutineService,
      FaceZoneService,
      foProviders,
      IngredientService,
      LanguageService,
      KlarnaCheckoutService,
      materialProviders,
      ClassProvider(MetaDataService),
      OrderService,
      ProductCategoryService,
      ProductService,
      RouteService,
      SettingsService,
      SkinTypeService,
      SymptomService,
      WebshopContentService,
      WebshopMessagesService
    ],
    pipes: const [])
class AppComponent {
  AppComponent(
      this._cartService,
      this.productCategoryService,
      this.productService,
      this.customerService,
      this._languageService,
      this.routeService,
      this._settingsService,
      this._metaDataService,
      this.router,
      this.msg) {
    customerService
        .login(FirestoreService.defaultCustomerId,
            FirestoreService.defaultCustomerPassword,
            requireEmailVerified: false)
        .then(_loadResources);

    router.onNavigationStart.listen((_) {
      html.window.scrollTo(0, 0);
      _metaDataService
        ..description = null
        ..keywords = null;
    });
  }

  void _onLocaleChange(String locale) {
    _cartService.klarnaOrder = null;
    _setupRoutes();
  }

  void _setupRoutes() {
    routeService
      ..routes = [
        RouteDefinition(
            routePath: route_paths.frontpage,
            component: frontpage_comp.FrontpageComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.skinConsultation,
            component: consultation_comp.SkinConsultationComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.skinType,
            component: skin_type_comp.SkinTypeComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.profile,
            component: profile_comp.ProfileComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.aboutUs,
            component: about_us_comp.AboutUsComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.cart,
            component: cart_comp.CartComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.confirmation,
            component: confirmation_comp.ConfirmationComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.customerSupport,
            component: customer_support_comp.CustomerSupportComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.faq,
            component: customer_support_comp.CustomerSupportComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.partners,
            component: partners_comp.PartnersComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.results,
            component: results_comp.ResultsComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.skinGuide,
            component: skin_guide_comp.SkinGuideComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.skinGuideCategory,
            component:
                skin_guide_category_comp.SkinGuideCategoryComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.skinGuideArticle,
            component: article_comp.ArticleComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.skinTest,
            component: skin_test_comp.SkinTestComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.skinTypeList,
            component: skin_type_list_comp.SkinTypeListComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.products,
            component: product_category_filter_comp
                .ProductCategoryFilterComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.notFound,
            component: not_found_comp.NotFoundComponentNgFactory),

        // Redirect everything else to frontpage
        RouteDefinition.redirect(
            path: '.+', redirectTo: route_paths.notFound.toUrl())
      ]
      ..productCategoryRoutes = [
        RouteDefinition(
            routePath: route_paths.productCategoryBundles,
            component: product_category_bundle
                .ProductCategoryBundleComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.productCategoryBundlesSkinType,
            component: product_category_bundle_skin_type
                .ProductCategoryBundleSkinTypeComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.productCategoryBundlesSkinTypeBundle,
            component: product_comp.ProductComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.productCategory,
            component: product_category_comp.ProductCategoryComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.productCategoryProduct,
            component: product_comp.ProductComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.empty,
            component: product_category_comp.ProductCategoryComponentNgFactory),
        RouteDefinition.redirect(
            path: '.+', redirectTo: route_paths.notFound.toUrl())
      ];
  }

  Future<void> _loadResources(String user_id) async {
    await _languageService.setLocale('SV', LanguageContext.webshop);
    await _settingsService.fetch('1');

    await productCategoryService.fetchQuery(productCategoryService.collection
        .where('status', '==', 'active')
        .orderBy('search_rank'));
    await productService.fetchQuery(productService.collection
        .where('status', '==', 'active')
        .orderBy('score', 'desc'));

    pd.load();
    final products = pd.get('products', permanent: true);
    if (products != null && products.isNotEmpty) {
      try {
        final Map<String, int> productData =
            json.decode(products).cast<String, int>();
        for (final product in productData.keys) {
          for (var i = 0; i < productData[product]; i++) {
            _cartService.add(product, showPreview: false);
          }
        }
      } on FormatException catch (e) {
        print(e);
      }
    }

    _setupRoutes();

    _languageService.localeChanges.listen(_onLocaleChange);

    _loaded = true;
  }

  bool get loaded => _loaded;

  final CartService _cartService;
  final RouteService routeService;
  final ProductCategoryService productCategoryService;
  final ProductService productService;
  final CustomerService customerService;
  final LanguageService _languageService;
  final SettingsService _settingsService;
  final MetaDataService _metaDataService;
  final Router router;
  final WebshopMessagesService msg;

  bool _loaded = false;
}
