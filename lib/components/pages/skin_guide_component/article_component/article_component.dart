import 'package:angular/angular.dart';
import 'package:angular/security.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
    selector: 'bo-article',
    templateUrl: 'article_component.html',
    styleUrls: const ['article_component.css'],
    directives: const [NgIf, SafeInnerHtmlDirective],
    providers: const [ArticleService, ArticleContentService],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ArticleComponent implements OnActivate {
  ArticleComponent(
      this._articleService,
      this._articleContentService,
      this._sanitizer,
      this._changeDetector,
      this._router,
      this.languageService,
      this.msg);

  @override
  void onActivate(RouterState previous, RouterState current) async {
    model = null;
    final categoryId = current.parameters['category_url'];
    final articleId = current.parameters['article_url'];

    _articleService.setPath('${_articleService.path}/$categoryId/articles');
    model = await _articleService.fetch(articleId);

    _articleContentService.setPath(
        '${_articleContentService.path}/$categoryId/articles/$articleId/content');
    await _articleContentService.fetchQuery(_articleContentService.collection);

    try {
      content = _articleContentService.cachedModels.values.first;
      contentHtml = _sanitizer.bypassSecurityTrustHtml(content.value);
    } on StateError {
      await _router.navigate('404');
    }

    _changeDetector.markForCheck();
  }

  final ChangeDetectorRef _changeDetector;
  final DomSanitizationService _sanitizer;
  final ArticleService _articleService;
  final ArticleContentService _articleContentService;
  final Router _router;
  final LanguageService languageService;
  final WebshopMessagesService msg;

  Article model;
  ArticleContent content;

  SafeHtml contentHtml;
}
