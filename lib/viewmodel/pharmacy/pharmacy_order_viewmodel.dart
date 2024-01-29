import 'package:flutter/cupertino.dart';
import 'package:life_eazy/models/paymentt_transactions/transaction_history_request.dart';
import 'package:life_eazy/services/payment_transactions/payment_transaction_services.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../common_widgets/popup_dialog.dart';
import '../../constants/strings.dart';
import '../../enums/snackbar_types.dart';
import '../../enums/viewstate.dart';
import '../../get_it/locator.dart';
import '../../models/generic_response.dart';
import '../../models/pharmacy/pharmacy_order_request.dart';
import '../../models/pharmacy/pharmacy_order_response.dart';
import '../../net/session_manager.dart';
import '../../route/routes.dart';
import '../../services/common_service/common_api/common_api_service.dart';
import '../../services/common_service/dialog_services.dart';
import '../../services/common_service/snackbar_service.dart';
import '../../services/pharmacy/pharmacy_service.dart';

class PharmacyOrderViewModel extends CustomBaseViewModel {
  var _snackBarService = locator<SnackBarService>();
  var _pharmacyService = locator<PharmacyService>();
  var _commonService = locator<CommonApiService>();
  var _dialogService = locator<DialogService>();
  var _paymentTransactionService = locator<PaymentTransactionService>();
  var _loadingMessage = "";
  int grandTotal = 0;
  Razorpay _razorpay = Razorpay();
  List<PharmacyOrderResponse> _pharmacyOrderList = [];
  List<PharmacyOrderResponse> _tempPharmacyOrderList = [];

  List<PharmacyOrderResponse> get pharmacyOrderList => _pharmacyOrderList;
  PharmacyOrderResponse responseData = PharmacyOrderResponse();

  List<FilterModel> filterOptionList = [
    new FilterModel(0, true, 'All'),
    new FilterModel(1, false, 'Pending'),
    new FilterModel(2, false, 'In-Process'),
    new FilterModel(3, false, 'Confirmed'),
    new FilterModel(4, false, 'Delivered'),
  ];
  PharmacyOrderViewModel();

  Future getPahrmacyOrders() async {
    _pharmacyOrderList = [];
    setState(ViewState.Loading);
    try {
      var response = await _pharmacyService.getPharmacyOrdersByUserID();

      if (response.statusCode == 200) {
        var data = response.result as List;
        data.forEach((element) {
          _pharmacyOrderList.add(PharmacyOrderResponse.fromMap(element));
        });

        _tempPharmacyOrderList = _pharmacyOrderList;
        setState(ViewState.Completed);
      } else {
        setState(ViewState.Completed);
        _snackBarService.showSnackBar(
          snackbarType: SnackbarType.error,
          title: response.message ?? somethingWentWrong,
        );
      }
    } catch (e) {
      setState(ViewState.Completed);
      _snackBarService.showSnackBar(
        snackbarType: SnackbarType.error,
        title: somethingWentWrong,
      );
    }
  }

  Future<GenericResponse> updatePharmacyOrder(
      PharmacyOrderResponse responseData, transactionID) async {
    var response = GenericResponse();
    try {
      setState(ViewState.Loading);

      var request = new PharmacyOrdersRequest(
        userId: SessionManager.getUser.id,
        professionalId: responseData.professionalId ?? 0,
        userAddress: responseData.userAddress ?? "",
        username: responseData.username,
        userPhoneNumber: responseData.userPhoneNumber,
        userSecondaryPhoneNumber: responseData.userSecondaryPhoneNumber,
        pharmacyId: responseData.pharmacyId?.id,
        chronicIllnessQualifier: 'yes',
        uploadDocument: responseData.uploadDocument,
        deliveredDate: responseData.deliveredDate,
        deliveredTime: '08:00pm',
        itemQuantity: responseData.medicine?.length,
        orderStatus: 'confirmed',
        transactionId: transactionID,
        paymentStatus: 'completed',
        prescribedBy: responseData.prescribedBy,
        total: responseData.total,
      );
      var data = await _pharmacyService.updatePharmacyOrders(
          request, responseData.id ?? 0);

      if (data.statusCode == 200) {
        _dialogService.showDialog(DialogType.SuccessDialog, message,
            "Payment  Successfully", Routes.pharmacyOrderView, done,
            isStackedCleared: false);
        setState(ViewState.Completed);
      } else {
        setState(ViewState.Completed);
        _snackBarService.showSnackBar(
          snackbarType: SnackbarType.error,
          title: data.message ?? somethingWentWrong,
        );
      }
    } catch (e) {
      _snackBarService.showSnackBar(
        snackbarType: SnackbarType.error,
        title: somethingWentWrong,
      );
      setState(ViewState.Completed);
    }

    return response;
  }

