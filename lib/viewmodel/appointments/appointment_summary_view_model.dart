import 'package:flutter/cupertino.dart';
import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/appointments/appointment_request.dart';
import 'package:life_eazy/models/paymentt_transactions/transaction_history_request.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/appointments/appointment_services.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/services/payment_transactions/payment_transaction_services.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';

class AppointmentSummaryViewModel extends CustomBaseViewModel {
  var _appointmentService = locator<AppointmentService>();
  var _dialogService = locator<DialogService>();
  var _paymentTransactionService = locator<PaymentTransactionService>();
  var navigationService = locator<NavigationService>();
  String _loadingMessage = "";
  var maskTransactionsId = Uuid().v4().split('-').last;
  String get loadingMessage => _loadingMessage;
  set loadingMessage(value) => value = _loadingMessage;
  int? appointmentId = 0;
  Razorpay _razorpay = Razorpay();
  AppointmentRequest _appointmentRequest;

  AppointmentSummaryViewModel(this._appointmentRequest);

  void initializePaymentGateway() {
    // _userModel = SignInResponse.fromJson(_localStorageService.profileModel);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future createAppointment(amount) async {
    _loadingMessage = "Initiating Appointment";
    setState(ViewState.Loading);

    try {
      _appointmentRequest.status = "PENDING";
      _appointmentRequest.fromSubscription = false;
      var response =
          await _appointmentService.postAppointments(_appointmentRequest);
      appointmentId = response.result["id"];
      if (response.hasError ?? false) {
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
        setState(ViewState.Completed);
      } else {
        setState(ViewState.Completed);
        payViaPaymentGateway(amount);
        // _dialogService.showDialog(
        //     DialogType.SuccessDialog, message, "Appointment Successfully Created", Routes.dashboardView, done);
        // setState(ViewState.Completed);
      }
    } catch (error) {
      setState(ViewState.Completed);
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  Future updateAppointment(transactionId) async {
    _loadingMessage = "Creating Appointment";
    setState(ViewState.Loading);
    _appointmentRequest.transactionId = transactionId;

    try {
      _appointmentRequest.status = "CREATED";
      var response = await _appointmentService.updateAppointment(
          appointmentId ?? 0, _appointmentRequest);

      if (response.hasError ?? false) {
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
        setState(ViewState.Completed);
      } else {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.SuccessDialog, message,
            "Appointment Successfully Created", Routes.dashboardView, done);
        setState(ViewState.Completed);
      }
    } catch (error) {
      setState(ViewState.Completed);
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  Future addPaymentTransaction(TransactionHistoryRequest request) async {
    _loadingMessage = "Adding Transaction";
    setState(ViewState.Loading);
    try {
      //request.appointmentId = this.appointmentId??0;

      var response =
          await _paymentTransactionService.postPaymentTransaction(request);

      if (response.hasError ?? false) {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
      } else {
        //setState(ViewState.Completed);

        // createAppointment();
      }
    } catch (error) {
      setState(ViewState.Completed);
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    addPaymentTransaction(new TransactionHistoryRequest(
        transactionId: response.paymentId,
        date: DateTime.now().toString().split(' ')[0],
        amount: _appointmentRequest.fees,
        userId: SessionManager.getUser.id,
        transactionStatus: "SUCCESS",
        transactionFor: "appointment",
        maskTransactionId: 'vfy_$maskTransactionsId'));

    updateAppointment(response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    addPaymentTransaction(new TransactionHistoryRequest(
        transactionId: response.code.toString(),
        date: DateTime.now().toString().split(' ')[0],
        amount: _appointmentRequest.fees,
        userId: SessionManager.getUser.id,
        transactionStatus: "FAIL",
        transactionFor: "appointment",
        maskTransactionId: 'vfy_$maskTransactionsId'));
    _dialogService.showDialog(DialogType.ErrorDialog, message,
        response.message ?? somethingWentWrong, "", done);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  payViaPaymentGateway(int value) async {
    //initializePaymentGateway();

    var options = {
      //'key': 'rzp_live_guuCF2WlV3yeEO',
      'key': 'rzp_test_wvdg8IobCdqzRT',
      // 'key': 'rzp_test_fSJuZPkqnpApFp',
      'amount':
          value * 100, //Razorpay takes amount in paise (1 rupee = 100 paise)
      'name': 'LifeEazy',
      'currency': 'INR',
      'description': 'Appointment Charge',
      'prefill': {
        'contact': SessionManager.getUser.mobileNumber ?? '8888888888',
        'email': SessionManager.getUser.email
      },
      'theme': {'color': '#003fa3'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('RAZORPAY ERROR: $e');
    }
  }
}
