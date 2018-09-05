import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:fo_model/fo_model.dart';

@Component(
    selector: 'bo-profile-details',
    templateUrl: 'profile_details_component.html',
    styleUrls: const ['profile_details_component.css'],
    directives: const [
      FoSelectComponent,
      formDirectives,
      materialInputDirectives,
      MaterialSpinnerComponent,
      NgIf
    ],
    providers: const [],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ProfileDetailsComponent {
  ProfileDetailsComponent(this.countryService, this.customerService, this.msg)
      : countryCodeOptions = countryService.data.values
            .map((country) => new FoModel()..id = country.calling_code)
            .toList(growable: false);

  Future<void> patch(String property, String value) async {
    await customerService.patch(customer.id, <String, String>{property: value});
  }

  final CountryService countryService;
  final CustomerService customerService;
  final WebshopMessagesService msg;

  final List<FoModel> countryCodeOptions;

  @Input()
  Customer customer;
}
