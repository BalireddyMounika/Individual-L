
import 'package:dio/dio.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/immunization/post_immunisation_request.dart';
import 'package:life_eazy/services/immunization/immunization_services.dart';

import '../../constants/strings.dart';

class ImmunizationServiceImp extends  ImmunizationService
{
  late Dio dio;

  ImmunizationServiceImp(this.dio);
  @override
  Future<GenericResponse> editImmunization() {
    // TODO: implement editImmunization
    throw UnimplementedError();
  }

  @override
  Future<GenericResponse> getImmunizationByUserId(int userId) async{
    var response = new GenericResponse();
    var url = "Immunization/ImmunizationGetUserId/$userId";

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
  Future<GenericResponse> postImmunization(PostImmunizationRequests request) async{
    var response = new GenericResponse();
    var url = "Immunization/Immunization/";

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
  
}