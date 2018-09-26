import 'package:angular/angular.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'article_category_component/article_category_component.dart';

@Component(
    selector: 'bo-skin-guide',
    templateUrl: 'skin_guide_component.html',
    styleUrls: const ['skin_guide_component.css'],
    directives: const [ArticleCategoryComponent, NgFor, NgIf],
    providers: const [ArticleCategoryService],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class SkinGuideComponent {
  SkinGuideComponent(
      this._changeDetectorRef, this.articleCategoryService, this.msg) {
    _loadResources();
  }

  void _loadResources() async {
    await articleCategoryService.fetchQuery(articleCategoryService.collection);
    _loaded = true;
    _changeDetectorRef.markForCheck();
  }

  bool get loaded => _loaded;
  bool _loaded = false;
  final ChangeDetectorRef _changeDetectorRef;
  final ArticleCategoryService articleCategoryService;
  final WebshopMessagesService msg;
}
