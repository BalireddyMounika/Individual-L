

import 'package:dio/dio.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/paymentt_transactions/transaction_history_request.dart';
import 'package:life_eazy/services/payment_transactions/payment_transaction_services.dart';

class PaymentTransactionServiceImp extends PaymentTransactionService
{
  late Dio dio;

  PaymentTransactionServiceImp(this.dio);

  @override
  Future<GenericResponse> postPaymentTransaction(TransactionHistoryRequest request) async{
    var response = new GenericResponse();
    var url = "UserAppointment/BillingReport";

    try {
      var httpResponse = await dio.post(url, data: request.toJson());

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

  @override
  Future<GenericResponse> getPaymentTransaction(int userId) async  {
    var response = new GenericResponse();
    var url = "UserAppointment/UserBillingView/$userId/";

    try {
      var httpResponse = await dio.get(url);

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage;
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