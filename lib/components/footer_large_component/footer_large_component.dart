import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:intl/intl.dart';
import '../../services/menu_selection_service.dart';

@Component(
  selector: 'bo-footer-large',
  styleUrls: const ['footer_large_component.css'],
  templateUrl: 'footer_large_component.html',
  directives: const [MaterialInputComponent, NgFor, NgIf, routerDirectives],
)
class FooterLargeComponent {
  FooterLargeComponent(this.menuSelection, this._router);

  void onMenuSelection(String value, [String route]) {
    menuSelection.selection = value;
    
    if (route != null) _router.navigate(route);
  }
  
  final MenuSelectionService menuSelection;
  final Router _router;
  
  final String terms = Intl.message('terms', name: 'terms');
  final String aboutUs = Intl.message('about us', name: 'about us');
  final String faq = Intl.message('frequently asked questions', name: 'faq');
  final String partners = Intl.plural(2, one: 'partner', other: 'partners', name: 'partner');
  final String myProfile = Intl.message('my profile', name: 'my profile');
  final String customerSupport =
      Intl.message('customer support', name: 'customer support');  
  final String skinConsultation =
      Intl.message('skin consultation', name: 'skin consultation');
  final String skinGuide = Intl.message('skin guide', name: 'skin guide');
  final String skinTest = Intl.message('skin test', name: 'skin test');
  final String callMe = Intl.message('call me', name: 'call me');
}
