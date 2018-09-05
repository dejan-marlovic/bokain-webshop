import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_consultation/bokain_consultation.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../login_component/login_component.dart';
import 'profile_details_component.dart';

@Component(
    selector: 'bo-profile',
    templateUrl: 'profile_component.html',
    styleUrls: const [
      'profile_component.css'
    ],
    directives: const [
      CustomerChatComponent,
      FoTabComponent,
      FoTabPanelComponent,
      LoginComponent,
      MaterialButtonComponent,      
      NgIf,
      ProfileDetailsComponent
    ],
    pipes: const [
      NamePipe
    ])
class ProfileComponent {
  ProfileComponent(this.customerService, this.msg);

  void onLogout() async {    
    await customerService.login(FirestoreService.defaultCustomerId, 'lok13rum');
  }

  String get currentUserId => FirestoreService.currentUserId;
  Customer get customer => customerService.get(currentUserId);

  bool get loggedIn =>
      FirestoreService.currentFirebaseUser.uid != null &&
      FirestoreService.currentFirebaseUser.uid !=
          FirestoreService.defaultCustomerAuthId;

  final CustomerService customerService;
  final WebshopMessagesService msg;
  
}
