import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_consultation/bokain_consultation.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

import '../../product_list_component/product_list_component.dart';
import '../login_component/login_component.dart';
import 'profile_details_component.dart';

@Component(
    selector: 'bo-profile',
    templateUrl: 'profile_component.html',
    styleUrls: const ['profile_component.css'],
    directives: const [
      CustomerChatComponent,
      FoTabComponent,
      FoTabPanelComponent,
      LoginComponent,
      MaterialButtonComponent,
      NgIf,
      ProductListComponent,
      ProfileDetailsComponent
    ],
    providers: const [
      ConsultationService,
      SalonService,
      ServiceService,
      UserService,
      UserLogService
    ],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.Default)
class ProfileComponent extends OnInit {
  Customer get customer => customerService.get(currentUserId);
  Consultation get consultation => customer?.consultation_id == null
      ? null
      : consultationService.get(customer.consultation_id);

  final ConsultationService consultationService;
  final CustomerService customerService;
  final ProductService productService;
  final SalonService salonService;
  final UserService userService;
  final ServiceService serviceService;
  final WebshopMessagesService msg;

  ProfileComponent(
      this.consultationService,
      this.customerService,
      this.productService,
      this.salonService,
      this.serviceService,
      this.userService,
      this.msg);

  String get currentUserId => FirestoreService.currentUserId;

/*
  Iterable<Product> get favoriteProducts =>
      consultation.product_ids.map(productService.get);
*/

  List<Product> recommendedProducts = [];

  bool get loggedIn =>
      FirestoreService.currentFirebaseUser.uid != null &&
      FirestoreService.currentFirebaseUser.uid !=
          FirestoreService.defaultCustomerAuthId;

  Salon get recommendedSalon => consultation?.salon_id == null
      ? null
      : salonService.get(consultation.salon_id);

  Service get recommendedService => consultation?.service_id == null
      ? null
      : serviceService.get(consultation.service_id);

  User get recommendedUser => consultation?.user_id == null
      ? null
      : userService.get(consultation.user_id);

  Future<void> onLogout() async {
    await customerService.login(FirestoreService.defaultCustomerId,
        FirestoreService.defaultCustomerPassword);
  }

  bool showLogin = true;

  @override
  void ngOnInit() {
    showLogin = !loggedIn;
    fetchCustomerData();
  }

  void onLogin(String id) {
    showLogin = false;
    fetchCustomerData();
  }

  Future<void> fetchCustomerData() async {
    if (loggedIn) {
      await customerService.fetch(FirestoreService.currentUserId, force: false);
      if (customer?.consultation_id != null) {
        await consultationService.fetch(customer.consultation_id, force: false);
        if (consultation != null) {
          await serviceService.fetch(consultation.service_id, force: false);
          await salonService.fetch(consultation.salon_id, force: false);
          await userService.fetch(consultation.user_id);
        }
      }
    }
  }
}
