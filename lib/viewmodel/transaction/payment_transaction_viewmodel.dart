

import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/paymentt_transactions/payment_transaction_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/services/appointments/appointment_services.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/services/payment_transactions/payment_transaction_services.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

class PaymentTransactionViewModel extends CustomBaseViewModel
{
  var _paymentTransactionService = locator<PaymentTransactionService>();
  var _dialogService = locator<DialogService>();
  var navigationService = locator<NavigationService>();
  List<PaymentTransactionResponse> _paymentTransactionHistoryList = [];
  List<PaymentTransactionResponse> get paymentTransactionHistoryList   =>  _paymentTransactionHistoryList;
  PaymentTransactionViewModel();

  Future getPaymentTransactionList() async {
    try {
      setState(ViewState.Loading);
      var response = await _paymentTransactionService.getPaymentTransaction(SessionManager.getUser.id??0);
      if (response.hasError ?? false) {
        // _dialogService.showDialog(
        //     DialogType.ErrorDialog, message, response.message??somethingWentWrong, "", done);
         setState(ViewState.Empty);
      } else {
        var data = response.result as List;
        data.forEach((element) {
          _paymentTransactionHistoryList.add(PaymentTransactionResponse.fromMap(element));
        });
        _paymentTransactionHistoryList.reversed;
        setState(ViewState.Completed);
      }
    } catch (e) {
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Empty);
    }
  }

}
