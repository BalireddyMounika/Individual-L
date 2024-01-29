import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/authentication/login_request_model.dart';
import 'package:life_eazy/models/authentication/login_response_model.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/prefs/local_storage_services.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/authentication/auth_servcices.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

class LoginViewModel extends CustomBaseViewModel {
  var _authService = locator<AuthService>();
  var _dialogService = locator<DialogService>();
  var navigationService = locator<NavigationService>();
  var _prefs = locator<LocalStorageService>();
  bool _isShowPassword = false;


  bool get isShowPassword => _isShowPassword;

  set isShowPassword(value) {
    _isShowPassword = value;
    notifyListeners();
  }

  TextEditingController userNameController =
      new TextEditingController(text: "");
  TextEditingController passwordController =
      new TextEditingController(text: "");

  Future<GenericResponse> login() async {
    setState(ViewState.Loading);
    var genericResponse;
    try {

      var response = await _authService.login(new LoginRequestModel(
        username: !ifMobile()
            ? userNameController.text
            : '+91${userNameController.text}',
        password: passwordController.text,
        deviceToken: SessionManager.fcmToken??"",

      ));
      genericResponse = response;
      if (response.hasError == false) {
        _prefs.setIsLogIn(true);
        _prefs.setUserModel(jsonEncode(response.result));
        print(jsonEncode(response.result));
        SessionManager.setUser =
            LoginResponseModel.fromMap(response.result as Map<String, dynamic>);

        if(SessionManager.getUser.profile!=null) {
          var image = SessionManager.getUser.profile["ProfilePicture"];
          SessionManager.profileImageUrl = image;
        }
        navigationService.navigateToAndRemoveUntil(Routes.dashboardView);
      } else {
        _dialogService.showDialog(
            DialogType.ErrorDialog, message, response.message, "", "Done");
        setState(ViewState.Completed);
      }
    } catch (e) {
      // _dialogService.showDialog();
      setState(ViewState.Completed);
    }
    return genericResponse;
  }

  bool ifMobile() {
    // String pattern = "/^[a-z]{0,10}$/";
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    //  String pattern = r'(^[a-z]{0,10}$)';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(userNameController.text);
  }
}
