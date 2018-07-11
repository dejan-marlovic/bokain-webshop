import 'package:angular/angular.dart';
import 'package:bokain_consultation/bokain_consultation.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../login_component/login_component.dart';

@Component(
    selector: 'bo-profile',
    templateUrl: 'profile_component.html',
    styleUrls: const [
      'profile_component.css'
    ],
    directives: const [      
      ChatComponent,
      FoTabComponent,
      FoTabPanelComponent,
      LoginComponent,
      NgIf
    ])
class ProfileComponent {
  ProfileComponent(this.msg);

  String get currentUserId => FirestoreService.currentUserId;

  bool get loggedIn =>
      FirestoreService.currentFirebaseUser.uid != null &&
      FirestoreService.currentFirebaseUser.uid !=
          FirestoreService.defaultCustomerId;

  
  final MessagesService msg;
}
