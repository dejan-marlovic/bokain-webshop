import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

import '../../directives/router_link_sub_active_directive.dart';
import '../../services/cart_service.dart';
import '../search_component/search_component.dart';
import 'cart_preview_component/cart_preview_component.dart';

@Component(
    selector: 'bo-nav',
    templateUrl: 'nav_component.html',
    styleUrls: const [
      'nav_component.css'
    ],
    directives: const [
      CartPreviewComponent,
      DropdownMenuComponent,
      FoIconComponent,
      MaterialIconComponent,
      MaterialPopupComponent,
      MaterialListComponent,
      MaterialListItemComponent,
      MaterialTemporaryDrawerComponent,
      NgFor,
      PopupSourceDirective,
      RouterLinkSubActive,
      SearchComponent,
      routerDirectives
    ],
    pipes: const [
      NamePipe
    ])
class NavComponent implements OnDestroy {
  final CartService cartService;
  final LanguageService languageService;
  final ProductCategoryService productCategoryService;
  final CountryService countryService;
  final Router _router;
  final WebshopMessagesService msg;
  MenuModel<MenuItem> languageMenuModel;
  StreamSubscription<String> _navigationListener;
  bool slideOpen = false;
  final String iconSize = '1.2rem';

  NavComponent(this.cartService, this.languageService, this.countryService,
      this.productCategoryService, this._router, this.msg) {
    _navigationListener =
        _router.onNavigationStart.listen((_) => slideOpen = false);
    _setupModels();
  }

  List<RelativePosition> get position => RelativePosition.AdjacentLeftEdge;

  String get profileLinkLabel => FirestoreService.currentFirebaseUser.uid ==
          FirestoreService.defaultCustomerAuthId
      ? msg.login()
      : msg.my_profile();

  @override
  void ngOnDestroy() {
    _navigationListener.cancel();
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
}
