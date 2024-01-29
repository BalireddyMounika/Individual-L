import 'package:life_eazy/models/appointments/appointment_request.dart';
import 'package:life_eazy/models/generic_response.dart';

abstract class AppointmentService {
  Future<GenericResponse> getAllDoctors();
  Future<GenericResponse> getDoctorsDetails(int doctorId);
  Future<GenericResponse> postAppointments(AppointmentRequest request);
  Future<GenericResponse> getAppointmentsHistory(int userId);
  Future<GenericResponse> getActiveVideoConference(int userId);
  Future<GenericResponse> getScheduleCallStatusByAppointmentId(int id);
  Future<GenericResponse> updateAppointment(int id, AppointmentRequest request);
}
