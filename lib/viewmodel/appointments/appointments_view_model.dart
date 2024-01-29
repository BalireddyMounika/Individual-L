import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/appointments/DoctorListResponse.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/services/appointments/appointment_services.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

class AppointmentsViewModel extends CustomBaseViewModel {
  var _appointmentService = locator<AppointmentService>();
  var _dialogService = locator<DialogService>();
  var navigationService = locator<NavigationService>();

  List<DoctorListResponse> _doctorList = [];
  List<DoctorListResponse> get doctorList => _doctorList;

  List<DoctorListResponse> _activeDoctorList = [];

  List<DoctorListResponse> get activeDoctorList => _activeDoctorList;
  List<DoctorListResponse> get tempDoctorList => _tempDoctorList;

  List<DoctorListResponse> _inActiveDoctorList = [];
  List<DoctorListResponse> _tempDoctorList = [];
  Profile profileRequest = new Profile();

  List<DoctorListResponse> get inActiveDoctorList => _inActiveDoctorList;

  List<FilterModel> filterOptionList = [
    new FilterModel(0, true, 'All'),
    new FilterModel(1, false, 'Home'),
    new FilterModel(2, false, 'At Clinic'),
    new FilterModel(3, false, 'Teleconsultation'),
  ];
  bool isFromSpecialization = false;
  String specialist = "";
  AppointmentsViewModel(
      {this.isFromSpecialization = false, this.specialist = ""});

  Future getDoctorsList() async {
    try {
      setState(ViewState.Loading);
      var response = await _appointmentService.getAllDoctors();
      profileRequest.profilePicture =
          SessionManager.profileImageUrl ?? "String";
      if (response.hasError ?? false) {
        _dialogService.showDialog(
            DialogType.ErrorDialog, message, response.message, "", done);
      } else {
        List data = response.result as List;
        data.forEach((element) {
          _doctorList.add(DoctorListResponse.fromMap(element));
        });
        _activeDoctorList.addAll(
            _doctorList.where((e) => e.tag != null && e.tag == "1").toList());

        if (isFromSpecialization) {
          if (specialist == 'Teleconsultation') {
            _tempDoctorList = _activeDoctorList
                .where((e) =>
                    e.scheduleV2?.any((schedule) =>
                        schedule.typeConsultation ==
                        TypeConsultation.TELECONSULTATION) ??
                    false)
                .toList();
          } else if (specialist == 'Home') {
            _tempDoctorList = _activeDoctorList
                .where((e) =>
                    e.scheduleV2?.any((schedule) =>
                        schedule.typeConsultation == TypeConsultation.HOME) ??
                    false)
                .toList();
          } else if (specialist == 'In-clinic') {
            _tempDoctorList = _activeDoctorList
                .where((e) =>
                    e.scheduleV2?.any((schedule) =>
                        schedule.typeConsultation ==
                        TypeConsultation.INCLINIC) ??
                    false)
                .toList();
          }
          filterOptionList.forEach(
            (element) {
              if (element.name == specialist)
                element.status = true;
              else
                element.status = false;
            },
          );
        } else {
          _tempDoctorList = _tempDoctorList;
        }
        setState(ViewState.Completed);

        // var inActiveList = _doctorList
        //     .where((element) => element.schedule != null
        //         ? element.schedule!.fromDate!.isBefore(DateTime.now())
        //         : element.schedule == null)
        //     .toList();
        // var activeList = _doctorList
        //     .where((element) =>
        //         element.schedule != null && element.professional != null
        //             ? element.schedule!.toDate!.isAfter(DateTime.now())
        //             : element.deviceToken == "1")
        //     .toList();
        //
        // _activeDoctorList = activeList;
        // if (isFromSpecialization) {
        //   _activeDoctorList = activeList
        //       .where((element) =>
        //           element.professional!.appointmentType!.contains(specialist) ==
        //           true)
        //       .toList();
        //   filterOptionList.forEach(
        //     (element) {
        //       if (element.name == specialist)
        //         element.status = true;
        //       else
        //         element.status = false;
        //     },
        //   );
        // }
        // _tempDoctorList = activeList;
        // _inActiveDoctorList = inActiveList;
        //
        // if (_activeDoctorList.isNotEmpty)
        //   //   setState(ViewState.Empty);
        //   // else
        //   setState(ViewState.Completed);
        // else
        //   setState(ViewState.Empty);ViewState
      }
    } catch (e) {
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  searchFilter(String chr) {
    if (chr.isEmpty)
      _tempDoctorList = _activeDoctorList;
    else
      _tempDoctorList = _activeDoctorList
          .where((element) =>
              element.firstname?.toLowerCase().contains(chr.toLowerCase()) ==
              true)
          .toList();
    notifyListeners();
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
          _tempDoctorList = _activeDoctorList;
        }
        break;
      case 'Home':
        {
          _tempDoctorList = _activeDoctorList
              .where((e) =>
                  e.scheduleV2?.any((schedule) =>
                      schedule.typeConsultation == TypeConsultation.HOME) ??
                  false)
              .toList();
        }
        break;
      case 'At Clinic':
        {
          _tempDoctorList = _activeDoctorList
              .where((e) =>
                  e.scheduleV2?.any((schedule) =>
                      schedule.typeConsultation == TypeConsultation.INCLINIC) ??
                  false)
              .toList();
        }
        break;
      case 'Teleconsultation':
        {
          _tempDoctorList = _activeDoctorList
              .where((e) =>
                  e.scheduleV2?.any((schedule) =>
                      schedule.typeConsultation ==
                      TypeConsultation.TELECONSULTATION) ??
                  false)
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
