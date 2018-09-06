import 'package:angular/angular.dart';
import 'side_nav_component/side_nav_component.dart';
import 'side_nav_component/side_nav_page_component.dart';

@Component(
  selector: 'bo-customer-support',
  templateUrl: 'customer_support_component.html',
  styleUrls: const ['customer_support_component.css'],
  directives: const [SideNavComponent, SideNavPageComponent]
)
class CustomerSupportComponent {

}