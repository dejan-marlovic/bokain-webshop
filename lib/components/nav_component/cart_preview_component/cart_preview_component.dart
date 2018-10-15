import 'package:angular/angular.dart';
import 'package:fo_components/fo_components.dart';
import '../../../services/cart_service.dart';

@Component(
  selector: 'bo-cart-preview',
  templateUrl: 'cart_preview_component.html',
  styleUrls: const ['cart_preview_component.css'],
  directives: const [],
  pipes: const [NamePipe],
  changeDetection: ChangeDetectionStrategy.Default  
)
class CartPreviewComponent {
  CartPreviewComponent(this.cartService) {
    
  }


  final CartService cartService;
  
}
