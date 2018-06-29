import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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
class NavLargeComponent {
  NavLargeComponent(this.languageService, this.productCategoryService,
      this.skinTypeService, this.router, this.msg)
      : languageMenuModel = new MenuModel([
          new MenuItemGroup(languageService.data.values
              .map((lang) => new MenuItem(lang.name, action: () => _setLocale(lang.id)))
              .toList(growable: false))
        ], tooltipText: msg.language());
        
  static void _setLocale(String iso) async {    
    Intl.defaultLocale = iso;
    await initializeMessages(iso);
    await initializeDateFormatting(iso);
  }

  bool get skinTypesOpen =>
      router.current?.path?.startsWith(msg.skin_types_url()) == true;

  bool get productCategoriesOpen =>
      router.current?.path?.startsWith(msg.product_categories_url()) == true;

  final LanguageService languageService;
  final ProductCategoryService productCategoryService;
  final SkinTypeService skinTypeService;
  final MessagesService msg;
  final Router router;

  final MenuModel<MenuItem> languageMenuModel;
  String get locale => Intl.shortLocale(Intl.getCurrentLocale());
}
