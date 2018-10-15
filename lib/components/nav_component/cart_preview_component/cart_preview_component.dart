import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../../services/cart_service.dart';

@Component(
  selector: 'bo-cart-preview',
  templateUrl: 'cart_preview_component.html',
  styleUrls: const ['cart_preview_component.css'],
  directives: const [MaterialButtonComponent, routerDirectives],
  pipes: const [NamePipe],
  changeDetection: ChangeDetectionStrategy.Default  
)
class CartPreviewComponent {
  CartPreviewComponent(this.cartService, this.languageService, this.msg);


  final CartService cartService;
  final LanguageService languageService;
  final WebshopMessagesService msg;
  

  @Input()
  bool visible;
  
}
