import 'package:flutter/material.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/snackbar_types.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/vitals/get_vital_response.dart';
import 'package:life_eazy/models/vitals/post_vital_request.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/services/vitals/vitals_seirvice.dart';
import '../../models/family_members/get_family_members_response.dart';
import '../../services/family_members/family_members_services.dart';
import '../base_viewmodel.dart';

class VitalsViewModel extends CustomBaseViewModel {
  List<VitalsOptionModel> vitalOptionList = [
    VitalsOptionModel(
        index: 0, name: 'Temperature', isChecked: false, key: "Temperature"),
    VitalsOptionModel(index: 1, name: 'Pulse', isChecked: false, key: "Pulse"),
    VitalsOptionModel(index: 2, name: 'Spo2', isChecked: false, key: "Spo2"),
    VitalsOptionModel(
        index: 3, name: 'Blood Pressure', isChecked: false, key: "BP"),
    VitalsOptionModel(
        index: 4, name: 'Height', isChecked: false, key: "Height"),
    VitalsOptionModel(
        index: 5, name: 'Weight', isChecked: false, key: "Weight"),
    VitalsOptionModel(index: 6, name: 'BMI', isChecked: false, key: "BMI"),
  ];

  List<VitalsViewModel> isSelectedVitalsList = [];
  var _familyMemberServices = locator<FamilyMembersServices>();

  List<GetFamilyMemberResponse> _familyMemberList = [];

  List<GetFamilyMemberResponse> get familyMemberList => _familyMemberList;

  List<DropdownButton> familyMemberListForDropdown = [];
  GetFamilyMemberResponse selectedFamilyMember = new GetFamilyMemberResponse();

  List<dynamic> data = [];
  Map<String, String> updatedDateVitals = Map();

  bool temperatureValue = false;
  bool initialValue = false;

  TextEditingController systolicTextController = TextEditingController();
  TextEditingController diastolicTextController = TextEditingController();

  var _vitalService = locator<VitalService>();
  var _snackBarService = locator<SnackBarService>();
  GetVitalResponse vitalResponse = new GetVitalResponse();
  String currentSelectedMember = 'My Self';
  var vitalData = GetVitalResponse();
  String loadingMsg = "";

  // GetVitalResponse _getvitalResponse = new GetVitalResponse();
  bool isEdit = false;
  List<dynamic> _vitalList = [];
  List<GetVitalResponse> _filteredVitalList = [];

  List<dynamic> get vitalList => _vitalList;

  List<GetVitalResponse> get filteredVitalList => _filteredVitalList;
  List<GetVitalResponse> temp = [];
  bool isFamilyMemberSelected = false;
  PostVitalRequest postvitalRequest = PostVitalRequest(
      height: 0, weight: 0, bmi: 0, temperature: "0", spo2: 0, pulse: 0, bp: 0 , systolic:0 , diastolic: 0);
  GetVitalResponse getvitalResponse = GetVitalResponse(
      height: 0, weight: 0, bmi: 0, temperature: "0", spo2: 0, pulse: 0, bp: 0 , systolic: 0 , diastolic: 0);

  GetVitalResponse fillVitals = GetVitalResponse(
      height: 0,
      weight: 0,
      bmi: 0,
      temperature: "0",
      spo2: 0,
      pulse: 0,
      bp: 0,
      systolic: 0,
      diastolic: 0,
      updatedOn: "NA");

  List<Map<String, String>> reOrderedList = [];

  VitalsViewModel();

  VitalsViewModel.edit(this.vitalResponse, this.isEdit);

  void changeInitialValueToNewValue(value, index) {
    vitalOptionList.forEach((element) {
      if (index == element.index) element.isChecked = value;
    });
    notifyListeners();
  }

  checkValidation(value) {
    if (value!.isEmpty) {
      return "filed cant be empty";
    }
  }

