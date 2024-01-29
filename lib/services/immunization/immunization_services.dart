
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/immunization/post_immunisation_request.dart';

abstract class ImmunizationService
{

   Future<GenericResponse> getImmunizationByUserId(int userId);
   Future<GenericResponse> postImmunization(PostImmunizationRequests request);
   Future<GenericResponse> editImmunization();
}