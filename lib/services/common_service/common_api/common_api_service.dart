import 'dart:io';

import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/otp/genrate_otp_request.dart';
import 'package:life_eazy/models/otp/validate_otp_request.dart';

abstract class CommonApiService {
  Future<GenericResponse> postImage(File file);
  Future<GenericResponse> getImageByName(String name);
  Future<GenericResponse> getAutoCompleteSearch(String data);
  Future<GenericResponse> getSpecialisation();
  Future<GenericResponse> generateOtp(GenerateOtpRequest request);
  Future<GenericResponse> validateOtp(ValidateOtpRequest request, int id);
}