  void initializePaymentGateway() {
    // _userModel = SignInResponse.fromJson(_localStorageService.profileModel);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  // Future addPaymentTransaction(TransactionHistoryRequest request)async
  // {
  //   _loadingMessage = "Adding Transaction";
  //   setState(ViewState.Loading);
  //   try
  //   {
  //
  //     request.appointmentId = this.appointmentId??0;
  //
  //     var response = await _paymentTransactionService.postPaymentTransaction(request);
  //
  //     if (response.hasError ?? false) {
  //       setState(ViewState.Completed);
  //       _dialogService.showDialog(
  //           DialogType.ErrorDialog, message, response.message??somethingWentWrong, "", done);
  //     } else {
  //       //setState(ViewState.Completed);
  //
  //       // createAppointment();
  //     }
  //   }
  //   catch(error)
  //   {
  //     setState(ViewState.Completed);
  //     _dialogService.showDialog(
  //         DialogType.ErrorDialog, message, somethingWentWrong, "", done);
  //     setState(ViewState.Completed);
  //   }
  // }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    addPaymentTransaction(new TransactionHistoryRequest(
        transactionId: response.paymentId,
        date: DateTime.now().toString().split(' ')[0],
        amount: grandTotal,
        userId: SessionManager.getUser.id,
        transactionStatus: "SUCCESS",
        transactionFor: "pharmacy",
        maskTransactionId: 'vfy_${Uuid().v4().split('-').last}'));
    updatePharmacyOrder(responseData, response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    addPaymentTransaction(new TransactionHistoryRequest(
        transactionId: response.code.toString(),
        date: DateTime.now().toString().split(' ')[0],
        amount: grandTotal,
        userId: SessionManager.getUser.id,
        transactionStatus: "FAIL",
        transactionFor: "pharmacy",
        maskTransactionId: 'vfy_${Uuid().v4().split('-').last}'));
    _snackBarService.showSnackBar(
      snackbarType: SnackbarType.error,
      title: response.message,
    );
    print("Payment Error");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  payViaPaymentGateway(int value, response) async {
    responseData = response;
    grandTotal = value;
    //initializePaymentGateway();

    var options = {
      //'key': 'rzp_live_T8dClTScJFyz0b',
      'key': 'rzp_test_wvdg8IobCdqzRT',
      // 'key': 'rzp_test_fSJuZPkqnpApFp',
      'amount':
          value * 100, //Razorpay takes amount in paise (1 rupee = 100 paise)
      'name': 'LifeEazy',
      'currency': 'INR',
      'description': 'Pharmacy Charge',
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

  filterManager(int index, bool status, String optionName) {
    filterOptionList.forEach(
      (element) {
        if (element.index == index)
          element.status = true;
        else
          element.status = false;
      },
    );
    switch (optionName) {
      case 'All':
        {
          _pharmacyOrderList = _tempPharmacyOrderList;
        }
        break;
      case 'Delivered':
        {
          _pharmacyOrderList = _tempPharmacyOrderList
              .where((element) => element.orderStatus == "delivered")
              .toList();
        }
        break;
      case 'Pending':
        {
          _pharmacyOrderList = _tempPharmacyOrderList
              .where((element) => element.orderStatus == "pending")
              .toList();
        }
        break;
      case 'In-Process':
        {
          _pharmacyOrderList = _tempPharmacyOrderList
              .where((element) => element.orderStatus == "In-Process")
              .toList();
        }
        break;
      case 'Confirmed':
        {
          _pharmacyOrderList = _tempPharmacyOrderList
              .where((element) => element.orderStatus == "confirmed")
              .toList();
        }
        break;
    }

    notifyListeners();
  }
}

class FilterModel {
  int index;
  String name;
  bool status;
  FilterModel(this.index, this.status, this.name);
}
