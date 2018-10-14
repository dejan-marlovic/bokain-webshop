import 'dart:html' as dom;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular/security.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../../services/cart_service.dart';
import 'cart_item_component.dart';

@Component(
    selector: 'bo-cart',
    templateUrl: 'cart_component.html',
    styleUrls: const ['cart_component.css'],
    directives: const [
      CartItemComponent,
      formDirectives,
      MaterialButtonComponent,
      MaterialSpinnerComponent,
      MaterialIconComponent,
      materialInputDirectives,
      NgIf,
      NgFor,
      SafeInnerHtmlDirective
    ],    
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.Default)
class CartComponent implements OnActivate {
  CartComponent(      
      this.customerService,
      this.cartService,
      this.languageService,
      this.productService,
      this.settingsService,
      this.changeDetectorRef,
      this.msg);

  @override
  void onActivate(RouterState previous, RouterState current) {
    dom.window.scrollTo(0,0);
  }

  //SafeResourceUrl klarnaHtml;
  String discountCode;
  
  final CartService cartService;
  final CustomerService customerService;
  final LanguageService languageService;
  final ProductService productService;
  final SettingsService settingsService;
  final ChangeDetectorRef changeDetectorRef;
  final WebshopMessagesService msg;
}
