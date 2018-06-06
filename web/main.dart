
import 'package:angular/angular.dart';
import 'package:firebase/firebase.dart' as firebase;

import 'package:bokain_webshop/app_component.template.dart' as ng;

void main() {
  firebase.initializeApp
    (
      apiKey: 'AIzaSyCI0vWdEbluGat7P20ffnl8u5PCRPo_pC4',
      authDomain: 'bokain-admin.firebaseapp.com',
      databaseURL: 'https://bokain-admin.firebaseio.com',
      storageBucket: 'bokain-admin.appspot.com',
      projectId: 'bokain-admin'
  );  
   runApp(ng.AppComponentNgFactory);
}
