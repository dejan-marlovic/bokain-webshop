import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular/security.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:fo_model/fo_model.dart';
import '../../../services/config_service.dart';
import '../../quick_links_component/quick_links_component.dart';
import 'pacsoft_tracking_info_component/pacsoft_tracking_info_component.dart';
import 'side_nav_component/side_nav_component.dart';
import 'side_nav_component/side_nav_page_component.dart';

@Component(
    selector: 'bo-customer-support',
    templateUrl: 'customer_support_component.html',
    styleUrls: const ['customer_support_component.css'],
    directives: const [
      FoSelectComponent,
      formDirectives,
      MaterialButtonComponent,
      materialInputDirectives,
      NgIf,
      PacsoftTrackingInfoComponent,
      QuickLinksComponent,
      SafeInnerHtmlDirective,
      SideNavComponent,
      SideNavPageComponent
    ],
    providers: const [MailerService, PacsoftService],
    pipes: const [JsonPipe, NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class CustomerSupportComponent implements OnActivate {
  CustomerSupportComponent(
      this._configService,
      this.mailerService,
      this.pacsoftService,
      this.webshopContentService,
      this.languageService,
      this._sanitizer,
      this._changeDetector,
      this.msg) {
    _loadResources();
    languageService.localeChanges.listen((_) => _loadResources());
  }

  @override
  void onActivate(RouterState previous, RouterState current) {
    currentPage = current.path.replaceAll('/', '');        
  }

  Future<void> sendEmail() async {
    final subject = 'Nytt ärende webshop';
    await mailerService.mail(
        ticket.emailBody, subject, _configService.supportEmail);
    ticket = null;
    _changeDetector.markForCheck();
  }

  Future<void> fetchParcelInfo() async {
    parcelInfo = await pacsoftService.fetchParcelInfo(parcelNo);
    _changeDetector.markForCheck();
  }

  Future<void> _loadResources() async {
    loaded = false;
    await webshopContentService.fetch('1', force: false);

    if (phrases != null) {
      partners = _sanitizer.bypassSecurityTrustHtml(phrases.partners_html);
      standard_terms =
          _sanitizer.bypassSecurityTrustHtml(phrases.standard_terms_html);
      faq = _sanitizer.bypassSecurityTrustHtml(phrases.faq_html);
      about = _sanitizer.bypassSecurityTrustHtml(phrases.about_html);

      supportCategories = [
        new FoModel()..id = msg.support_ask_user(),
        new FoModel()..id = msg.support_order_status(),
        new FoModel()..id = msg.support_delivery(),
        new FoModel()..id = msg.support_login_issues(),
        new FoModel()..id = msg.support_payment_issues(),
        new FoModel()..id = msg.support_product_information(),
        new FoModel()..id = msg.support_other()
      ];
    }
    loaded = true;
    _changeDetector.markForCheck();
  }

  WebshopContentPhrases get phrases => webshopContentService
      .get('1')
      .phrases[languageService.currentShortLocale];

  final ConfigService _configService;
  final LanguageService languageService;
  final MailerService mailerService;
  final PacsoftService pacsoftService;
  final WebshopContentService webshopContentService;
  final ChangeDetectorRef _changeDetector;
  final DomSanitizationService _sanitizer;
  final WebshopMessagesService msg;
  List<FoModel> supportCategories;

  String parcelNo = '';
  String currentPage;
  SafeHtml partners;
  SafeHtml standard_terms;
  SafeHtml faq;
  SafeHtml about;
  bool loaded;
  Ticket ticket = new Ticket();

  PacsoftTrackingInformationResponse parcelInfo;

  ControlGroup form = new ControlGroup({
    'name': new Control('',
        Validators.compose([Validators.required, Validators.maxLength(128)])),
    'email': new Control(
        '',
        Validators.compose([
          Validators.required,
          Validators.maxLength(128),
          FoValidators.email
        ])),
    'order_no': new Control(
        '',
        Validators.compose([
          FoValidators.alphaNumeric,
          FoValidators.noWhiteSpace,
          Validators.maxLength(32)
        ])),
    'message': new Control('',
        Validators.compose([Validators.required, Validators.maxLength(5000)]))
  });
}

class Ticket {
  String category;
  String name;
  String email;
  String order_no;
  String message;

  String get emailBody => '''
    <h1>Supportärende</h1>
    <table>
      <tr>
        <td>Kategori:</td>
        <td>$category</td>      
      </tr>
      <tr>
        <td>Namn:</td>
        <td>$name</td>
      </tr>
      <tr>
        <td>E-post:</td>
        <td>$email</td>        
      </tr>
      <tr>
        <td>Ordernummer:</td>
        <td>$order_no</td>
      </tr>
    </table>
    <h2 style="margin-bottom:none;">Meddelande:</h2>
    <pre>$message</pre>
    ''';
}
