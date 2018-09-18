import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../../directives/router_link_sub_active_directive.dart';
import '../../../services/cart_service.dart';
import '../../search_component/search_component.dart';

@Component(
    selector: 'bo-nav-large',
    styleUrls: const ['nav_large_component.css'],
    templateUrl: 'nav_large_component.html',
    directives: const [
      DropdownMenuComponent,
      FoIconComponent,
      MaterialIconComponent,
      NgFor,
      NgIf,
      routerDirectives,
      RouterLinkSubActive,
      SearchComponent
    ],
    pipes: const [NamePipe])
class NavLargeComponent {
  NavLargeComponent(
      this.languageService, this.countryService, this.cartService, this.msg) {
    _setupModels();
  }

  Future<void> _setLocale(String iso) async {
    await languageService.setLocale(iso, LanguageContext.webshop);
    await cartService.evaluateCheckout(languageService.currentShortLocale);

    _setupModels();
  }

  void _setupModels() {
    languageMenuModel = new MenuModel([
      new MenuItemGroup(countryService.data.values
          .map((country) => new MenuItem<String>(country.name,
              action: () => _setLocale(country.language)))
          .toList(growable: false))
    ], tooltipText: msg.language());
  }

  String get profileLinkLabel => FirestoreService.currentFirebaseUser.uid ==
          FirestoreService.defaultCustomerAuthId
      ? msg.login()
      : msg.my_profile();

  final CartService cartService;
  final LanguageService languageService;
  final CountryService countryService;
  final WebshopMessagesService msg;  

  MenuModel<MenuItem> languageMenuModel;
}
