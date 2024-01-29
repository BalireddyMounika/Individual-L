import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/prefered_physician/prefered_physician_request.dart';

abstract class PreferPhysicianServices
{
  Future<GenericResponse> addPreferPhysician(PreferedPhysicianRequest request);
  Future<GenericResponse> getPreferPhysician(int id);
  Future<GenericResponse> deletePreferPhysician(int id);

}
