import 'package:angular/di.dart';
import 'package:angular_router/angular_router.dart';

@Injectable()
class RouteService {
  List<RouteDefinition> routes;
  List<RouteDefinition> productCategoryRoutes;
}
