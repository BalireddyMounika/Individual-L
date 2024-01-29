import 'package:dio/dio.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/prefered_physician/prefered_physician_request.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/services/prefer_physician/prefer_physician_services.dart';

class PreferPhysicianServiceImp extends PreferPhysicianServices {
  late Dio dio;
  PreferPhysicianServiceImp(this.dio);
  @override
  Future<GenericResponse> addPreferPhysician(
      PreferedPhysicianRequest request) async {
    var response = new GenericResponse();
    var url = "User/PreferredPhysician/";

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
        response.hasError = true;
    }

    return response;
  }

  @override
  Future<GenericResponse> getPreferPhysician(int id) async {
    var response = new GenericResponse();
    var url = "User/GetPreferredPhysician/$id";

    try {
      var httpResponse = await dio.get(url);

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
  Future<GenericResponse> deletePreferPhysician(int id) async {
    GenericResponse response = new GenericResponse();
    //var url = "User/deletePreferredPhysician/${SessionManager.getUser.id}/";
    var url = "User/deletePreferredPhysician/$id/";

    try {
      var httpResponse = await dio.delete(
        url,
      );

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
  // @override
  // Future<GenericResponse> deletePreferPhysician(PreferedPhysicianRequest request,int id)async {
  //   var response = new GenericResponse();
  //   var url = "User/deletePreferredPhysician/$id/";
  //
  //   try {
  //     var httpResponse = await dio.delete(url, data: request.toJson());
  //
  //     if (httpResponse.statusCode == 200)
  //       return GenericResponse.fromMap(httpResponse.data);
  //
  //     response.message = httpResponse.statusMessage!;
  //     response.hasError = true;
  //   } catch (error) {
  //     if (error is DioError) {
  //       return GenericResponse.fromMap(error.response?.data);
  //     } else
  //       response.message = somethingWentWrong;
  //
  //     response.hasError = true;
  //   }
  //
  //   return response;
  // }
}
