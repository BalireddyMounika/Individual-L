import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/appointments/get_schedule_call_response.dart';
import 'package:life_eazy/services/appointments/appointment_services.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

class AppointmentDetailViewModel extends CustomBaseViewModel {
  String loadingMsg = '';
  var _appointmentService = locator<AppointmentService>();
  var _dialogService = locator<DialogService>();
  List<GetScheduleCallStatusResponse> _scheduleCallStatusList = [];
  List<GetScheduleCallStatusResponse> get scheduleCallStatusList =>
      _scheduleCallStatusList;

  initialiseData() {}

  Future getScheduleCallStatusList(int id) async {
    try {
      loadingMsg = "Fetching Appointments";
      setState(ViewState.Loading);
      var response =
          await _appointmentService.getScheduleCallStatusByAppointmentId(id);
      if (response.hasError ?? false) {
        setState(ViewState.Completed);
      } else {
        var data = response.result as List;
        data.forEach((element) {
          _scheduleCallStatusList
              .add(GetScheduleCallStatusResponse.fromMap(element));
        });

        _scheduleCallStatusList.length == 0
            ? setState(ViewState.Completed)
            : setState(ViewState.Completed);
      }
    } catch (e) {
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Error);
    }
  }
}
