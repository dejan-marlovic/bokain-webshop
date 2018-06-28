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
  FooterLargeComponent(this.msg) :
  terms = msg.standard_terms(),
  aboutUs = msg.about_us(),
  faq = msg.faq(),
  partners = msg.partner(2),
  myProfile = msg.my_profile(),
  customerSupport = msg.customer_support(),
  skinConsultation = msg.skin_consultation(1),
  skinGuide = msg.skin_guide(),
  skinTest = msg.skin_test(1),
  callMe = msg.call_me();

  final MessagesService msg;
  
  final String terms;
  final String aboutUs;
  final String faq;
  final String partners;
  final String myProfile;
  final String customerSupport;  
  final String skinConsultation;
  final String skinGuide;
  final String skinTest;
  final String callMe;
}
