

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/family_members/get_family_members_response.dart';
import 'package:life_eazy/models/family_members/user_family_member_address_request.dart';
import 'package:life_eazy/models/family_members/user_famliy_member_request.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/common_api/common_api_service.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/services/family_members/family_members_services.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

import '../../enums/profile_image_state.dart';


class FamilyMembersViewModel extends CustomBaseViewModel {
  var _familyMemberServices = locator<FamilyMembersServices>();
  var _dialogService = locator<DialogService>();
  var navigationService = locator<NavigationService>();
  var _commonService = locator<CommonApiService>();
  var loaderMsg = "";
  static var tempFamilyMemberId = 0;
  var isEmergency = false;
  String profileImage = "";

  TextEditingController firstName = new TextEditingController(text: "");
  TextEditingController addressController = new TextEditingController(text: "");
  TextEditingController phoneController = new TextEditingController(text: "");
  TextEditingController zipController = new TextEditingController(text: "");
  UserFamilyMemberRequest profileRequest = new UserFamilyMemberRequest();
  TextEditingController firstNameController =
      new TextEditingController(text: "");
  TextEditingController lastNameController =
      new TextEditingController(text: "");
  TextEditingController relationShipController =
      new TextEditingController(text: "");
  TextEditingController lastName = new TextEditingController(text: "");

  UserFamilyMemberRequest familyMemberInfoRequest =
      new UserFamilyMemberRequest();
  UserFamilyMemberAddressRequest familyMemberAddressRequest =
      new UserFamilyMemberAddressRequest();
  var profileDateController = new TextEditingController(text: "");

  var titleList = ["Mr.", "Mrs.", "Miss."];
  var martialList = ["Martial Status","Single", "Married", "Divorced","Not Disclosing"];
  List<String> bloodGroup = ["Blood Group","A+","A-","B+","B-","AB+","AB-", "O+","O-","Don't Know"];

  var genderList = ["Male", "Female", "Others"];
  var familyTypeList = ["ADULT" , "CHILD"];

  int selectedTitle = 0;
  int selectedMartialStatus = 0;
  int selectedGender = 0;
  int selectedBloodGroup = 0;
  int selectedFamilyType =0;

  bool isEdit = false;
  List<GetFamilyMemberResponse> _familyMemberList = [];

  List<GetFamilyMemberResponse> get familyMemberList => _familyMemberList;
  GetFamilyMemberResponse _response = new GetFamilyMemberResponse();

  FamilyMembersViewModel();


  FamilyMembersViewModel.edit(GetFamilyMemberResponse response, this.isEdit) {
    firstName.text = response.firstName ?? "";
    lastName.text = response.lastName ?? "";
    tempFamilyMemberId = response.id ?? 0;
    if (_response.familyMemberAddress != null) {
      addressController.text = response.familyMemberAddress!.address ?? "";
      phoneController.text = response.familyMemberAddress!.primaryNumber ?? "";
      zipController.text =
          response.familyMemberAddress!.zipCode.toString() ?? "";
    }
    relationShipController.text = response.relationshipToPatient ?? "";
    profileDateController.text = response.dob!.split(' ').first;
    profileImage = response.profilePicture??"";
    setProfileState(ProfileImageState.Completed);

    isEmergency = response.isEmergency ?? false;
    _response = response;
  }

