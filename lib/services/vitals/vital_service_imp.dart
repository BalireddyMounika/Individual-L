import 'package:dio/dio.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/vitals/post_vital_request.dart';
import 'package:life_eazy/services/vitals/vitals_seirvice.dart';

class VitalServiceImp extends VitalService {
  late Dio dio;

  VitalServiceImp(this.dio);

  @override
  Future<GenericResponse> getVitalInfo(int id) async {
    GenericResponse response = GenericResponse();
    String url = "User/GetVitalsByUserId/$id/";
    try {
      var httpResponse = await dio.get((url));

      if (httpResponse.statusCode == 200) {
        return GenericResponse.fromMap(httpResponse.data);
      }
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);
      } else {
        throw ("something went wrong");
      }
    }
    return response;
  }

  @override
  Future<GenericResponse> postVitalInfo(PostVitalRequest model) async {
    var response = new GenericResponse(
        message: "", result: dynamic, hasError: false, statusCode: 200);
    var url = "User/VitalsAPI/";
    try {
      var httpResponse = await dio.post(url, data: model.toJson());
      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage!;
      response.hasError = true;
    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);
      }
      else
        response.message = somethingWentWrong;

      response.hasError = true;
    }

    return response;
  }
}

