import 'dart:ffi';

import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/appointments/appointment_history_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/services/appointments/appointment_services.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

class AppointmentHistoryViewModel extends CustomBaseViewModel {
  String dropDownInitialValue = 'ALL';
  var dropdownValueItems = ['ALL', 'CREATED', 'ACCEPTED'];

  var _appointmentService = locator<AppointmentService>();
  var _dialogService = locator<DialogService>();
  var navigationService = locator<NavigationService>();
  List<AppointmentHistoryResponse> _completeAppointmentHistoryList = [];
  List<AppointmentHistoryResponse> get completeAppointmentHistoryList =>
      _completeAppointmentHistoryList;

  List<AppointmentHistoryResponse> _activeAppointmentHistoryList = [];
  List<AppointmentHistoryResponse> get activeAppointmentHistoryList =>
      _activeAppointmentHistoryList;

  List<AppointmentHistoryResponse> _tempAppointmentHistoryList = [];

  Future getAppointmentHistoryList() async {
    try {
      setState(ViewState.Loading);
      var response = await _appointmentService
          .getAppointmentsHistory(SessionManager.getUser.id ?? 0);
      if (response.hasError ?? false) {
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
      } else {
        var data = response.result as List;
        data.forEach((element) {
          var model = AppointmentHistoryResponse.fromMap(element);

          if (model.status == 'CONFIRMED') {
            _completeAppointmentHistoryList.add(model);
          } else
            _activeAppointmentHistoryList.add(model);
        });

        _tempAppointmentHistoryList = _activeAppointmentHistoryList;
        if (_activeAppointmentHistoryList.length <= 1) {
          setState(ViewState.Empty);}
        else{
          setState(ViewState.Completed);
        }
      }
    } catch (e) {
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }


  void changedValue(value) {
    if (value == 'ALL') {
      _activeAppointmentHistoryList = _tempAppointmentHistoryList;
    } else {
      _activeAppointmentHistoryList =
          _tempAppointmentHistoryList.where((i) => i.status == value).toList();
    }
    dropDownInitialValue = value;

    notifyListeners();
  }
}
