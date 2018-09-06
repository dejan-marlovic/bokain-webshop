import 'package:angular/angular.dart';
import 'side_nav_page_component.dart';

@Component(
    selector: 'bo-side-nav',
    templateUrl: 'side_nav_component.html',
    styleUrls: const ['side_nav_component.css'],
    directives: const [NgFor, NgIf, NgClass],
    changeDetection: ChangeDetectionStrategy.OnPush)
class SideNavComponent {
  SideNavComponent();

  void onPageClick(SideNavPageComponent page) {
    for (final t in _pages) {
      t.active = false;
    }
    page.active = true;
  }

  List<SideNavPageComponent> get pages => _pages;

  @ContentChildren(SideNavPageComponent)
  set pages(List<SideNavPageComponent> value) {
    _pages = value;
    if (_pages != null && _pages.isNotEmpty) {
      _pages.first.active = true;
    }
  }

  List<SideNavPageComponent> _pages;
}
