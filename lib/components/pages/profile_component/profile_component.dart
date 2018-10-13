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
    providers: const [ConsultationService, ServiceService],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.Default)
class ProfileComponent implements OnInit {
  ProfileComponent(this.consultationService, this.customerService,
      this.productService, this.serviceService, this.msg);

  @override
  void ngOnInit() {
    if (loggedIn) {
      customerService.fetch(FirestoreService.currentUserId, force: false);
      consultationService.fetch(customer.consultation_id, force: false);
    }
  }

  void onLogout() async {
    await customerService.login(FirestoreService.defaultCustomerId,
        FirestoreService.defaultCustomerPassword);
  }

  String get currentUserId => FirestoreService.currentUserId;
  Customer get customer => customerService.get(currentUserId);

  Iterable<Product> get favoriteProducts =>
      customer.favorite_product_ids.map(productService.get);

  Service get recommendedService {
    final consultation = consultationService.get(customer.consultation_id);
    return (consultation == null)
        ? null
        : serviceService.get(consultation.service_id);
  }

  Consultation get consultation => consultationService.get(customer?.consultation_id);



  bool get loggedIn =>
      FirestoreService.currentFirebaseUser.uid != null &&
      FirestoreService.currentFirebaseUser.uid !=
          FirestoreService.defaultCustomerAuthId;

  final ConsultationService consultationService;
  final CustomerService customerService;
  final ProductService productService;
  final ServiceService serviceService;
  final WebshopMessagesService msg;
}
