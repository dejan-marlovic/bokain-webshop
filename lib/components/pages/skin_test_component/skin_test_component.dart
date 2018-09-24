import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/angular/scroll_host/angular_2.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_consultation/bokain_consultation.dart';
import '../skin_type_list_component/skin_type_component/product_bundle_component/product_bundle_component.dart';
import '../skin_type_list_component/skin_type_component/severity_select_component/severity_select_component.dart';
import 'skin_test.dart';

@Component(
    selector: 'bo-skin-test',
    templateUrl: 'skin_test_component.html',
    styleUrls: const ['skin_test_component.css'],
    directives: const [
      formDirectives,
      FoIconComponent,
      FoImageMapComponent,
      ButtonCloudMultiSelectComponent,
      ButtonCloudSingleSelectComponent,
      MaterialFabComponent,
      MaterialIconComponent,
      MaterialStepperComponent,
      NgClass,
      NgFor,
      NgIf,
      ProductBundleComponent,
      SeveritySelectComponent,
      StepDirective
    ],
    providers: const [scrollHostProviders],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.Default)
class SkinTestComponent {
  SkinTestComponent(this.productService, this.faceZoneService,
      this.skinTypeService, this.languageService, this.msg)
      : genderOptions = {'female': msg.female(), 'male': msg.male()},
        problemTypes = {
          'pimples': new ProblemType()
            ..name = msg.symptom_pimples()
            ..skin_type_id = 'acne'
            ..rank = 3,
          'pustules': new ProblemType()
            ..name = msg.symptom_pustules()
            ..skin_type_id = 'acne'
            ..rank = 3,
          'papules': new ProblemType()
            ..name = msg.symptom_papules()
            ..skin_type_id = 'acne'
            ..rank = 3,
          'cysts': new ProblemType()
            ..name = msg.symptom_cysts()
            ..skin_type_id = 'acne'
            ..rank = 3,
          'open_comedones': new ProblemType()
            ..name = msg.symptom_open_comedones()
            ..skin_type_id = 'comedones'
            ..rank = 4,
          'closed_comedones': new ProblemType()
            ..name = msg.symptom_closed_comedones()
            ..skin_type_id = 'comedones'
            ..rank = 4,
          'dry_skin': new ProblemType()
            ..name = msg.symptom_dry_skin()
            ..skin_type_id = 'dry_skin'
            ..rank = 2,
          'oily_skin': new ProblemType()
            ..name = msg.symptom_oily_skin()
            ..skin_type_id = 'oily_skin'
            ..rank = 2,
          'rosacea': new ProblemType()
            ..name = msg.symptom_rosacea()
            ..skin_type_id = 'rosacea'
            ..rank = 5
        } {
    for (final zone in faceZoneService.imageMapZonesFrontFemale) {
      problemAreaOptions[zone.id] = zone.label;
    }
  }

  void toggleProblemType(String id) {
    if (model.problem_type_ids.contains(id)) {
      model.problem_type_ids.remove(id);
    } else {
      model.problem_type_ids.add(id);
    }
    model.problem_type_ids = new List.from(model.problem_type_ids);
  }

  void evaluateSkinType() {
    model.problem_type_ids
        .sort((p1, p2) => problemTypes[p2].rank - problemTypes[p1].rank);

    model.skin_type_id =
        problemTypes[model.problem_type_ids.first].skin_type_id;
  }

  void evaluateRecommendedProductBundle() {
    final bundles = productService.cachedModels.values.where((p) =>
        p.sub_product_ids.isNotEmpty &&
        p.skin_type_ids.isNotEmpty &&
        p.skin_type_ids.first == model.skin_type_id &&
        p.bundle_severity == model.severity);

    recSmall = bundles.firstWhere((p) => p.bundle_size == 'small', orElse: () => null);
    recLarge = bundles.firstWhere((p) => p.bundle_size == 'large', orElse: () => null);  
  }

  final ProductService productService;
  final FaceZoneService faceZoneService;
  final SkinTypeService skinTypeService;
  final LanguageService languageService;
  final WebshopMessagesService msg;

  Product recSmall;
  Product recLarge;

  SkinTest model = new SkinTest()..gender;
  final Map<String, String> genderOptions;
  final Map<String, String> problemAreaOptions = {};

  final Map<String, ProblemType> problemTypes;
}