  Future getFamilyMembersList() async {
    try {
      setState(ViewState.Loading);
      var response = await _familyMemberServices
          .getFamilyMembersList(SessionManager.getUser.id ?? 0);
      if (response.hasError ?? false) {

        setState(ViewState.Completed);
      } else {
        var data = response.result as List;
        data.forEach((element) {
          _familyMemberList.add(GetFamilyMemberResponse.fromMap(element));
        });

        _familyMemberList.reversed;
        setState(ViewState.Completed);
      }
    } catch (e) {
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Error);
    }
  }

  Future addFamilyMembersInfo() async {
    loaderMsg = "Adding Member";
    setState(ViewState.Loading);
    try {
      var response = await _familyMemberServices
          .addFamilyMembers(new UserFamilyMemberRequest(
        userId: SessionManager.getUser.id,
        title: titleList[selectedTitle],
        bloodGroup: bloodGroup[selectedBloodGroup],
        martialStatus: martialList[selectedMartialStatus],
        gender: genderList[selectedGender],
        dob: profileDateController.text,
        firstname: firstName.text,
        lastname: lastName.text,
        email: SessionManager.getUser.email,
        age: (DateTime.now().difference( DateTime.parse(profileDateController.text)).inDays/365).floor(),
        relationshipToPatient: relationShipController.text,
        familyMemberType: familyTypeList[selectedFamilyType],
        profilePicture: profileImage == "" ? "https://vfydevexperiments.s3.amazonaws.com/dummy_icon.png" : profileImage,
        isEmergency: this.isEmergency,
      ));

      tempFamilyMemberId = response.result["UserId"];
      if (response.hasError ?? false) {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
      } else {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.SuccessDialog, message,
            "Member Successfully added",   Routes.dependentInformationView, done,isStackedCleared: true);
        setState(ViewState.Completed);
      }
    } catch (error) {
      setState(ViewState.Completed);
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  Future addFamilyMemberAddress() async {
    loaderMsg = "Adding User Address Data";
    setState(ViewState.Loading);
    try {
      var familyMembersAddRequest = new UserFamilyMemberAddressRequest(
          address: addressController.text,
          country: "India",
          state: "AndhraPradesh",
          city: "Visakhapatnam",
          zipCode: int.parse(zipController.text),
          primaryNumber: phoneController.text,
          familyMemberId: tempFamilyMemberId);
      var response = await _familyMemberServices
          .addFamilyMembersAddress(familyMembersAddRequest);

      if (response.hasError ?? false) {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
      } else {
        setState(ViewState.Completed);
        _dialogService.showDialog(
            DialogType.SuccessDialog,
            message,
            "Profile's Address Successfully added",
            Routes.dependentInformationView,
            done,
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

  Future editFamilyMembersInfo() async {
    loaderMsg = "Updating Member Profile";
    setState(ViewState.Loading);
    try {
      var response = await _familyMemberServices.editFamilyMembers(
          new UserFamilyMemberRequest(
            userId: SessionManager.getUser.id,
            title: titleList[selectedTitle],
            bloodGroup: bloodGroup[selectedBloodGroup],
            martialStatus: martialList[selectedMartialStatus],
            gender: genderList[selectedGender],
            dob: profileDateController.text,
            firstname: firstName.text,
            lastname: lastName.text,
            familyMemberType: familyTypeList[selectedFamilyType],
            age: (DateTime.now().difference( DateTime.parse(profileDateController.text)).inDays/365).floor(),
            email: SessionManager.getUser.email,
            profilePicture: profileImage,
            relationshipToPatient: relationShipController.text,
            isEmergency: this.isEmergency,
          ),
          _response.id ?? 0);

      if (!isEdit) tempFamilyMemberId = response.result["UserId"];
      if (response.hasError ?? false) {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
      } else {
        setState(ViewState.Completed);
        _dialogService.showDialog(
            DialogType.SuccessDialog,
            message,
            "Member Successfully Updated",
            Routes.dependentInformationView,
            done,
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

  Future editFamilyMemberAddress() async {
    loaderMsg = "Updating User Address Data";
    setState(ViewState.Loading);
    try {
      var familyMembersAddRequest = new UserFamilyMemberAddressRequest(
          address: addressController.text,
          country: "India",
          state: "AndhraPradesh",
          city: "Visakhapatnam",
          zipCode: int.parse(zipController.text),
          primaryNumber: phoneController.text,
          familyMemberId: tempFamilyMemberId);
      var response = await _familyMemberServices.editFamilyMembersAddress(
          familyMembersAddRequest, _response.familyMemberAddress!.id ?? 0);

      if (response.hasError ?? false) {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
      } else {
        setState(ViewState.Completed);
        SessionManager.userAdress = familyMembersAddRequest;
        _dialogService.showDialog(
            DialogType.SuccessDialog,
            message,
            "Profile's Address Successfully updated",
            Routes.dependentInformationView,
            done,
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
  Future addUserProfileImage(file) async {
    try {

      setProfileState(ProfileImageState.Loading);
      var response = await _commonService.postImage(file);
      if (response.hasError == false) {
        var data = response.result as Map<String, dynamic>;
        var image = data["Image"];

        profileImage = image;
        setProfileState(ProfileImageState.Completed);
      } else {
       // SessionManager.profileImageUrl = "https://picsum.photos/id/237/200/300";
        setProfileState(ProfileImageState.Error);
      }
    } catch (e) {
      setProfileState(ProfileImageState.Error);
    }
  }

  void reload() {
    notifyListeners();
  }

  void setEmergency(value) {
    isEmergency = value;
    notifyListeners();
  }

  void setProfileDate(DateTime? date) {
    profileDateController.text = date.toString().split(' ').first;
    notifyListeners();
  }
}
