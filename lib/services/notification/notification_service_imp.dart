import 'package:dio/dio.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'notification_service.dart';

class NotificationServiceImp extends NotificationService {
  late Dio dio;
  NotificationServiceImp(this.dio);
  @override
  Future<GenericResponse> getNotificationInfo(int id) async {
    GenericResponse response = GenericResponse();
    String url = "Notifications/GetByUserIdNotifications/$id/";
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

