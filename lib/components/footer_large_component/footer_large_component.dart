import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
  selector: 'bo-footer-large',
  styleUrls: const ['footer_large_component.css'],
  templateUrl: 'footer_large_component.html',
  directives: const [routerDirectives, FoIconComponent],
  pipes: const [NamePipe]
)
class FooterLargeComponent {
  FooterLargeComponent(this.msg);


  final String iconSize = '3rem';
  final WebshopMessagesService msg;
}
