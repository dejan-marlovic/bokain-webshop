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
      FoModalComponent,
      formDirectives,
      FoSelectComponent,
      FoSocialNumberInputComponent,
      MaterialButtonComponent,
      MaterialCheckboxComponent,
      MaterialExpansionPanel,
      MaterialExpansionPanelSet,
      MaterialFabComponent,
      MaterialIconComponent,
      materialInputDirectives,
      MaterialSpinnerComponent
    ],
    providers: const [
      ConsultationService,
      CountryService,
      CustomerService,
      FORM_PROVIDERS,
      SettingsService,
    ],
    pipes: const [
      NamePipe
    ])
class SkinConsultationComponent {
  SkinConsultationComponent(
      CountryService countryService,
      this.consultationService,
      this.customerService,
      this.settingsService,
      this.msg)
      : genderOptions = {'male': msg.male(), 'female': msg.female()},
        form = new ControlGroup({
          'firstname': new Control(
              '',
              Validators.compose([
                Validators.required,
                FoValidators.alpha,
                Validators.maxLength(64)
              ])),
          'lastname': new Control(
              '',
              Validators.compose([
                Validators.required,
                FoValidators.alpha,
                Validators.maxLength(64)
              ])),
          'email': new Control(
              '',
              Validators.compose([
                Validators.required,
                FoValidators.email
              ])),
          'password': new Control(
              '',
              Validators.compose([
                Validators.required,
                Validators.minLength(6),
                Validators.maxLength(64)
              ])),
          'phone': new Control('', Validators.compose([])),
        }),
        countryCodeOptions = countryService.data.values
            .map((country) => new FoModel()..id = country.calling_code)
            .toList(growable: false) {
    errorTitle = msg.error_occured();
    _evaluatedLoginState();
  }

  Future<void> _evaluatedLoginState() async {
    loading = true;
    if (FirestoreService.currentFirebaseUser.uid !=
        FirestoreService.defaultCustomerAuthId) {
      // Customer is logged in
      customer = await customerService.fetch(FirestoreService.currentUserId);
      if (customer.consultation_id == null) {
        consultation = new Consultation();
      } else {
        consultation =
            await consultationService.fetch(customer.consultation_id);
        step = consultation.surveyCompleted ? 7 : 6;
      }
    } else {
      customer = new Customer()
        ..phone_country = '+46'
        ..sex = 'male'
        ..social_number = '198303247491'
        ..firstname = 'patrick'
        ..lastname = 'minogue'
        ..email = 'test@minoch.com';
      consultation = new Consultation()
        ..area_back = true
        ..customer_symptoms = ['dry']
        ..skin_tone_id = 'neither'
        ..current_skin_status = 'same_as_usual';
    }
    loading = false;
  }

  Future<String> _pickRandomWebConsultant() async {
    /// Pick a random web consultant for the user
    final settings = await settingsService.fetch('1');
    if (settings.web_consultant_ids.isNotEmpty) {
      final index = new Random(new DateTime.now().millisecondsSinceEpoch)
          .nextInt(settings.web_consultant_ids.length);
      return settings.web_consultant_ids[index];
    } else
      return null;
  }

  // Attempts to register a new account, or attempts to login using specified details if an account already exists.
  // Returns the customer id on success, null otherwise
  Future<String> _registerOrLogin() async {
    try {
      await customerService.register(customer, password);
      return await customerService.login(customer.email, password,
          requireEmailVerified: false);
    } on EmailAlreadyRegisteredException {
      // Customer exists already, attempt to login with specified details
      return await customerService.login(customer.email, password,
          requireEmailVerified: true);
    }
  }

  Future<void> onCreateConsultation() async {
    errorText = null;
    if (customer.id == null) {
      try {
        consultation.customer_id = await _registerOrLogin();
        customer = await customerService.fetch(consultation.customer_id);
        
        if (customer.consultation_id != null) {          
          consultation =
              await consultationService.fetch(customer.consultation_id);
          if (consultation != null) {
            // A consultation already exists for this customer
            step = consultation.surveyCompleted ? 7 : 6;
            throw new Exception(msg.error_customer_already_has_consultation());            
          }
        }
      } on InvalidPasswordException {
        errorText = msg.invalid_password();
        showResetPasswordButton = true;
        return;
      }
      // ignore: avoid_catches_without_on_clauses
      catch (e) {
        errorText = e.toString();
        return;
      }
    } else {
      consultation.customer_id = customer.id;
    }

    customer.user_id ??= await _pickRandomWebConsultant();
    consultation.user_id = customer.user_id;

    /// Upload images
    for (var index = 0; index < pictures.model.image_uris.length; index++) {
      if (pictures.model.image_uris[index].isNotEmpty) {
        consultation.image_uris[index] = await consultationService.uploadImage(
            '${customer.id}_$index', pictures.model.image_uris[index]);
      }
    }
    customer.consultation_id = await consultationService.push(consultation);
    await customerService.patch(customer.id, {
      'consultation_id': customer.consultation_id,
      'user_id': customer.user_id
    });

    step = 5;
  }

  Future<void> onResetPassword() async {
    await customerService.sendPasswordResetEmail(customer.email);
    errorText = msg.we_have_sent_password_reset_instructions(customer.email);
    errorTitle = msg.reset_password();
    showResetPasswordButton = false;
  }

  void onCallMeChange(bool event) {
    consultation.call_me = event;
    form = new ControlGroup({
      'firstname': new Control(
          customer.firstname,
          Validators.compose([
            Validators.required,
            FoValidators.alpha,
            Validators.maxLength(64)
          ])),
      'lastname': new Control(
          customer.lastname,
          Validators.compose([
            Validators.required,
            FoValidators.alpha,
            Validators.maxLength(64)
          ])),
      'email': new Control(
          customer.email,
          Validators.compose(
              [Validators.required, FoValidators.email])),
      'password': new Control(
          password,
          Validators.compose([
            Validators.required,
            Validators.minLength(6),
            Validators.maxLength(64)
          ])),
      'phone': consultation.call_me
          ? new Control(
              customer.phone,
              Validators.compose([
                Validators.required,
                FoValidators.phoneNumberWithoutCountryCode
              ]))
          : new Control('', Validators.compose([]))
    });
  }

  void onSurveyDone(bool event) {
    step++;
  }

  final List<FoModel> countryCodeOptions;

  ControlGroup form;

  final ConsultationService consultationService;
  final CustomerService customerService;
  final WebshopMessagesService msg;
  final SettingsService settingsService;
  final DateFormat ssn = new DateFormat("yyyyMMdd'0000'");
  Customer customer;
  Consultation consultation;
  bool termsAccepted = true;
  String errorText;
  String errorTitle;

  String password = '111111';
  bool showResetPasswordButton = false;
  bool loading;
  int step = 0;

  final Map<String, String> genderOptions;

  @ViewChild('pictures')
  ConsultationSectionPicturesComponent pictures;
}
