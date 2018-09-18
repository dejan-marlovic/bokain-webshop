import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../../services/cart_service.dart';
import '../../search_component/search_component.dart';

@Component(
    selector: 'bo-nav-small',
    templateUrl: 'nav_small_component.html',
    styleUrls: const [
      'nav_small_component.css'
    ],
    directives: const [
      FoIconComponent,
      DropdownMenuComponent,
      MaterialIconComponent,
      MaterialListComponent,
      MaterialListItemComponent,
      MaterialTemporaryDrawerComponent,
      NgFor,
      routerDirectives,
      SearchComponent
    ],
    pipes: const [
      NamePipe
    ])
class NavSmallComponent implements OnDestroy {
  NavSmallComponent(this.cartService, this._countryService, this.languageService,
      this.productCategoryService, this._router, this.msg) {
    _navigationListener =
        _router.onNavigationStart.listen((_) => slideOpen = false);

    _setupModels();
  }

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
      new MenuItemGroup(_countryService.data.values
          .map((country) => new MenuItem<String>(country.name,
              action: () => _setLocale(country.language)))
          .toList(growable: false))
    ], tooltipText: msg.language());
  }

  String get profileLinkLabel => FirestoreService.currentFirebaseUser.uid ==
          FirestoreService.defaultCustomerAuthId
      ? msg.login()
      : msg.my_profile();

  bool slideOpen = false;
  final String iconSize = '1.2rem';
  StreamSubscription<String> _navigationListener;
  MenuModel<MenuItem> languageMenuModel;
  final CartService cartService;
  final CountryService _countryService;
  final LanguageService languageService;
  final ProductCategoryService productCategoryService;
  final Router _router;
  final WebshopMessagesService msg;
}
