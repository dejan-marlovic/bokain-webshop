import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import '../../../directives/fade_directive.dart';
import '../../../services/meta_data_service.dart';
import 'article_category_component/article_category_component.dart';

@Component(
    selector: 'bo-skin-guide-category',
    templateUrl: 'skin_guide_category_component.html',
    styleUrls: const ['skin_guide_category_component.css'],
    directives: const [
      ArticleCategoryComponent,
      FadeDirective,
      MaterialButtonComponent,
      MaterialSpinnerComponent,
      NgClass,
      NgFor,
      NgIf,
      routerDirectives,
    ],
    providers: const [ArticleService, ArticleCategoryService],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class SkinGuideCategoryComponent implements OnActivate {
  SkinGuideCategoryComponent(
      this.articleService,
      this._articleCategoryService,
      this._metaDataService,
      this._changeDetector,
      this.languageService,
      this.msg);

  @override
  void onActivate(RouterState previous, RouterState current) async {
    final categoryId = current.parameters['category_url'];
    category = await _articleCategoryService.fetch(categoryId);

    _metaDataService
      ..description = category.meta_description
      ..keywords = category.meta_keywords;

    articleService.setPath('${articleService.path}/$categoryId/articles');
    await articleService.fetchQuery(articleService.collection);

    _changeDetector.markForCheck();
  }

  String articleLink(Article article) =>
      '${msg.skin_guide_url()}/${category.id}/${article.id}';

  final ArticleService articleService;
  final ArticleCategoryService _articleCategoryService;
  final LanguageService languageService;
  final MetaDataService _metaDataService;
  final ChangeDetectorRef _changeDetector;
  final WebshopMessagesService msg;

  Map<String, bool> imageLoadStatusRegistry = {};

  ArticleCategory category;
}
