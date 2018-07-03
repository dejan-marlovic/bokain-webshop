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
    directives: const [FoModalComponent, formDirectives, materialDirectives],
    providers: const [FORM_PROVIDERS])
class LoginComponent {
  LoginComponent(this.customerService, this.msg);

  Future<void> onLogin() async {
    print(email);
    try {
      await customerService.login(email, password);
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  String email;
  String password;
  String errorMessage;

  final CustomerService customerService;
  final MessagesService msg;
}
