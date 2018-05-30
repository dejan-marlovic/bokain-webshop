import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_consultation/bokain_consultation.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:fo_components/fo_components.dart';

@Component(
    selector: 'skin-consultation-component',
    templateUrl: 'skin_consultation_component.html',
    styleUrls: const [
      'skin_consultation_component.css'
    ],
    directives: const [
      ButtonCloudSingleSelectComponent,
      ConsultationSectionPicturesComponent,
      ConsultationSectionProblemAreasComponent,
      ConsultationSectionSymptomsComponent,
      coreDirectives,
      materialDirectives,
    ],
    providers: const [
      ConsultationService,
      CustomerService
    ],
    pipes: const [
      PhrasePipe
    ])
class SkinConsultationComponent { 
  SkinConsultationComponent();

  Future onCreateCustomer() async {
    customer.id = 'hej';
  }

  Date get birthdate => customer.birthdate == null ? null : Date.fromTime(customer.birthdate);

  set birthdate(Date date) {
    customer.birthdate = date == null ? null : new DateTime(date.year, date.month, date.day);
  }

  Customer customer = new Customer();
  Consultation consultation = new Consultation();
  final Date minDate = new Date.today().add(years: -100);
  final Date maxDate = new Date.today().add(years: -10);

  bool termsAccepted = false;
}
