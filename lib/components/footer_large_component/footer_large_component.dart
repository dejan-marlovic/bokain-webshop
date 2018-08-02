import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';

@Component(
  selector: 'bo-footer-large',
  styleUrls: const ['footer_large_component.css'],
  templateUrl: 'footer_large_component.html',
  directives: const [MaterialInputComponent, NgFor, NgIf, routerDirectives],
)
class FooterLargeComponent {
  FooterLargeComponent(this.msg);


  final WebshopMessagesService msg;  

}
