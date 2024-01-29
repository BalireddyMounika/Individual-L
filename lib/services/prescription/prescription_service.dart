import 'package:life_eazy/models/generic_response.dart';

abstract class PrescriptionService {

  Future<GenericResponse> getPrescriptionInfo(int id);
  Future<GenericResponse> getPrescriptionInfoByAppointmentId(int id);
}