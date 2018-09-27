import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
    selector: 'bo-article-category',
    templateUrl: 'article_category_component.html',
    styleUrls: const ['article_category_component.css'],
    directives: const [MaterialSpinnerComponent, NgFor, NgIf, routerDirectives],
    pipes: const [NamePipe],
    providers: const [ArticleService],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ArticleCategoryComponent implements OnInit {
  ArticleCategoryComponent(this._changeDetectorRef, this.articleService,
      this.languageService, this.msg);

  @override
  void ngOnInit() async {
    await articleService.fetchQuery(
        articleService.collection.doc(model.id).collection('articles'));
    _loaded = true;


    _changeDetectorRef.markForCheck();    
  }

  String linkOf(Article article) => '${msg.skin_guide_url()}/${model.id}/${article.id}';

  bool get loaded => _loaded;

  @Input()
  ArticleCategory model;

  bool _loaded = false;

  final ChangeDetectorRef _changeDetectorRef;
  final ArticleService articleService;
  final LanguageService languageService;
  final WebshopMessagesService msg;
}
