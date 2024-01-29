import 'package:dio/dio.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/models/appointments/appointment_request.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/services/appointments/appointment_services.dart';

class AppointmentServiceImp extends AppointmentService {
  late Dio dio;

  AppointmentServiceImp(this.dio);

  @override
  Future<GenericResponse> getAllDoctors() async {
    var response = new GenericResponse();
    var url = "HCP/GetAllDoctorsListV2";

    try {
      var httpResponse = await dio.get(url);

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);
      } else
        response.message = somethingWentWrong;
      response.hasError = true;
    }
    return response;
  }

  Future<GenericResponse> getDoctorsDetails(doctorId) async {
    var response = new GenericResponse();
    var url = "HCP/GetHcpById/$doctorId";

    try {
      var httpResponse = await dio.get(url);

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);
      } else
        response.message = somethingWentWrong;
      response.hasError = true;
    }
    return response;
  }

  @override
  Future<GenericResponse> postAppointments(AppointmentRequest request) async {
    var response = new GenericResponse();
    var url = "UserAppointment/CreateUserAppointment/";

    try {
      var httpResponse = await dio.post(url, data: request.toJson());

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage!;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);
      } else
        response.message = somethingWentWrong;

      response.hasError = true;
    }

    return response;
  }

  @override
  Future<GenericResponse> getAppointmentsHistory(int userId) async {
    var response = new GenericResponse();
    var url = "UserAppointment/GetUserAppointmentGetById/$userId/";

    try {
      var httpResponse = await dio.get(url);

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);
      } else
        response.message = somethingWentWrong;
      response.hasError = true;
    }
    return response;
  }

  @override
  Future<GenericResponse> getActiveVideoConference(int userId) async {
    var response = new GenericResponse();
    var url = "UserAppointment/getbyuseridvideoconsultdetails/$userId/";

    try {
      var httpResponse = await dio.get(url);

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);
      } else
        response.message = somethingWentWrong;
      response.hasError = true;
    }
    return response;
  }

  @override
  Future<GenericResponse> getScheduleCallStatusByAppointmentId(int id) async {
    var response = new GenericResponse();
    var url = "/UserAppointment/GetByAppointmentIdVideoConsult/$id";

    try {
      var httpResponse = await dio.get(url);

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);
      } else
        response.message = somethingWentWrong;
      response.hasError = true;
    }
    return response;
  }

  @override
  Future<GenericResponse> updateAppointment(
      int id, AppointmentRequest request) async {
    var response = new GenericResponse();
    var url = "UserAppointment/UserAppointmentUpdate/$id/";

    try {
      var httpResponse = await dio.put(url, data: request.toJson());

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage!;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);
      } else
        response.message = somethingWentWrong;

      response.hasError = true;
    }

    return response;
  }
}
