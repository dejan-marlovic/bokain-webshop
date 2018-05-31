import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:bokain_consultation/bokain_consultation.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:fo_model/fo_model.dart';

@Component(
    selector: 'skin-consultation-component',
    templateUrl: 'skin_consultation_component.html',
    styleUrls: const [
      'skin_consultation_component.css'
    ],
    directives: const [
      ButtonCloudSingleSelectComponent,
      ConsultationSectionPicturesComponent,
      ConsultationSectionProblemAreasComponent,
      ConsultationSectionSymptomsComponent,
      coreDirectives,
      formDirectives,
      FoSelectComponent,
      materialDirectives,
    ],
    providers: const [
      ConsultationService,
      CountryService,
      CustomerService,
      FORM_PROVIDERS,
    ],
    pipes: const [
      PhrasePipe
    ])
class SkinConsultationComponent {
  SkinConsultationComponent(CountryService countryService)
      : countryCodeOptions = countryService.data.values
            .map((country) => new FoModel()..id = country.calling_code)
            .toList(growable: false);

  Future onCreateCustomer() async {
    customer.id = 'hej';
    step = 1;
  }

  void onCallMeChange(bool event) {
    consultation.call_me = event;
    form = new ControlGroup({
      'email': new Control(customer.email,
          Validators.compose([FoValidators.required('enter_an_email'), FoValidators.email])),
      'phone': consultation.call_me
          ? new Control(
              customer.phone,
              Validators.compose([
                FoValidators.required('enter_a_phone'),
                FoValidators.phoneNumberWithoutCountryCode
              ]))
          : new Control('', Validators.compose([]))
    });
  }

  Date get birthdate =>
      customer.birthdate == null ? null : Date.fromTime(customer.birthdate);

  set birthdate(Date date) {
    customer.birthdate =
        date == null ? null : new DateTime(date.year, date.month, date.day);
  }

  int get year => customer.birthdate?.year;
  int get month => customer.birthdate?.month;
  int get day => customer.birthdate?.day;

  set year(int value) {
    if (customer.birthdate == null) {
      customer.birthdate = new DateTime(value);
    } else {
      customer.birthdate =
          new DateTime(value, customer.birthdate.month, customer.birthdate.day);
    }
  }

  set month(int value) {
    if (customer.birthdate == null) {
      customer.birthdate =
          new DateTime(new Date.today().add(years: -20).year, value, 1);
    } else {
      customer.birthdate =
          new DateTime(customer.birthdate.year, value, customer.birthdate.day);
    }
  }

  set day(int value) {
    if (customer.birthdate == null) {
      customer.birthdate =
          new DateTime(new Date.today().add(years: -20).year, 1, value);
    } else {
      customer.birthdate = new DateTime(
          customer.birthdate.year, customer.birthdate.month, value);
    }
  }

  final List<FoModel> yearOptions = new List.generate(
      100, (i) => new FoModel()..id = new Date.today().add(years: -i).year);
  final List<FoModel> monthOptions =
      new List.generate(12, (i) => new FoModel()..id = i + 1);
  final List<FoModel> dayOptions =
      new List.generate(32, (i) => new FoModel()..id = i + 1);

  final List<FoModel> countryCodeOptions;

  ControlGroup form = new ControlGroup({
    'email': new Control(
        '', Validators.compose([FoValidators.required('enter_an_email'), FoValidators.email])),
    'phone': new Control('', Validators.compose([]))
  });

  Customer customer = new Customer()..phone_country = '+46';
  Consultation consultation = new Consultation();
  bool termsAccepted = false;
  int step = 0;
}