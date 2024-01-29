import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/vitals/post_vital_request.dart';

abstract class VitalService {

  Future<GenericResponse> getVitalInfo(int id);
  Future<GenericResponse> postVitalInfo(PostVitalRequest model);

}