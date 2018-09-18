import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../services/config_service.dart';

@Component(
    selector: 'bo-footer',
    styleUrls: const ['footer_component.css'],
    templateUrl: 'footer_component.html',
    directives: const [
      formDirectives,
      routerDirectives,
      MaterialButtonComponent,
      MaterialPopupComponent,
      materialInputDirectives,
      NgIf,
      PopupSourceDirective,
      FoIconComponent
    ],
    providers: const [MailerService],
    pipes: const [NamePipe])
class FooterLargeComponent {
  FooterLargeComponent(this._configService, this.mailerService, this.msg);

  Future<void> sendCallMeRequest() async {
    await mailerService.mail(
        'En kund på dahlskincare.com vill bli uppgringd, telefon: $phone', 'Kund vill bli uppringd', _configService.supportEmail);
    phone = null;
    await new Future.delayed(const Duration(seconds: 2));
    phonePopupVisible = false;
  }

  List<RelativePosition> get position => RelativePosition.AdjacentCardinal;

  final ControlGroup form = new ControlGroup({
    'phone': new Control(
        '',
        Validators.compose([
          Validators.required,
          Validators.minLength(6),
          Validators.maxLength(32),
        ]))
  });

  final String iconSize = '3rem';
  final ConfigService _configService;
  final MailerService mailerService;
  final WebshopMessagesService msg;
  bool phonePopupVisible = false;
  String phone = '';
}
