import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:intl/intl.dart';
@Component(
  selector: 'bo-nav-large',
  styleUrls: const ['nav_large_component.css'],
  templateUrl: 'nav_large_component.html',
  directives: const [MaterialInputComponent, NgFor, NgIf, routerDirectives],
)
class NavLargeComponent {
  NavLargeComponent(this.productCategoryService,
      this.skinTypeService, this.router, this.msg)
      : cart = msg.cart(),
        customerSupport = msg.customer_support(),
        filterBySkinType = msg.filter_by_skin_type(),
        filterByProductCategory = msg.filter_by_product_category(),
        skinConsultation = msg.skin_consultation(1),
        skinGuide = msg.skin_guide(),
        login = msg.login(),
        language = msg.language();

  bool get skinTypesOpen =>
      router.current?.path?.startsWith(msg.skin_types_url()) == true;

  bool get productCategoriesOpen =>
      router.current?.path?.startsWith(msg.product_categories_url()) == true;

  final ProductCategoryService productCategoryService;
  final SkinTypeService skinTypeService;
  final MessagesService msg;
  final Router router;

  final String locale = Intl.shortLocale(Intl.getCurrentLocale());

  final String cart;
  final String customerSupport;
  final String filterBySkinType;
  final String filterByProductCategory;
  final String skinConsultation;
  final String skinGuide;
  final String login;
  final String language;
}
