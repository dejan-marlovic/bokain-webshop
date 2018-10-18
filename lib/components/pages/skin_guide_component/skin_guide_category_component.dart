import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'article_category_component/article_category_component.dart';

@Component(
    selector: 'bo-skin-guide-category',
    templateUrl: 'skin_guide_category_component.html',
    styleUrls: const ['skin_guide_category_component.css'],
    directives: const [ArticleCategoryComponent, MaterialSpinnerComponent, NgIf],
    providers: const [ArticleCategoryService],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class SkinGuideCategoryComponent implements OnActivate {
  SkinGuideCategoryComponent(
      this._articleCategoryService,            
      this._changeDetector,      
      this.languageService,
      this.msg);

  @override
  void onActivate(RouterState previous, RouterState current) async {    
    final categoryId = current.parameters['category_url'];
    category = await _articleCategoryService.fetch(categoryId);
    _changeDetector.markForCheck();
  }

  final ChangeDetectorRef _changeDetector;  
  final ArticleCategoryService _articleCategoryService;    
  final LanguageService languageService;
  final WebshopMessagesService msg;

  ArticleCategory category;
}
