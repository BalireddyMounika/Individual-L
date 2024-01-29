

import 'package:life_eazy/models/authentication/login_request_model.dart';
import 'package:life_eazy/models/authentication/register_request_model.dart';
import 'package:life_eazy/models/authentication/registration_update_model.dart';
import 'package:life_eazy/models/authentication/reset_password_request_model.dart';
import 'package:life_eazy/models/generic_response.dart';

abstract class AuthService
{

  Future<GenericResponse> login(LoginRequestModel model);

  Future<GenericResponse> register(RegisterRequestModel model);

  Future<GenericResponse> updateRegistration(RegistrationUpdateModel model);

  Future<GenericResponse> isPhoneNumberRegistered(String? phoneNumber);

  Future<GenericResponse> resetPassword(ResetPasswordRequestModel model);





}