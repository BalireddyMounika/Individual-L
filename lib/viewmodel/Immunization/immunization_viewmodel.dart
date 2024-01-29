import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/models/immunization/getImmuinisationResponse.dart';
import 'package:life_eazy/models/immunization/post_immunisation_request.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/common_api/common_api_service.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

import '../../common_widgets/popup_dialog.dart';
import '../../constants/strings.dart';
import '../../enums/profile_image_state.dart';
import '../../get_it/locator.dart';
import '../../models/family_members/get_family_members_response.dart';
import '../../services/common_service/dialog_services.dart';
import '../../services/family_members/family_members_services.dart';
import '../../services/immunization/immunization_services.dart';
import '../../view/Immunization/immunization_usert_type_view.dart';

class ImmunizationViewModel extends CustomBaseViewModel {
  var genderList = ["Male", "Female", "Others"];
  int selectedGender = 0;
  GetFamilyMemberResponse currentSelectedMember = GetFamilyMemberResponse();
  bool isFamilyMemberSelected = false;
  var immunizationService = locator<ImmunizationService>();
  var _commonService = locator<CommonApiService>();
  var _dialogService = locator<DialogService>();
  var postImmunisationRequest = PostImmunizationRequests();
  List<GetImmunizationResponse> immunizationList = [];
  List<GetImmunizationResponse> selfImmunizationList = [];
  List<GetImmunizationResponse> filterImmunizationList = [];
  List<GetImmunizationResponse> temp = [];

  GetImmunizationResponse selectedImmunization = new GetImmunizationResponse();
  String selectedVaccine = "";
  ProfileImageState _profileState = ProfileImageState.Idle;

  var _familyMemberServices = locator<FamilyMembersServices>();
  List<GetFamilyMemberResponse> _familyMemberList = [];

  List<GetFamilyMemberResponse> get familyMemberList => _familyMemberList;

  getFamilyImmunizationList() {
    isFamilyMemberSelected = true;
    updateImmunizationByCurrentSelectedMember(0);
  }

  getSelfImmunizationList() {
    isFamilyMemberSelected = false;
    getImmunization();
  }

  onSelectingSelf() {
    isFamilyMemberSelected = false;
  }

  var immuneDateController = TextEditingController();
  String immuneDate = "";

  ImmunizationViewModel() {
    print(ImmunizationUserTypeView.familyMemberIDFromImmunization);
  }
  ImmunizationViewModel.add(this.selectedImmunization) {
    print(ImmunizationUserTypeView.familyMemberIDFromImmunization);
  }

  void reload() {
    notifyListeners();
  }

  updateImmunizationByCurrentSelectedMember(index) {
    if (index == -1) {
      currentSelectedMember = familyMemberList.first;
      isFamilyMemberSelected = false;
    } else {
      currentSelectedMember = familyMemberList[index];
      ImmunizationUserTypeView.familyMemberIDFromImmunization =
          currentSelectedMember.id ?? 0;
      isFamilyMemberSelected = true;
    }

    notifyListeners();
  }

  bool fromFamilyMembers(index) {
    if (immunizationList[index].immunizationId?.length == 0) return false;
    if (isFamilyMemberSelected == true &&
        immunizationList[index].immunizationId!.length >= 1) {
      if (immunizationList[index]
              .immunizationId!
              .where((element) => element.familyId == currentSelectedMember.id)
              .length >=
          1)
        return true;
      else
        return false;
    }
    if (isFamilyMemberSelected == false &&
        immunizationList[index].immunizationId!.isNotEmpty) {
      if (immunizationList[index]
          .immunizationId!
          .where((element) => element.familyId == null)
          .isNotEmpty) {
        return true;
      }
      return false;
    }

    return true;
  }

  Future getImmunization() async {
    try {
      setState(ViewState.Loading);
      var response = await immunizationService
          .getImmunizationByUserId(SessionManager.getUser.id ?? 0);

      if (response.hasError == false) {
        var data = response.result as List;

        print(data);

        data.forEach((element) {
          immunizationList.add(GetImmunizationResponse.fromMap(element));
        });

        selectedVaccine = immunizationList.first.vaccine ?? "";

        temp = immunizationList;
        setState(ViewState.Completed);
      } else {
        setState(ViewState.Error);
      }
    } catch (e) {
      setState(ViewState.Error);
    }
  }

  Future postImmunization() async {
    try {
      postImmunisationRequest.immunizationId = selectedImmunization.id ?? 0;
      postImmunisationRequest.userId = SessionManager.getUser.id;
      postImmunisationRequest.familyId =
          ImmunizationUserTypeView.familyMemberIDFromImmunization == 0
              ? null
              : ImmunizationUserTypeView.familyMemberIDFromImmunization;
      postImmunisationRequest.dateOfImmunization = immuneDate;
      postImmunisationRequest.doseTaken = "Yes";
      postImmunisationRequest.helpContent =
          selectedImmunization.whentogive ?? "";

      setState(ViewState.Loading);
      var response =
          await immunizationService.postImmunization(postImmunisationRequest);

      if (response.hasError == false) {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.SuccessDialog, message,
            response.message, Routes.immunizationView, done,
            isStackedCleared: true);
      } else {
        setState(ViewState.Completed);
        ImmunizationUserTypeView.familyMemberIDFromImmunization = 0;
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
        setState(ViewState.Completed);
      }
    } catch (e) {
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
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
        setState(ViewState.Completed);
      } else {
        var data = response.result as List;
        data.forEach((element) {
          _familyMemberList.add(GetFamilyMemberResponse.fromMap(element));
        });

        _familyMemberList.reversed;
        currentSelectedMember = _familyMemberList.first;
        setState(ViewState.Completed);
      }
    } catch (e) {
      // _dialogService.showDialog(
      //     DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  Future addDocument(File file) async {
    try {
      setProfileState(ProfileImageState.Loading);
      var response = await _commonService.postImage(file);
      if (response.hasError == false) {
        var data = response.result as Map<String, dynamic>;
        var image = data["Image"];
        postImmunisationRequest.uploadDocument = image;

        setProfileState(ProfileImageState.Completed);
      } else {
        setProfileState(ProfileImageState.Error);
      }
    } catch (e) {
      setProfileState(ProfileImageState.Error);
    }
  }
}
