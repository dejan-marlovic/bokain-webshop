import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
    selector: 'bo-login',
    templateUrl: 'login_component.html',
    styleUrls: const ['login_component.css'],
    directives: const [
      AutoFocusDirective,
      FoModalComponent,
      formDirectives,
      MaterialButtonComponent,
      materialInputDirectives,
      NgClass,
      NgIf
    ],
    providers: const <Object>[FORM_PROVIDERS],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.Default)
class LoginComponent {
  LoginComponent(this.customerService, this.consultationService,
      this.serviceService, this.msg) {
    loginSubtitle = msg.login_subtitle();
    resetPasswordSubtitle = msg.reset_password_instructions();
  }

  Future<void> onLogin() async {
    try {
      loginSubtitle = msg.please_wait();
      await customerService.login(email, password);
      final customer = await customerService.fetch(email);
      if (customer.consultation_id != null) {
        final consultation =
            await consultationService.fetch(customer.consultation_id);
        if (consultation.service_id != null) {
          await serviceService.fetch(consultation.service_id);
        }
      }
    } on UserAuthException {
      loginSubtitle = msg.invalid_password();
    }
  }

  Future<void> onResetPassword() async {
    resetPasswordSubtitle = msg.please_wait();
    try {
      await customerService.sendPasswordResetEmail(email);
      resetPasswordSubtitle =
          msg.we_have_sent_password_reset_instructions(email);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      resetPasswordSubtitle = msg.reset_password_email_not_found();
    }
  }

  String email = 'test@minoch.com';
  String password = 'lok13rum';
  String loginSubtitle;
  String resetPasswordSubtitle;
  String state = 'login';

  final CustomerService customerService;
  final ConsultationService consultationService;
  final ServiceService serviceService;
  final WebshopMessagesService msg;
  final ControlGroup loginForm = new ControlGroup({
    'email': new Control(
        '',
        Validators.compose([
          Validators.required,
          Validators.maxLength(128),
          FoValidators.email
        ])),
    'password': new Control(
        '', Validators.compose([Validators.required, Validators.maxLength(64)]))
  });
  final ControlGroup resetPasswordForm = new ControlGroup({
    'email': new Control(
        '',
        Validators.compose([
          Validators.required,
          Validators.maxLength(128),
          FoValidators.email
        ]))
  });
}
