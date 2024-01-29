import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/profile/user_profile_address_request.dart';
import 'package:life_eazy/models/profile/user_profile_request.dart';
import 'package:life_eazy/services/profile/profile_service.dart';

import '../../models/profile/user_profile_update_request.dart';

class ProfileServiceImp extends ProfileService {
  late Dio dio;

  ProfileServiceImp(this.dio);

  @override
  Future<GenericResponse> postUserProfile(UserProfileRequest request) async {
    var response = new GenericResponse();
    var url = "User/Profile/";

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
  Future<GenericResponse> postUserProfileAddress(
      UserProfileAdressRequest request) async{
    var response = new GenericResponse();
    var url = "User/Address/";

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
  Future<GenericResponse> getProfile(int userId)async {
    var response = new GenericResponse();
        var url = "User/GetUserById/$userId/";

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
  Future<GenericResponse> updateUserProfile(UserProfileUpdateRequest request, int userId) async{
    var response = new GenericResponse();
    var url = "User/UserProfileUpdate/$userId/";

    var myJson = jsonEncode(request.toMap());
    var  model =  json.decode(myJson) as Map<String,dynamic>;
    var title =  model["Title"];
    var newModel =UserProfileUpdateRequest.fromMap(model);

    try {
      var httpResponse = await dio.put(url, data: jsonEncode(request.toMap()));

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
  Future<GenericResponse> updateUserProfileAddress(UserProfileAdressRequest request, int userId) async{
    var response = new GenericResponse();
    var url = "User/UserAddressUpdate/$userId/";

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
