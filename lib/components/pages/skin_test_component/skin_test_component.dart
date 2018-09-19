import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/model/action/async_action.dart';
import 'package:angular_components/utils/angular/scroll_host/angular_2.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_consultation/bokain_consultation.dart';
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
      MaterialStepperComponent,
      NgIf,
      StepDirective
    ],
    providers: const [scrollHostProviders],
    pipes: const [NamePipe],
    changeDetection: ChangeDetectionStrategy.Default)
class SkinTestComponent {
  SkinTestComponent(this.faceZoneService, this.msg)
      : genderOptions = {'female': msg.female(), 'male': msg.male()} {
    for (final zone in faceZoneService.imageMapZonesFrontFemale) {
      problemAreaOptions[zone.id] = zone.label;
    }
  }

  void validDelayedCheck(AsyncAction<bool> event) {
    print(event);
  }

  final FaceZoneService faceZoneService;
  final WebshopMessagesService msg;

  SkinTest model = new SkinTest()..gender;
  final Map<String, String> genderOptions;
  final Map<String, String> problemAreaOptions = {};
}
