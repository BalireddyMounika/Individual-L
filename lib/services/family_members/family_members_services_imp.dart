import 'package:dio/dio.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/models/family_members/user_family_member_address_request.dart';
import 'package:life_eazy/models/family_members/user_famliy_member_request.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/net/urls.dart';
import 'package:life_eazy/services/family_members/family_members_services.dart';

class FamilyMembersServicesImp extends FamilyMembersServices {
  late Dio dio;

  FamilyMembersServicesImp(this.dio);

  @override
  Future<GenericResponse> addFamilyMembers(
      UserFamilyMemberRequest request) async {
    var response = new GenericResponse();
    try {
      var httpResponse = await dio.post(AapUrls.userAddFamilyMemberView,
          data: request.toJson());

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
  Future<GenericResponse> addFamilyMembersAddress(
      UserFamilyMemberAddressRequest request) async {
    var response = new GenericResponse();
    var url = "User/AddFamilyMemberAddressView/";

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
  Future<GenericResponse> getFamilyMembersList(int userId) async {
    var response = new GenericResponse();
    var url = "User/GetFamilyByUserId/$userId/";

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
  Future<GenericResponse> editFamilyMembers(
      UserFamilyMemberRequest request, int id) async {
    var response = new GenericResponse();
    var url = "User/FamilyMemberUpdateView/$id/";

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

  @override
  Future<GenericResponse> editFamilyMembersAddress(
      UserFamilyMemberAddressRequest request, int id) async {
    var response = new GenericResponse();
    var url = "User/FamilyMemberAddressUpdateView/$id/";

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
