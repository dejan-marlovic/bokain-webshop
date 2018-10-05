import 'dart:async';
import 'dart:math';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:bokain_consultation/bokain_consultation.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
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
      MaterialButtonComponent,
      MaterialCheckboxComponent,
      MaterialDatepickerComponent,
      MaterialExpansionPanel,
      MaterialExpansionPanelSet,
      MaterialFabComponent,
      MaterialIconComponent,
      materialInputDirectives,
      MaterialSpinnerComponent
    ],
    providers: const <Object>[
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
  SkinConsultationComponent(this.consultationService, this.customerService,
      this.settingsService, this.msg)
      : genderOptions = {'male': msg.male(), 'female': msg.female()},
        form = new ControlGroup({
          'firstname': new Control<String>(
              '',
              Validators.compose([
                Validators.required,
                FoValidators.alpha,
                Validators.maxLength(64)
              ])),
          'lastname': new Control<String>(
              '',
              Validators.compose([
                Validators.required,
                FoValidators.alpha,
                Validators.maxLength(64)
              ])),
          'email': new Control<String>('',
              Validators.compose([Validators.required, FoValidators.email])),
          'password': new Control<String>(
              '',
              Validators.compose([
                Validators.required,
                Validators.minLength(6),
                Validators.maxLength(64)
              ])),
          'phone': new Control<String>('', Validators.compose([])),
        }),
        minDate = new Date(1900),
        maxDate = new Date.today().add(years: -10) {
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

  Future<void> onCreateConsultation() async {
    errorText = null;

    try {
      try {
        consultation.customer_id =
            await customerService.register(customer, password);
      } on EmailAlreadyRegisteredException {
        print('customer already registered, attempting to login');
      }

      consultation.customer_id = await customerService
          .login(customer.email, password, requireEmailVerified: false);

      customer = await customerService.fetch(consultation.customer_id);

      if (customer.consultation_id != null) {
        await customerService.login(FirestoreService.defaultCustomerId, FirestoreService.defaultCustomerPassword);
        consultation.customer_id = null;
        customer.consultation_id = null;
        throw new StateError(msg.error_customer_already_has_consultation());
      }

      customer.user_id ??= await _pickRandomWebConsultant();
      consultation.user_id = customer.user_id;

      /// Upload images
      for (var index = 0; index < pictures.model.image_uris.length; index++) {
        if (pictures.model.image_uris[index].isNotEmpty) {
          consultation.image_uris[index] =
              await consultationService.uploadImage(
                  '${customer.id}_$index', pictures.model.image_uris[index]);
        }
      }
      customer.consultation_id = await consultationService.push(consultation);
      await customerService.patch(customer.id.toString(), <String, String>{
        'consultation_id': customer.consultation_id,
        'user_id': customer.user_id
      });

      step = 5;
    } on UserAuthException {
      errorText = msg.invalid_password();
      showResetPasswordButton = true;
    } on StateError catch (e) {
      errorText = e.message;
    }
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
      'firstname': new Control<String>(
          customer.firstname,
          Validators.compose([
            Validators.required,
            FoValidators.alpha,
            Validators.maxLength(64)
          ])),
      'lastname': new Control<String>(
          customer.lastname,
          Validators.compose([
            Validators.required,
            FoValidators.alpha,
            Validators.maxLength(64)
          ])),
      'email': new Control<String>(customer.email,
          Validators.compose([Validators.required, FoValidators.email])),
      'password': new Control<String>(
          password,
          Validators.compose([
            Validators.required,
            Validators.minLength(6),
            Validators.maxLength(64)
          ])),
      'phone': consultation.call_me
          ? new Control<String>(customer.phone,
              Validators.compose([Validators.required, FoValidators.numeric]))
          : new Control<String>('', Validators.compose([]))
    });
  }

  void onSurveyDone(bool event) {
    step++;
  }

  Date get birthDate => _birthdate ??=
      (customer.social_number == null || customer.social_number.length < 8)
          ? null
          : new Date.fromTime(
              DateTime.parse(customer.social_number.substring(0, 8)));

  set birthDate(Date value) {
    customer.social_number = '${value.format(ssn)}';
  }

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

  final Date minDate;
  final Date maxDate;
  Date _birthdate;

  String password = '111111';
  bool showResetPasswordButton = false;
  bool loading;
  int step = 0;

  final Map<String, String> genderOptions;

  @ViewChild('pictures')
  ConsultationSectionPicturesComponent pictures;
}
