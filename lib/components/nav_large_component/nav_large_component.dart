import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../directives/router_link_sub_active_directive.dart';
import '../../services/cart_service.dart';

@Component(
  selector: 'bo-nav-large',
  styleUrls: const ['nav_large_component.css'],
  templateUrl: 'nav_large_component.html',
  directives: const [
    DropdownMenuComponent,
    FoIconComponent,
    MaterialInputComponent,
    NgFor,
    NgIf,
    routerDirectives,
    RouterLinkSubActive,
  ],
  pipes: const [NamePipe]
)
class NavLargeComponent {
  NavLargeComponent(
      this.languageService,
      this.countryService,
      this.cartService,
      this.productCategoryService,
      this.skinTypeService,
      this.router,
      this.msg) {
    languageMenuModel = new MenuModel([
      new MenuItemGroup(countryService.data.values
          .map((country) =>
              new MenuItem(country.name, action: () => _setLocale(country.language)))
          .toList(growable: false))
    ]);
  }


  Future<void> _setLocale(String iso) async {
    await languageService.setLocale(iso);

    await cartService.evaluateCheckout(languageService.currentShortLocale);

    languageMenuModel = new MenuModel([
      new MenuItemGroup(countryService.data.values
          .map((country) =>
              new MenuItem(country.name, action: () => _setLocale(country.language)))
          .toList(growable: false))
    ], tooltipText: msg.language());    
  }

  bool get skinTypesOpen =>
      router.current?.path?.startsWith(msg.skin_types_url()) == true;

  bool get productCategoriesOpen =>
      router.current?.path?.startsWith(msg.product_categories_url()) == true;

//  String get locale => Intl.shortLocale(Intl.getCurrentLocale()).toUpperCase();

  final CartService cartService;
  final LanguageService languageService;
  final CountryService countryService;
  final ProductCategoryService productCategoryService;
  final SkinTypeService skinTypeService;
  final WebshopMessagesService msg;
  final Router router;

  MenuModel<MenuItem> languageMenuModel;
}
