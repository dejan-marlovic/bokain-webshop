import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../services/cart_service.dart';

@Component(
  selector: 'bo-nav-large',
  styleUrls: const ['nav_large_component.css'],
  templateUrl: 'nav_large_component.html',
  directives: const [
    MaterialMenuComponent,
    MaterialInputComponent,
    NgFor,
    NgIf,
    routerDirectives
  ],
)
class NavLargeComponent implements OnDestroy {
  NavLargeComponent(
      this.languageService,
      this.cartService,
      this.productCategoryService,
      this.skinTypeService,
      this.router,
      this.msg) {
    languageMenuModel = new MenuModel([
      new MenuItemGroup(languageService.data.values
          .map((lang) =>
              new MenuItem(lang.name, action: () => _setLocale(lang.id)))
          .toList(growable: false))
    ]);
  }

  @override
  void ngOnDestroy() {
    _localeChangeController.close();
  }

  void _setLocale(String iso) async {
    Intl.defaultLocale = iso;
    await initializeMessages(iso);
    await initializeDateFormatting(iso);
    languageService.reset();
    languageMenuModel = new MenuModel([
      new MenuItemGroup(languageService.data.values
          .map((lang) =>
              new MenuItem(lang.name, action: () => _setLocale(lang.id)))
          .toList(growable: false))
    ], tooltipText: msg.language());

    skinTypeService.reset();
    _localeChangeController.add(iso);
  }

  bool get skinTypesOpen =>
      router.current?.path?.startsWith(msg.skin_types_url()) == true;

  bool get productCategoriesOpen =>
      router.current?.path?.startsWith(msg.product_categories_url()) == true;

  String get locale => Intl.shortLocale(Intl.getCurrentLocale());

  final CartService cartService;
  final LanguageService languageService;
  final ProductCategoryService productCategoryService;
  final SkinTypeService skinTypeService;
  final MessagesService msg;
  final Router router;

  final StreamController<String> _localeChangeController =
      new StreamController();

  MenuModel<MenuItem> languageMenuModel;

  @Output('localeChange')
  Stream<String> get onLocaleChange => _localeChangeController.stream;
}
