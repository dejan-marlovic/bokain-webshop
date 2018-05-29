import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'productbox_component/productbox_component.dart';

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [materialDirectives, ProductBoxComponent, coreDirectives],
  providers: const [materialProviders, ProductService, UserService],
)
class AppComponent
{
  AppComponent(this.productService, this.userService)
  {
    userService.login('patrick.minogue@gmail.com', 'lok13rum').then((_) => productService.streamMany());
    //dynamicPhraseService.streamLanguage('sv');
  }
  ProductService productService;
  UserService userService;
  int x = 0;
  
  String selectedProductId;
}
