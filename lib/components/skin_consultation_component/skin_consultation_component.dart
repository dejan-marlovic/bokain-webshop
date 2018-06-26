import 'dart:async';
import 'dart:math';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:bokain_consultation/bokain_consultation.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:fo_model/fo_model.dart';
import 'package:intl/intl.dart' show DateFormat;

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
      ConsultationSurveyComponent,
      coreDirectives,
      formDirectives,
      FoModalComponent,      
      FoSelectComponent,
      materialDirectives,
    ],
    providers: const [
      ConsultationService,
      CountryService,
      CustomerService,
      FORM_PROVIDERS,
      SettingsService,
    ],
    pipes: const [])
class SkinConsultationComponent {
  SkinConsultationComponent(CountryService countryService,
      this.consultationService, this.customerService, this.settingsService, this.msg) : genderOptions = {
        'male': msg.male(),
        'female': msg.female()
      },
      form = new ControlGroup({
    'firstname': new Control(
        '',
        Validators.compose([
          FoValidators.required(msg.enter_firstname()),
          FoValidators.alpha,
          Validators.maxLength(64)
        ])),
    'lastname': new Control(
        '',
        Validators.compose([
          FoValidators.required(msg.enter_lastname()),
          FoValidators.alpha,
          Validators.maxLength(64)
        ])),
    'email': new Control(
        '',
        Validators.compose(
            [FoValidators.required(msg.enter_email()), FoValidators.email])),
    'phone': new Control('', Validators.compose([]))
  }),
      countryCodeOptions = countryService.data.values
            .map((country) => new FoModel()..id = country.calling_code)
            .toList(growable: false);

  Future onCreateConsultation() async {
    if (customer.id == null) {
      customer.id =
          consultation.customer_id = await customerService.push(customer);
    } else {
      consultation.customer_id = customer.id;
      await customerService.set(customer);
    }   

    /// Upload images
    for (var index = 0; index < pictures.model.image_uris.length; index++) {
      if (pictures.model.image_uris[index].isNotEmpty) {        
        consultation.image_uris[index] = await consultationService.uploadImage(
            '${customer.id}_$index', pictures.model.image_uris[index]);
      }
    }
    customer.consultation_id = await consultationService.push(consultation);
      await customerService
          .patch(customer.id, {'consultation_id': customer.consultation_id});
          
    step = 5;
  }

  Future onCreateCustomer() async {
    final settings = await settingsService.fetch('1');

    /// Pick a random web consultant for the user
    if (settings.web_consultant_ids.isNotEmpty) {
      final index = new Random(new DateTime.now().millisecondsSinceEpoch)
          .nextInt(settings.web_consultant_ids.length - 1);
      customer.user_id = settings.web_consultant_ids[index];
    }
    customer.social_number ??= ssn.format(customer.birthdate);
    step = 1;
  }

  Future onEmailBlur() async {
    customer
      ..consultation_id = null
      ..firstname = null
      ..lastname = null
      ..phone = null;

    final customers = await customerService.fetchQuery(
        customerService.collection.where('email', '==', customer.email));
    if (customers.isNotEmpty) {
      customer = customers.first;
      if (customer.consultation_id != null) {
        errorModalVisible = true;
      }
    }
  }

  void onCallMeChange(bool event) {
    consultation.call_me = event;
    form = new ControlGroup({
      'firstname': new Control(
          customer.firstname,
          Validators.compose([
            FoValidators.required(msg.enter_firstname()),
            FoValidators.alpha,
            Validators.maxLength(64)
          ])),
      'lastname': new Control(
          customer.lastname,
          Validators.compose([
            FoValidators.required(msg.enter_lastname()),
            FoValidators.alpha,
            Validators.maxLength(64)
          ])),
      'email': new Control(
          customer.email,
          Validators.compose(
              [FoValidators.required(msg.enter_email()), FoValidators.email])),
      'phone': consultation.call_me
          ? new Control(
              customer.phone,
              Validators.compose([
                FoValidators.required(msg.enter_phone()),
                FoValidators.phoneNumberWithoutCountryCode
              ]))
          : new Control('', Validators.compose([]))
    });
  }

  void onSurveyDone(bool event) {
    step++;
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
      new List.generate(12, (i) => new SimpleModel()..id = i + 1..label = (i < 9) ? '0${i+1}' : '${i+1}');
  final List<FoModel> dayOptions =
      new List.generate(32, (i) => new SimpleModel()..id = i + 1..label = (i < 9) ? '0${i+1}' : '${i+1}');

  final List<FoModel> countryCodeOptions;

  ControlGroup form;

  final ConsultationService consultationService;
  final CustomerService customerService;
  final MessagesService msg;
  final SettingsService settingsService;
  final DateFormat ssn = new DateFormat("yyyyMMdd'0000'");
  Customer customer = new Customer()..phone_country = '+46';
  Consultation consultation = new Consultation();
  bool termsAccepted = false;
  bool errorModalVisible = false;  
  int step = 0;

  final Map<String, String> genderOptions;

  @ViewChild('pictures')
  ConsultationSectionPicturesComponent pictures;
}
