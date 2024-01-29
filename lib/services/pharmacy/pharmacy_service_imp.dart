import 'package:dio/dio.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/services/pharmacy/pharmacy_service.dart';

import '../../models/pharmacy/pharmacy_order_request.dart';

class PharmacyServiceImp extends PharmacyService {
  late Dio dio;

  PharmacyServiceImp(this.dio);
  @override
  Future<GenericResponse> getAllPharmacyList() async {
    var response = GenericResponse();
    var url = 'Pharmacy/GetallPharmacyList/';
    try {
      var httpResponse = await dio.get(url);

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage;
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
  Future<GenericResponse> postPharmacyOrders(
      PharmacyOrdersRequest request) async {
    var response = new GenericResponse();
    var url = "Pharmacy/Pharmacyorders/";

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
  Future<GenericResponse> getPharmacyOrdersByUserID() async {
    var response = GenericResponse();
    var url = 'Pharmacy/GetOrdersByUserId/${SessionManager.getUser.id}/';
    try {
      var httpResponse = await dio.get(url);

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage;
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
  Future<GenericResponse> updatePharmacyOrders(
      PharmacyOrdersRequest request, int id) async {
    var response = new GenericResponse();
    var url = "/Pharmacy/Pharmacyupdateorders/$id";

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
