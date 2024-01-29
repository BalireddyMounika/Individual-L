import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/appointments/doctor_detail_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/services/appointments/appointment_services.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

class DoctorDetailsViewModel extends CustomBaseViewModel {
  var _appointmentService = locator<AppointmentService>();
  var _dialogService = locator<DialogService>();
  var navigationService = locator<NavigationService>();

  Profile profileRequest = new Profile();

  DoctorDetailsResponse doctorDetailResponse = DoctorDetailsResponse();

  Future getDoctorsDetails({required int doctorId}) async {
    try {
      setState(ViewState.Loading);
      var response = await _appointmentService.getDoctorsDetails(doctorId);
      profileRequest.profilePicture =
          SessionManager.profileImageUrl ?? "String";
      if (response.hasError ?? false) {
        _dialogService.showDialog(
            DialogType.ErrorDialog, message, response.message, "", done);
      } else {
        doctorDetailResponse = DoctorDetailsResponse.fromMap(response.result);
        setState(ViewState.Completed);
      }
    } catch (e) {
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }
}
