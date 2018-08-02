import 'package:angular/angular.dart';

/*
 * Make sure to have imported icomoon fonts before using
 * 
 * @font-face {
    font-family: 'icomoon';
    src: url('fonts/icomoon.eot?xf6dd5');
    src: url('fonts/icomoon.eot?xf6dd5#iefix') format('embedded-opentype'), url('fonts/icomoon.ttf?xf6dd5') format('truetype'), url('fonts/icomoon.woff?xf6dd5') format('woff'), url('fonts/icomoon.svg?xf6dd5#icomoon') format('svg');
    font-weight: normal;
    font-style: normal;
}
*/

@Component(
  selector: 'bo-icon',
  templateUrl: 'icon_component.html',
  styleUrls: const ['icon_component.css'],
  directives: const [NgStyle],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class IconComponent {

  String get iconClass => 'icon-$icon';

  @Input()
  String size = '1em';

  @Input()
  String icon;
}