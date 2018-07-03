import 'package:angular/angular.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
    selector: 'bo-profile',
    templateUrl: 'profile_component.html',
    styleUrls: const ['profile_component.css'],
    directives: const [FoTabComponent, FoTabPanelComponent, NgIf])
class ProfileComponent {
  ProfileComponent(this.msg);

  bool loggedIn = true;

  final MessagesService msg;
}
