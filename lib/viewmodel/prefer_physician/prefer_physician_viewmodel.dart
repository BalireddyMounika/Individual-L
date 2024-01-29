
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/snackbar_types.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/appointments/doctor_details_response.dart';
import 'package:life_eazy/models/prefered_physician/prefered_physician_request.dart';
import 'package:life_eazy/models/prefered_physician/prefered_physician_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/appointments/appointment_services.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/services/prefer_physician/prefer_physician_services.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

class PreferedPhysicianViewModel extends CustomBaseViewModel {

  PreferedPhysicianViewModel();

  var _appointmentService = locator<AppointmentService>();
  var _dialogService = locator<DialogService>();
  var _preferPhysicianService = locator<PreferPhysicianServices>();
  var _snackBarService = locator<SnackBarService>();

  var navigationService = locator<NavigationService>();
  List<DoctorDetailResponse> _doctorList = [];
  String loadingMsg = "";

  List<DoctorDetailResponse> get doctorList => _doctorList;


  List<DoctorDetailResponse> _preferPhysicianList = [];
  List<DoctorDetailResponse> _temp = [];
  List<DoctorDetailResponse> _tempFilteredList = [];


  List<DoctorDetailResponse> get preferPhysicianList => _preferPhysicianList;
  List<PreferedPhysicianResponse> preferPhysicianResponse =  [];

  PreferedPhysicianRequest preferedPhysicianRequest = PreferedPhysicianRequest();


  var loaderMsg = "";

  Future getDoctorsList() async {
    List<DoctorDetailResponse> list = [];
    try {
      setState(ViewState.Loading);
      var response = await _appointmentService.getAllDoctors();
      if (response.hasError ?? false) {
        _dialogService.showDialog(
            DialogType.ErrorDialog, message, response.message, "", done);
      } else {
        var data = response.result as List;
        data.forEach((element) {
          list.add(DoctorDetailResponse.fromMap(element));
        });

        _temp = list;
        _doctorList = _temp
            .where((element) =>
        element.schedule != null && element.professional != null
            ? element.schedule!.toDate!.isAfter(DateTime.now())
            : element.deviceToken == "1")
            .toList();

        _tempFilteredList = _doctorList;
        setState(ViewState.Completed);
      }
    } catch (e) {
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  Future addPreferPhysician(int doctorId) async {
    loaderMsg = "Adding Preferred Physician";
    setState(ViewState.Loading);
    try {
      var response = await _preferPhysicianService.addPreferPhysician(
          new PreferedPhysicianRequest(
              userId: SessionManager.getUser.id,
              preferredPhysician: doctorId
          ));
      if (response.hasError ?? false) {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? "", "", done);
      } else {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.SuccessDialog, message,
            "Physicians Successfully added", Routes.preferPhysicianView, done,
            isStackedCleared: true);
        setState(ViewState.Completed);
      }
    } catch (error) {
      setState(ViewState.Completed);
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  Future getPreferPhysicianList() async {
    loaderMsg = "fetching Preferred Physician";
    try {
      setState(ViewState.Loading);
      var response = await _preferPhysicianService.getPreferPhysician(
          SessionManager.getUser.id ?? 0);
      if (response.hasError ?? false) {
        setState(ViewState.Empty);
      } else {
        var data = response.result as List;
        data.forEach((element) {
          preferPhysicianResponse.add(PreferedPhysicianResponse.fromMap(element));
          var localData = element["PreferredPhysician"];
          if (localData != null)
            _preferPhysicianList.add(DoctorDetailResponse.fromMap(localData));
        });
        setState(ViewState.Completed);
      }
    } catch (e) {
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  searchFilter(String chr) {
    if (chr.isEmpty)
      _preferPhysicianList = _doctorList;
    else
      _preferPhysicianList = _doctorList.where((element) =>
      element.firstname!
          .toLowerCase().contains(chr.toLowerCase()) == true).toList();
    notifyListeners();
  }

  searchPhysicianFilter(String chr) {
    if (chr.isEmpty) {
      _doctorList = _tempFilteredList;
      setState(ViewState.Completed);
    }
    else {
      _doctorList =
          _tempFilteredList.where((element) =>
          element.firstname!.toLowerCase().contains(
              chr.toLowerCase()) == true)
              .toList();

      _doctorList.length >= 1 ? setState(ViewState.Completed) : setState(
          ViewState.Empty);
    }
  }


  Future deletePreferPhysician(int id) async {
    loaderMsg = 'Deleting Prefer Physician';
    setState(ViewState.Loading);
    try {
      var response = await _preferPhysicianService.deletePreferPhysician(id);
      if (response.hasError == true ?? false) {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? "", "", done);
      } else {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.SuccessDialog, message,
            "Physicians Successfully Removed", Routes.preferPhysicianView, done,
            isStackedCleared: true);
        setState(ViewState.Completed);
      }
    } catch (error) {
      setState(ViewState.Completed);
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }
}
