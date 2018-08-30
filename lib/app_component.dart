import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'components/footer_large_component/footer_large_component.dart';
import 'components/nav_large_component/nav_large_component.dart';
import 'components/pages/about_us_component/about_us_component.template.dart'
    as about_us_comp;
import 'components/pages/cart_component/cart_component.template.dart'
    as cart_comp;
import 'components/pages/confirmation_component/confirmation_component.template.dart'
    as confirmation_comp;
import 'components/pages/customer_support_component/customer_support_component.template.dart'
    as customer_support_comp;
import 'components/pages/faq_component/faq_component.template.dart' as faq_comp;
import 'components/pages/frontpage_component/frontpage_component.template.dart'
    as frontpage_comp;
import 'components/pages/partners_component/partners_component.template.dart'
    as partners_comp;
    /*
import 'components/pages/product_category_filter_component/product_category_bundle_component/product_category_bundle_component.template.dart'
    as product_category_bundle;
    */
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
import 'components/pages/skin_guide_component/skin_guide_component.template.dart'
    as skin_guide_comp;
import 'components/pages/skin_test_component/skin_test_component.template.dart'
    as skin_test_comp;
import 'components/pages/skin_type_list_component/skin_type_component/skin_type_component.template.dart'
    as skin_type_comp;
import 'components/pages/skin_type_list_component/skin_type_list_component.template.dart'
    as skin_type_list_comp;
import 'components/pages/standard_terms_component/standard_terms_component.template.dart'
    as standard_terms_comp;
import 'route_paths.dart' as route_paths;
import 'services/cart_service.dart';
import 'services/route_service.dart';

@Component(
    selector: 'my-app',
    styleUrls: const ['app_component.css'],
    templateUrl: 'app_component.html',
    directives: const [
      FooterLargeComponent,
      MaterialInputComponent,
      NavLargeComponent,
      NgIf,
      routerDirectives
    ],
    providers: const <Object>[
      CartService,
      CountryService,
      ConsultationMessagesService,
      CoreMessagesService,
      CustomerLogService,
      CustomerService,
      DailyRoutineService,
      foProviders,
      IngredientService,
      LanguageService,
      KlarnaCheckoutService,
      materialProviders,
      OrderService,
      ProductCategoryService,
      ProductService,
      RouteService,
      SettingsService,
      SkinTypeService,
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
      this.router,
      this.msg) {
    customerService
        .login('patrick.minogue@minoch.com', 'lok13rum')
        .then(_loadResources);
  }

  void _onLocaleChange(String locale) {
    _cartService.klarnaOrder = null;
    //routeService.routes = _setupRoutes();
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
            component: faq_comp.FaqComponentNgFactory),
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
            routePath: route_paths.standardTerms,
            component: standard_terms_comp.StandardTermsComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.skinTest,
            component: skin_test_comp.SkinTestComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.products,
            component: product_comp.ProductComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.skinTypeList,
            component: skin_type_list_comp.SkinTypeListComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.productCategories,
            component: product_category_filter_comp
                .ProductCategoryFilterComponentNgFactory),

        // Redirect everything else to frontpage
        RouteDefinition.redirect(
            path: '.+', redirectTo: route_paths.frontpage.toUrl())
      ]
      ..productCategoryRoutes = [
        RouteDefinition(
            routePath: route_paths.productCategory,
            component: product_category_comp.ProductCategoryComponentNgFactory),
        RouteDefinition(
            routePath: route_paths.productCategoryProduct,
            component: product_comp.ProductComponentNgFactory)
      ];
  }

  Future<void> _loadResources(String token) async {
    await _languageService.setLocale('SV');
    await _settingsService.fetch('1');

    await productCategoryService.fetchQuery(
        productCategoryService.collection.where('status', '==', 'active'));
    await productService.fetchQuery(productService.collection
        .where('status', '==', 'active')
        .orderBy('score', 'desc'));

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
  final Router router;
  final WebshopMessagesService msg;

  bool _loaded = false;
}
