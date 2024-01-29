import 'package:dio/dio.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/services/subscription/subscription_services.dart';
import '../../constants/strings.dart';
import '../../models/subscription/subscription_request.dart';

class SubscriptionServiceImp extends SubscriptionServices
{
  late Dio dio;

  SubscriptionServiceImp(this.dio);

  @override
  Future<GenericResponse> getAllMasterSubscription() async {
    var response = new GenericResponse();
    var url = "Subscription/GetallMasterSubscription/";

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
  Future<GenericResponse> postSubscriptionApi(SubscriptionModelRequest request)async{
    var response = new GenericResponse();
    var url = "Subscription/SubscriptionPostApi/";

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
  Future<GenericResponse> getBySubscriptionByUserId(int id)async {
    var response = new GenericResponse();
    var url = "Subscription/GetBySubscription/$id/";
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


}