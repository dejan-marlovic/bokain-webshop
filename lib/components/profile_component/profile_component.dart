import 'package:angular/angular.dart';

@Component(
  selector: 'bo-profile',
  templateUrl: 'profile_component.html',
  styleUrls: const ['profile_component.css'],
  directives: const [NgIf]
)
class ProfileComponent {


  bool loggedIn = true;
}