import 'package:flutter/material.dart';
import 'package:life_eazy/models/appointments/appointment_request.dart';
import 'package:life_eazy/models/appointments/doctor_details_response.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

import '../../enums/viewstate.dart';
import '../../get_it/locator.dart';
import '../../models/family_members/get_family_members_response.dart';
import '../../net/session_manager.dart';
import '../../services/family_members/family_members_services.dart';

class DoctorAppointmentBookingSlotsViewModel extends CustomBaseViewModel {
  bool isMemberSelected = false;
  var _familyMemberServices = locator<FamilyMembersServices>();
  List<GetFamilyMemberResponse> _familyMemberList = [];

  List<GetFamilyMemberResponse> get familyMemberList => _familyMemberList;
  String? _consultancyType;

  TextEditingController symptomTextController = TextEditingController(text: '');
  TextEditingController commentTextController = TextEditingController(text: '');

  String? get consultancyType => _consultancyType;

  set consultancyType(value) => _consultancyType = value;

  String _patientName =
      "${SessionManager.getUser.firstName} ${SessionManager.getUser.lastName}";
  String? get patientName => _patientName;
  set patientName(value) => _patientName = value;

  GetFamilyMemberResponse selectedFamilyMember = new GetFamilyMemberResponse();

  List<TimeSlotsModel> timeSlotsList = [];
  DoctorDetailResponse doctorDetailResponse;
  DateTime selectedDate = DateTime.now();
  AppointmentRequest appointmentRequest = new AppointmentRequest();

  DoctorAppointmentBookingSlotsViewModel(this.doctorDetailResponse) {
    _consultancyType = doctorDetailResponse.professional?.appointmentType?[0];
    var fromTime =
        int.parse(doctorDetailResponse.schedule?.fromTIme?.split(':')[0] ?? "");
    var toTime =
        int.parse(doctorDetailResponse.schedule?.toTime?.split(':')[0] ?? "");

    var timeDiff = fromTime - toTime;
    var startingTime = fromTime;

    for (int i = 0; i < timeDiff.abs() * 2; i++) {
      if (startingTime > 24) startingTime = 0;

      timeSlotsList.add(new TimeSlotsModel(
          isSelected: false,
          value: (i % 2 == 0) ? (startingTime < 10 ? int.parse('0$startingTime') : startingTime): startingTime++,
          index: i,
          valueInMin: i % 2 == 0 ? '00' : '30',
          isAvailable: true));
    }

    if (isSameDate(DateTime.now(), selectedDate)) {
      int currentIndex = 0;
      timeSlotsList.forEach((timeElement) {
        if (timeElement.value! <= DateTime.now().hour) {
          timeElement.isAvailable = false;
          currentIndex = timeElement.index! + 1;
        }
        if (currentIndex == timeElement.index) timeElement.isSelected = true;
      });
    }
    doctorDetailResponse.appointments!.forEach((element) {
      if (isSameDate(element.date ?? DateTime.now(), selectedDate)) {
        timeSlotsList.forEach((timeElement) {
          if ('${timeElement.value}:${timeElement.valueInMin}' ==
              '${element.time!.split(':').first}:${element.time!.split(':')[1]}') {
            timeElement.isAvailable = false;
          }
        });
      }
    });
  }

  bool isSameDate(DateTime first, DateTime other) {
    if (first.year == other.year &&
        first.month == other.month &&
        first.day == other.day) return true;

    return false;
  }

  Future getFamilyMembersList() async {
    try {
      setState(ViewState.Loading);
      var response = await _familyMemberServices
          .getFamilyMembersList(SessionManager.getUser.id ?? 0);
      if (response.hasError ?? false) {
        // _dialogService.showDialog(DialogType.ErrorDialog, message,
        //     response.message ?? somethingWentWrong, "", done);
        setState(ViewState.Completed);
      } else {
        var data = response.result as List;
        data.forEach((element) {
          _familyMemberList.add(GetFamilyMemberResponse.fromMap(element));
        });

        _familyMemberList.reversed;
        selectedFamilyMember = _familyMemberList.first;
        setState(ViewState.Completed);
      }
    } catch (e) {
      // _dialogService.showDialog(
      //     DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  int? getConsultancyFess() {
    if (_consultancyType == "Teleconsultation")
      return doctorDetailResponse.schedule?.teleconsultationFees;
    else if (_consultancyType == "Home")
      return doctorDetailResponse.schedule?.homeFees;
    else
      return doctorDetailResponse.schedule?.inclinicFees;
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    timeSlotsList.forEach((timeElement) {
      timeElement.isAvailable = true;
    });
    if (isSameDate(DateTime.now(), selectedDate)) {
      int currentIndex = 0;
      timeSlotsList.forEach((timeElement) {
        if (timeElement.value! < DateTime.now().hour) {
          timeElement.isAvailable = false;
          currentIndex = timeElement.index! + 1;
        }
        if (currentIndex == timeElement.index)
          timeElement.isSelected = true;
        else
          timeElement.isSelected = false;
      });
    }

    doctorDetailResponse.appointments!.forEach((element) {
      if (element.date!.compareTo(selectedDate) == 0) {
        timeSlotsList.forEach((timeElement) {
          if (timeElement.value == int.parse(element.time!.split(':').first)) {
            timeElement.isAvailable = false;
          }
        });
      }
    });
    notifyListeners();
  }

  void selectTimeSlots(int index) {
    timeSlotsList.forEach((element) {
      if (element.index == index)
        element.isSelected = true;
      else
        element.isSelected = false;
    });

    notifyListeners();
  }

  void reload() {
    notifyListeners();
  }

  assignSymptomandComment(String symptom, String comment) {
    symptomTextController.text = symptom;
    commentTextController.text = comment;
    notifyListeners();
  }
}

class TimeSlotsModel {
  bool? isSelected = false;
  int? value = 0;
  String? valueInMin = '';
  int? index;
  bool? isAvailable = true;

  TimeSlotsModel(
      {this.isSelected,
      this.value,
      this.index,
      this.isAvailable,
      this.valueInMin});
}
