import 'package:dio/dio.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/models/authentication/login_request_model.dart';
import 'package:life_eazy/models/authentication/register_request_model.dart';
import 'package:life_eazy/models/authentication/registration_update_model.dart';
import 'package:life_eazy/models/authentication/reset_password_request_model.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/services/authentication/auth_servcices.dart';

class AuthServiceImp extends AuthService {
  late Dio dio;

  AuthServiceImp(this.dio);

  @override
  Future<GenericResponse> login(LoginRequestModel model) async {
    var response = new GenericResponse();
    var url = "User/Login/";

    try {
      var httpResponse = await dio.post(url, data: model.toJson());

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage!;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);  }
      else
        response.message = somethingWentWrong;

      response.hasError = true;
    }

    return response;
  }

  @override
  Future<GenericResponse> register(RegisterRequestModel model) async {
    var response = new GenericResponse(
        message: "", result: dynamic, hasError: false, statusCode: 200);
    var url = "User/Register/";

    try {
      var httpResponse = await dio.post(url, data:model.toJson());

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage!;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);      }
      else
        response.message = somethingWentWrong;

      response.hasError = true;
    }
    return response;
  }

  @override
  Future<GenericResponse> isPhoneNumberRegistered(String? phoneNumber) async {
    var response = new GenericResponse();
    var url = "User/UserIsNumberRegistered/$phoneNumber/${SessionManager.fcmToken}/";

    try {
      var httpResponse = await dio.get(url);

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);      }
      else
        response.message = somethingWentWrong;

      response.hasError = true;
    }
    return response;
  }

  @override
  Future<GenericResponse> resetPassword(ResetPasswordRequestModel model) async {
    var response = new GenericResponse();
    var url = "User/UserChangePassword/${SessionManager.getUser.id}/";

    try {
      var httpResponse = await dio.put(url, data: model.toJson());

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage!;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);      }
      else
        response.message = somethingWentWrong;

      response.hasError = true;
    }

    return response;

  }

  @override
  Future<GenericResponse> updateRegistration(RegistrationUpdateModel model) async{
    var response = new GenericResponse();
    var url = "User/UserRegistrationUpdate/${SessionManager.getUser.id}/";

    try {
      var httpResponse = await dio.put(url, data: model.toJson());

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage!;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);      }
      else
        response.message = somethingWentWrong;

      response.hasError = true;
    }

    return response;

  }
}
