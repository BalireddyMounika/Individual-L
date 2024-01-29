import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/snackbar_types.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/authentication/location_response_model.dart';
import 'package:life_eazy/models/authentication/registration_update_model.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/profile/get_profile_response.dart';
import 'package:life_eazy/models/profile/user_profile_address_request.dart';
import 'package:life_eazy/models/profile/user_profile_request.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/prefs/local_storage_services.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/authentication/auth_servcices.dart';
import 'package:life_eazy/services/common_service/common_api/common_api_service.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/services/profile/profile_service.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

import '../../enums/profile_image_state.dart';
import '../../models/authentication/login_response_model.dart';
import '../../models/profile/user_profile_update_request.dart';



class ProfileViewModel extends CustomBaseViewModel {
  var _profileService = locator<ProfileService>();
  var _authService = locator<AuthService>();


  var _dialogService = locator<DialogService>();
  var navigationService = locator<NavigationService>();
  var _commonService = locator<CommonApiService>();
  var _prefs = locator<LocalStorageService>();

  TextEditingController firstName = new TextEditingController(text: "");
  TextEditingController addressController = new TextEditingController(text: "");
  TextEditingController phoneController = new TextEditingController(text: "");
  TextEditingController zipController = new TextEditingController(text: "");
  TextEditingController lastName = new TextEditingController(text: "");
  TextEditingController countryController = new TextEditingController(text: "");
  TextEditingController cityController = new TextEditingController(text: "");
  TextEditingController stateController = new TextEditingController(text: "");
  TextEditingController email = new TextEditingController(text: "");
  UserProfileRequest profileRequest = new UserProfileRequest();

  String profileDate = "";

  String loaderMsg = "";
  bool isEditProfile = false;
  bool isEditAddress = false;

  var titleList = ["Mr.", "Mrs.", "Miss.","Baby","Master"];
  var martialList = ["Martial Status", "Married", "Divorced","Not Disclosing"];
  var bloodGroupList = ["Blood Group","A+","A-","B+","B-","AB+","AB-", "O+","O-","Don't Know"];

  var genderList = ["Male", "Female", "Others"];

  int selectedTitle = 0;
  int selectedMartialStatus = 0;
  int selectedGender = 0;
  int selectedBloodGroup = 0;

  GetProfileResponse getProfileResponse = new GetProfileResponse();
  UserProfileRequest userProfileRequest = new UserProfileRequest();

  ProfileViewModel()
  {

  }



    multiApiCall()
   {
     Future.wait([addUserProfile(), updateRegistration()  ]);
   }

