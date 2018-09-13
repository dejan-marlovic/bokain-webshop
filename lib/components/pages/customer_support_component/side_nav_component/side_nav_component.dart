import 'dart:async';
import 'package:angular/angular.dart';
import 'side_nav_page_component.dart';

@Component(
    selector: 'bo-side-nav',
    templateUrl: 'side_nav_component.html',
    styleUrls: const ['side_nav_component.css'],
    directives: const [NgFor, NgIf, NgClass],
    changeDetection: ChangeDetectionStrategy.OnPush)
class SideNavComponent implements OnDestroy {
  SideNavComponent();

  @override
  void ngOnDestroy() {
    _activePageChangeController.close();
  }

  void onPageClick(SideNavPageComponent page) {
    for (final t in _pages) {
      t.active = false;
    }
    page.active = true;
    _activePageChangeController.add(page.name);
  }

  List<SideNavPageComponent> get pages => _pages;

  @ContentChildren(SideNavPageComponent)
  set pages(List<SideNavPageComponent> value) {
    _pages = value;
    if (_pages != null &&
        _pages.isNotEmpty &&
        _pages.where((p) => p.active == true).isEmpty) {
      _pages.first.active = true;
    }
  }

  @Input()
  set activePage(String value) {
    _activePage = value;
    for (final t in _pages) {
      t.active = false;
    }
    _pages.firstWhere((p) => p.name == _activePage, orElse: () => null)?.active = true;    
  }

  @Output() 
  Stream<String> get activePageChange => _activePageChangeController.stream;

  String _activePage;
  final StreamController<String> _activePageChangeController = new StreamController();
  List<SideNavPageComponent> _pages;
}
