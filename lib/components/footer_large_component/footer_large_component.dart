import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import '../icon_component/icon_component.dart';

@Component(
  selector: 'bo-footer-large',
  styleUrls: const ['footer_large_component.css'],
  templateUrl: 'footer_large_component.html',
  directives: const [IconComponent, routerDirectives],
)
class FooterLargeComponent {
  FooterLargeComponent(this.msg);


  final String iconSize = '3rem';
  final WebshopMessagesService msg;
}
