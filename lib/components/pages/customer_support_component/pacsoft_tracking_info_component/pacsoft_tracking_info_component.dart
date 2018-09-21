import 'package:angular/angular.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';

@Component(
  selector: 'bo-pacsoft-tracking-info',
  templateUrl: 'pacsoft_tracking_info_component.html',
  styleUrls: const ['pacsoft_tracking_info_component.css'],
  directives: const [NgFor, NgIf],
  pipes: [JsonPipe, NamePipe],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class PacsoftTrackingInfoComponent {
  PacsoftTrackingInfoComponent(this.msg);

  @Input()
  PacsoftTrackingInformationResponse model;

  final WebshopMessagesService msg;
}