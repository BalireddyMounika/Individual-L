
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/paymentt_transactions/transaction_history_request.dart';

abstract class PaymentTransactionService
{
  Future<GenericResponse> postPaymentTransaction(TransactionHistoryRequest request);
  Future<GenericResponse> getPaymentTransaction(int userId);
}