  Future updateRegistration()async
  {
    var response = GenericResponse();

    try
    {
      var request =  new RegistrationUpdateModel(

        firstname: firstName.text,
        lastname: lastName.text,
        email: email.text,
        username: SessionManager.getUser.username,
        mobileNumber: SessionManager.getUser.mobileNumber
      );
     var response = await _authService.updateRegistration(request);

     if(response.hasError == false)
       {
         SessionManager.setUser = new LoginResponseModel(
             id: SessionManager.getUser.id,
             firstName: firstName.text,
             lastName: lastName.text,
             email: email.text,
             mobileNumber: SessionManager.getUser.mobileNumber,
             username: SessionManager.getUser.username,
             profile: SessionManager.getUser.profile
         );
         _prefs.setUserModel(SessionManager.getUser.toJson());
       }
    }
    catch(e)
    {

    }
  }
  Future addUserProfile() async {


    loaderMsg = "Adding User Profile";
    setState(ViewState.Loading);
    try {
      profileRequest.profilePicture = SessionManager.profileImageUrl??"string";
      var response = await _profileService.postUserProfile(
          new UserProfileRequest(
              userId: SessionManager.getUser.id,
              title: titleList[selectedTitle],
              bloodGroup: bloodGroupList[selectedBloodGroup],
              martialStatus: martialList[selectedMartialStatus],
              gender: genderList[selectedGender],
              dob: profileDate,
              profilePicture: SessionManager.profileImageUrl!.isEmpty ? "https://vfydevexperiments.s3.amazonaws.com/dummy_icon.png" :SessionManager.profileImageUrl));

      if (response.hasError ?? false) {
        _prefs.setProfileImage(SessionManager.profileImageUrl??"");
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
      } else {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.SuccessDialog, message,
            "Profile Successfully added", Routes.dashboardView, done);
        setState(ViewState.Completed);
      }
    } catch (error) {
      setState(ViewState.Completed);
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  Future addUserProfileAddress() async {
    loaderMsg = "Adding User Address Data";
    setState(ViewState.Loading);
    try {
      var userProfileRequest = new UserProfileAdressRequest(
          address: addressController.text,
          country: countryController.text,
          state: stateController.text,
          city: "Visakhapatnam",
          zipCode: int.parse(zipController.text),
          primaryNumber: phoneController.text,
          userId: SessionManager.getUser.id);
      var response =
          await _profileService.postUserProfileAddress(userProfileRequest);

      if (response.hasError ?? false) {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
      } else {
        setState(ViewState.Completed);
        SessionManager.userAdress = userProfileRequest;
        _dialogService.showDialog(DialogType.SuccessDialog, message,
            "Profile's Address Successfully added", Routes.dashboardView, done);

        setState(ViewState.Completed);
      }
    } catch (error) {
      setState(ViewState.Completed);
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  Future updateUserProfile() async {
    loaderMsg = "Updating User Profile";
    setState(ViewState.Loading);
    try {
      var response = await _profileService.updateUserProfile(
          new UserProfileUpdateRequest(
              userId: new UserId(
                // firstname: SessionManager.getUser.firstName,
                // lastname: SessionManager.getUser.lastName,
                // email: SessionManager.getUser.email,
                firstname: firstName.text,
               lastname: lastName.text,
               email: email.text,
              ),
              title: titleList[selectedTitle],
              bloodGroup: bloodGroupList[selectedBloodGroup],
              martialStatus: martialList[selectedMartialStatus],
              gender: genderList[selectedGender],
              dob: profileDate,
              profilePicture: SessionManager.profileImageUrl ?? ""),
          getProfileResponse.profile!.id ?? 0);

      if (response.hasError ?? false) {
        setState(ViewState.Completed);
        _prefs.setProfileImage(SessionManager.profileImageUrl??"");
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
      } else {
        setState(ViewState.Completed);
        _prefs.setProfileImage(SessionManager.profileImageUrl??"");
        SessionManager.setUser = new LoginResponseModel(
            id: SessionManager.getUser.id,
            firstName: firstName.text,
            lastName: lastName.text,
            email: email.text,
            mobileNumber: SessionManager.getUser.mobileNumber,
            username: SessionManager.getUser.username,
            profile: SessionManager.getUser.profile
        );
        _prefs.setUserModel(SessionManager.getUser.toJson());

        _dialogService.showDialog(DialogType.SuccessDialog, message,
            "Profile Successfully updated", Routes.dashboardView, done);
        setState(ViewState.Completed);
      }
    } catch (error) {
      setState(ViewState.Completed);
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  Future updateProfileAddress() async {
    loaderMsg = "Adding User Address Data";
    setState(ViewState.Loading);
    try {
      var userProfileRequest = new UserProfileAdressRequest(
          address: addressController.text,
          country: countryController.text,
          state: stateController.text,
          city: cityController.text,
          zipCode: int.parse(zipController.text),
          primaryNumber: phoneController.text,
          userId: SessionManager.getUser.id);
      var response = await _profileService.updateUserProfileAddress(userProfileRequest, SessionManager.getUser.id ?? 0);

      if (response.hasError ?? false) {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
      } else {
        setState(ViewState.Completed);
        SessionManager.userAdress = userProfileRequest;
        _dialogService.showDialog(
            DialogType.SuccessDialog,
            message,
            "Profile's Address Successfully updated",
            Routes.dashboardView,
            done);

        setState(ViewState.Completed);
      }
    } catch (error) {
      setState(ViewState.Completed);
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }

  Future getProfile() async {
    try{
      loaderMsg = "Getting User Profile";
      setState(ViewState.Loading);
      var response =
          await _profileService.getProfile(SessionManager.getUser.id ?? 0);
      if (response.hasError ?? false) {
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", done);
        setState(ViewState.Completed);
      } else {
        var data = response.result as Map<String, dynamic>;
        getProfileResponse = GetProfileResponse.fromMap(data);
        if (getProfileResponse.profile != null) {
          SessionManager.profileImageUrl =
              getProfileResponse.profile!.profilePicture ?? "";

        }
        if (SessionManager.profileImageUrl!.isNotEmpty) {
          setProfileState(ProfileImageState.Completed);
          _prefs.setProfileImage( getProfileResponse.profile!.profilePicture??"");
        }

        initData();
        setState(ViewState.Completed);
      }
    } catch (e) {
      // locator<SnackBarService>().showSnackBar(
      //   title: somethingWentWrong,
      //   snackbarType: SnackbarType.warning
      // );
      setState(ViewState.Completed);
    }
  }

  Future addUserProfileImage(File file) async {
    try {
      profileRequest.profilePicture = SessionManager.profileImageUrl;
      setProfileState(ProfileImageState.Loading);
      var response = await _commonService.postImage(file);
      if (response.hasError == false) {
        var data = response.result as Map<String, dynamic>;
        var image = data["Image"];

        SessionManager.profileImageUrl = image;
        setProfileState(ProfileImageState.Completed);
      } else {
        SessionManager.profileImageUrl = "https://picsum.photos/id/237/200/300";
        setProfileState(ProfileImageState.Error);
      }
    } catch (e) {
      setProfileState(ProfileImageState.Error);
    }
  }

  void setProfileDate(DateTime? date) {
    profileDate = date.toString().split(' ').first;
    notifyListeners();
  }

  void reload() {
    notifyListeners();
  }

  void initData() {
    if (getProfileResponse.address == null) {
      isEditAddress = false;
    } else {
      isEditAddress = true;
      addressController.text = getProfileResponse!.address!.address ?? "";
      stateController.text = getProfileResponse!.address!.state! ?? "";
      cityController.text = getProfileResponse!.address!.city! ?? '';
      countryController.text = getProfileResponse!.address!.country! ?? '';
      zipController.text =
          getProfileResponse!.address!.zipCode.toString() ?? "";
      phoneController.text = getProfileResponse!.address!.primaryNumber ?? "";
    }

    if (getProfileResponse.profile == null) {
      isEditProfile = false;
    } else {
      isEditProfile = true;

      firstName.text = getProfileResponse.firstname ?? "";
      lastName.text = getProfileResponse.lastname ?? "";
      email.text = getProfileResponse.email??"";

      SessionManager.setUser = new LoginResponseModel(
        id: SessionManager.getUser.id,
        firstName: firstName.text,
        lastName: lastName.text,
        email: email.text,
        mobileNumber: SessionManager.getUser.mobileNumber,
        username: SessionManager.getUser.username,
        profile: SessionManager.getUser.profile
      );


      profileDate = getProfileResponse.profile!.dob!.split(' ').first ?? "";
      for(int i=0 ;i <titleList.length;i++)
        {
          if(titleList[i] ==  getProfileResponse.profile!.title) {
            selectedTitle = i;
          break;
          }

        }
      for(int i=0 ;i < bloodGroupList.length;i++)
      {
        if(bloodGroupList[i] ==  getProfileResponse.profile!.bloodGroup) {
          selectedBloodGroup = i;
          break;
        }

      }
      for(int i=0 ;i <genderList.length;i++)
      {
        if(genderList[i] ==  getProfileResponse.profile!.gender) {
          selectedGender = i;
          break;
        }

      }
      for(int i=0 ;i <martialList.length;i++)
      {
        if(martialList[i] ==  getProfileResponse.profile!.martialStatus) {
          selectedMartialStatus = i;
          break;
        }

      }


    }
  }

  Future updateLocation( var data)async{
    if(data!=null) {
      var s = data;
      var country = "";
      var state = "";
      var city = "";
      var address = "";
      var length = s!.split(',').length;
      for (int i = length; i >= 0; i--) {
        country = s!.split(',')[length - 1];
        if (length > 1)
          state = s!.split(',')[length - 2];
        if (length > 2)
          city = s!.split(',')[length - 3];

        if (i < length - 3)
          address = s!.split(',')[i] + "," + address;
      }


      SessionManager.setLocation = new LocationResponseModel(
          lat: 00.0,
          long: 00.0,
          city: city,
          country: country,
          pinCode: 0,
          state: state,
          address: address.isEmpty ? "$state,$country" : "$address $city $country"
      );
      addressController.text = data ;

      // data = data.split(',').first;

    }
    addressController.text = SessionManager.getLocation.address! ;
    cityController.text = SessionManager.getLocation.city!;
    countryController.text = SessionManager.getLocation.country!;
    stateController.text = SessionManager.getLocation.state!;
    locator<LocalStorageService>().setLocation(SessionManager.getLocation.toJson());
    notifyListeners();
  }
}

