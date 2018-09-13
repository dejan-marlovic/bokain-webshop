import 'package:angular/angular.dart';

@Component(
    selector: 'bo-side-nav-page',
    templateUrl: 'side_nav_page_component.html',
    styleUrls: const ['side_nav_page_component.css'],
    directives: const [NgIf],
    changeDetection: ChangeDetectionStrategy.OnPush)
class SideNavPageComponent {
  SideNavPageComponent(this._changeDetector);

  bool get active => _active;
  
  set active(bool flag) {
    _active = flag;
    _changeDetector.markForCheck();
  }

  @Input()
  String label;

  @Input()
  String name;

  bool _active = false;

  final ChangeDetectorRef _changeDetector;
}
