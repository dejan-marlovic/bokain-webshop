import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular/security.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../quick_links_component/quick_links_component.dart';
import 'side_nav_component/side_nav_component.dart';
import 'side_nav_component/side_nav_page_component.dart';

@Component(
    selector: 'bo-customer-support',
    templateUrl: 'customer_support_component.html',
    styleUrls: const ['customer_support_component.css'],
    directives: const [
      QuickLinksComponent,
      SafeInnerHtmlDirective,
      SideNavComponent,
      SideNavPageComponent
    ],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class CustomerSupportComponent {
  CustomerSupportComponent(this.webshopContentService, this.languageService,
      this._sanitizer, this._changeDetector, this.msg) {
    _loadResources();
  }

  Future<void> _loadResources() async {
    await webshopContentService.fetch('1', force: false);
    
    if (phrases != null) {
      partners = _sanitizer.bypassSecurityTrustHtml(phrases.partners_html);
      standard_terms =
          _sanitizer.bypassSecurityTrustHtml(phrases.standard_terms_html);
      faq = _sanitizer.bypassSecurityTrustHtml(phrases.faq_html);
      about = _sanitizer.bypassSecurityTrustHtml(phrases.about_html);
    }

    _changeDetector.markForCheck();
  }

  WebshopContentPhrases get phrases => webshopContentService
      .get('1')
      .phrases[languageService.currentShortLocale];

  final LanguageService languageService;
  final WebshopMessagesService msg;
  final WebshopContentService webshopContentService;
  final ChangeDetectorRef _changeDetector;
  final DomSanitizationService _sanitizer;
  SafeHtml partners;
  SafeHtml standard_terms;
  SafeHtml faq;
  SafeHtml about;
}