  Future getFamilyMembersList() async {
    try {
      setState(ViewState.Loading);
      var response = await _familyMemberServices
          .getFamilyMembersList(SessionManager.getUser.id ?? 0);
      if (response.hasError ?? false) {
        // _dialogService.showDialog(DialogType.ErrorDialog, message,
        //     response.message ?? somethingWentWrong, "", done);
        await getVitalByUserId();
        // setState(ViewState.Completed);
      } else {
        var data = response.result as List;
        data.forEach((element) {
          _familyMemberList.add(GetFamilyMemberResponse.fromMap(element));
        });

        _familyMemberList.reversed;
        selectedFamilyMember = _familyMemberList.first;
        await getVitalByUserId();

      }
    } catch (e) {
      // _dialogService.showDialog(
      //     DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  Future getVitalByUserId() async {
    try {
      loadingMsg = "Fetching Vitals";
      setState(ViewState.Loading);

      var response =
          await _vitalService.getVitalInfo(SessionManager.getUser.id ?? 0);

      if (response.hasError == true) {
        setState(ViewState.Empty);
      } else {
        isFamilyMemberSelected = false ;
        data = response.result as List;
        _vitalList = data;
        data = _vitalList
            .where((element) => element["FamilyMemberId"] == null)
            .toList();
        if (data.length >= 1) {
          _fillData(data);
          setState(ViewState.Completed);
        } else
          setState(ViewState.Empty);
      }
    } catch (e) {
      setState(ViewState.Empty);
    }
  }

  void _fillData(data) {
    for (int i = data.length - 1; i >= 0; i--) {
      var vitalData = GetVitalResponse.fromMap(data[i]);
      if (vitalData.height != 0 && fillVitals.height == 0) {
        fillVitals.height = vitalData.height;
        updatedDateVitals["Height"] = vitalData.updatedOn ?? "NA";
      }
      if (vitalData.spo2 != 0 && fillVitals.spo2 == 0) {
        fillVitals.spo2 = vitalData.spo2;
        updatedDateVitals["Spo2"] = vitalData.updatedOn ?? "NA";
      }
      if (vitalData.weight != 0 && fillVitals.weight == 0) {
        fillVitals.weight = vitalData.weight;
        updatedDateVitals["Weight"] = vitalData.updatedOn ?? "NA";
      }
      if (vitalData.bmi != 0 && fillVitals.bmi == 0) {
        fillVitals.bmi = vitalData.bmi;
        updatedDateVitals["BMI"] = vitalData.updatedOn ?? "NA";
      }
      if (vitalData.systolic != 0 && fillVitals.systolic == 0) {
        fillVitals.systolic = vitalData.systolic;
        updatedDateVitals["systolic"] = vitalData.updatedOn ?? "NA";
      }
      if (vitalData.diastolic != 0 && fillVitals.diastolic == 0) {
        fillVitals.diastolic = vitalData.diastolic;
        updatedDateVitals["diastolic"] = vitalData.updatedOn ?? "NA";
      }
      if (vitalData.pulse != 0 && fillVitals.pulse == 0) {
        fillVitals.pulse = vitalData.pulse;
        updatedDateVitals["Pulse"] = vitalData.updatedOn ?? "NA";
      }
      if (vitalData.temperature != "0" && fillVitals.temperature == '0') {
        fillVitals.temperature = vitalData.temperature;
        updatedDateVitals["Temperature"] = vitalData.updatedOn ?? "NA";
      }
      if (vitalData.bp != 0 && fillVitals.bp == 0) {
        fillVitals.bp = vitalData.bp;
        updatedDateVitals["BP"] = vitalData.updatedOn ?? "NA";
      }
    }
  }

  void refreshUi() {
    notifyListeners();
  }

  handleBottomBar(){
    isFamilyMemberSelected = true;
    updateVitalsByCurrentSelectedMember(index: 0);
    notifyListeners();
  }

  updateVitalsByCurrentSelectedMember({index}) {
    var data = [];
    fillVitals = GetVitalResponse(
        height: 0,
        weight: 0,
        bmi: 0,
        temperature: "0",
        spo2: 0,
        pulse: 0,
        bp: 0,
      systolic: 0,
      diastolic: 0,
    );

    if (index == null) {
      selectedFamilyMember = familyMemberList.first;
      data = _vitalList
          .where((element) => element["FamilyMemberId"] == null)
          .toList();
    } else {
      selectedFamilyMember = familyMemberList[index];
      data = _vitalList
          .where(
              (element) => element["FamilyMemberId"] == selectedFamilyMember.id)
          .toList();
    }

    if (data.length >= 1) {
      _fillData(data);
      setState(ViewState.Completed);
    } else
      setState(ViewState.Empty);
  }

  Future postVitalInfo() async {
    try {
      loadingMsg = "Adding Vitals";
      setState(ViewState.Loading);
      postvitalRequest.userId = SessionManager.getUser.id ?? 0;

      var response = await _vitalService.postVitalInfo(postvitalRequest);
      if (response.statusCode == 200) {
        locator<NavigationService>()
            .navigateToAndRemoveUntil(Routes.vitalsView);
        _snackBarService.showSnackBar(
            title: response.message ?? somethingWentWrong,
            snackbarType: SnackbarType.success);
      } else {
        setState(ViewState.Completed);
        _snackBarService.showSnackBar(
            title: response.message ?? somethingWentWrong,
            snackbarType: SnackbarType.error);
      }
    } catch (e) {
      setState(ViewState.Completed);
      _snackBarService.showSnackBar(
          title: somethingWentWrong, snackbarType: SnackbarType.error);
    }
  }
}

class VitalsOptionModel {
  int? index;
  String? name;

  bool isChecked;
  String? key;

  VitalsOptionModel({this.index, this.name, this.isChecked = false, this.key});
}
