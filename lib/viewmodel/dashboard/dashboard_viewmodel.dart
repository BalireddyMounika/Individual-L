import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/profile_image_state.dart';
import 'package:life_eazy/enums/snackbar_types.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/appointments/vide_call_request_response.dart';
import 'package:life_eazy/models/authentication/location_response_model.dart';
import 'package:life_eazy/models/location/google_auto_complete_response.dart';
import 'package:life_eazy/models/profile/get_profile_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/prefs/local_storage_services.dart';
import 'package:life_eazy/services/appointments/appointment_services.dart';
import 'package:life_eazy/services/common_service/common_api/common_api_service.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/services/profile/profile_service.dart';

import '../base_viewmodel.dart';

class DashBoardViewModel extends CustomBaseViewModel {

  var _appointmentService = locator<AppointmentService>();
  var _dialogService = locator<DialogService>();
  var navigationService = locator<NavigationService>();
  var _commonService = locator<CommonApiService>();
  var _profileService = locator<ProfileService>();
  GetProfileResponse getProfileResponse = new GetProfileResponse();
  String loaderMsg = "";

  var _prefs = locator<LocalStorageService>();

  bool isRequestVisible =  false;
  String location = "Enter City or Locality";

  VideoCallRequestResponse callRequestResponse =    VideoCallRequestResponse();
  List<Predictions> _autoCompleteList = [];

  List<Predictions> get autoCompleteList => _autoCompleteList;

  String loadingMsg = "";
  List<Map<String,dynamic>> _specializationList = [];
  List<Map<String,dynamic>> get specializationList => _specializationList;

  DashBoardViewModel();

  initialiseData() {
    getVideoCallRequest();
    getProfile();
  }

  Future getProfile() async {
    try{
      loaderMsg = "Getting User Profile";
      setState(ViewState.Loading);
      var response =
      await _profileService.getProfile(SessionManager.getUser.id ?? 0);
      if (response.hasError ?? false) {
        locator<SnackBarService>().showSnackBar(
          title: somethingWentWrong,
          snackbarType: SnackbarType.info
        );
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


  Future getAutoComplete(String value)async {

    try {

      _autoCompleteList = [];
      setState(ViewState.Loading);
      var response =  await _commonService.getAutoCompleteSearch(value);

      var data = response.result["predictions"];

      var predictionList  =  data as List;

      predictionList.forEach((element) {

        _autoCompleteList.add(Predictions.fromMap(element));

      });

      if(  _autoCompleteList.length>=1)
        setState(ViewState.Completed);
      else
        setState(ViewState.Empty);

    }
    catch(e)
    {
      setState(ViewState.Error);
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
      
      _prefs.setLocation(SessionManager.getLocation.toJson());
      

      // data = data.split(',').first;

    }
    notifyListeners();
  }

  Future getVideoCallRequest() async
  {

    try
    {
       setState(ViewState.Loading);
     //  await  getAllSpecialization();
      var response =  await _appointmentService.getActiveVideoConference(SessionManager.getUser.id??0);
      if(response.hasError ==false)
        {

          var dataList = response.result as List;
          if(dataList.length>=1) {
            isRequestVisible = true;

            callRequestResponse =
                VideoCallRequestResponse.fromMap(dataList.first);
            setState(ViewState.Completed);
          }
          else
            {
              setState(ViewState.Completed);
            }

        }
      else
        {
          setState(ViewState.Completed);
        }



    }
    catch(e)
    {
      setState(ViewState.Completed);
    }

  }

  Future getAllSpecialization()async
  {
    var response = await _commonService.getSpecialisation();

    var data =  response.result as List;
    data.forEach((element) {
      _specializationList.add(element);
    });
  }

  Future getUserDetails()async
  {
    var response = await _commonService.getSpecialisation();

    var data =  response.result as List;
    data.forEach((element) {
      _specializationList.add(element);
    });
  }
}
