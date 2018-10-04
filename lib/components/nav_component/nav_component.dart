import 'package:angular/angular.dart';
import 'nav_large_component/nav_large_component.dart';
import 'nav_small_component/nav_small_component.dart';

@Component(
  selector: 'bo-nav',
  templateUrl: 'nav_component.html',
  directives: const [NavLargeComponent, NavSmallComponent, NgIf],
)
class NavComponent {

}