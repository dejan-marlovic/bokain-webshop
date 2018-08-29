import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:firebase/firebase.dart' as fb;

import 'package:bokain_webshop/app_component.template.dart' as ng;
import 'main.template.dart' as self;

@GenerateInjector(routerProvidersHash)
final InjectorFactory injector = self.injector$Injector;

void main() {
  fb.initializeApp(
      apiKey: 'AIzaSyCI0vWdEbluGat7P20ffnl8u5PCRPo_pC4',
      authDomain: 'bokain-admin.firebaseapp.com',
      databaseURL: 'https://bokain-admin.firebaseio.com',
      storageBucket: 'bokain-admin.appspot.com',
      projectId: 'bokain-admin');

      
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
