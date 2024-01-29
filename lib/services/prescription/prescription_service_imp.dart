import 'package:dio/dio.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/services/prescription/prescription_service.dart';

class PrescriptionServiceImp extends PrescriptionService {
  late Dio dio;

  PrescriptionServiceImp(this.dio);

  @override
  Future<GenericResponse> getPrescriptionInfo(int id) async {
    GenericResponse response = GenericResponse();
    String url = "HcpPrescription/GetPresciptionByUserId/$id/";
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
  Future<GenericResponse> getPrescriptionInfoByAppointmentId(int id) async{

    GenericResponse response = GenericResponse();
    String url = "HcpPrescription/GetPrescriptionByAppointmentId/$id/";
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
}
