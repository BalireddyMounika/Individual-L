import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/snackbar_types.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/authentication/login_response_model.dart';
import 'package:life_eazy/models/authentication/register_request_model.dart';
import 'package:life_eazy/models/authentication/reset_password_request_model.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/otp/genrate_otp_request.dart';
import 'package:life_eazy/models/otp/validate_otp_request.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/prefs/local_storage_services.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/authentication/auth_servcices.dart';
import 'package:life_eazy/services/common_service/common_api/common_api_service.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:uuid/uuid.dart';

import '../base_viewmodel.dart';

class RegistrationViewModel extends CustomBaseViewModel {
  int _currentScreen = 1;
  var _authService = locator<AuthService>();
  var _dialogService = locator<DialogService>();
  var _snackBarService = locator<SnackBarService>();
  var _navigatorService = locator<NavigationService>();
  var _commonApisService = locator<CommonApiService>();
  RegisterRequestModel registerRequestModel = new RegisterRequestModel();
  ResetPasswordRequestModel resetPasswordRequestModel =
      new ResetPasswordRequestModel();

  get currentScreen => _currentScreen;
  String? verificationId;
  int? forceResendToken;
  int otpId = 0;
  String loaderMsg = "";
  bool codeSent = false;
  final formState = GlobalKey<FormState>();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  bool confirmPasswordObscureTextStatus = true;
  PhoneNumber internationalPhoneNumber = PhoneNumber(isoCode: 'IN');
  bool isLoginWithOtp = true;
  bool isResetPass = false;

  RegistrationViewModel();

  RegistrationViewModel.signInWithOtp(this.isLoginWithOtp);

  RegistrationViewModel.resetPassword(this.isResetPass);

  bool isTimerStopped = false;
  var _prefs = locator<LocalStorageService>();

  void incrementCurrentScreenValue() {
    _currentScreen = 2;

    notifyListeners();
  }

  void changeObscureTextStatus() {
    confirmPasswordObscureTextStatus = !confirmPasswordObscureTextStatus;
    notifyListeners();
  }

  void decrementCurrentScreenValue() {
    if (_currentScreen != 1) _currentScreen = _currentScreen - 1;
    notifyListeners();
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      // var user = signIn(authResult);
      // if (user != null) {
      //   _snackbarService.showSnackbar(
      //       title: 'OTP verified successfully', message: '');
      //   switchScreenTo(screenState.personalInfoScreen);
      // }
    };

    final PhoneVerificationFailed Verificationfailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int? forceResend]) {
      verificationId = verId;
      forceResendToken = forceResend;
      codeSent = true;
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${phoneNumberController.text}",
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: Verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  signIn(AuthCredential authCreds) async {
    var data = await FirebaseAuth.instance.signInWithCredential(authCreds);
    return data;
  }

  void timerStopped() {
    isTimerStopped = true;
    notifyListeners();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    setState(ViewState.Loading);
    var position = await Geolocator.getCurrentPosition();
    setState(ViewState.Completed);
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return position;
  }

  Future<void> resendSms(String phoneNo) async {
    loaderMsg = "Resending Otp..";
    setState(ViewState.Loading);
    var response = await _commonApisService
        .generateOtp(new GenerateOtpRequest(phoneNumber: '+91$phoneNo'));

    otpId = response.result['id'];
    if (response.hasError == false) {
      isTimerStopped = false;
      setState(ViewState.Completed);
      setState(ViewState.Completed);
      _snackBarService.showSnackBar(
          title: "Otp Send Successfully", snackbarType: SnackbarType.success);
    } else {
      isTimerStopped = false;
      setState(ViewState.Completed);
      _snackBarService.showSnackBar(
          title: "Failed to send otp", snackbarType: SnackbarType.error);
    }
  }

  signInWithOTP(String smsCode) async {
    setState(ViewState.Loading);
    try {
      AuthCredential authCreds = PhoneAuthProvider.credential(
          verificationId: verificationId ?? "123", smsCode: smsCode);
      var request = new ValidateOtpRequest(otp: smsCode);
      GenericResponse response = await _commonApisService.validateOtp(request, otpId);
      if (response.hasError == false) {
        setState(ViewState.Completed);
        // _isVerified =true;
        if (isLoginWithOtp) {
          _prefs.setIsLogIn(true);
          _prefs.setUserModel(jsonEncode(SessionManager.getUser.toMap()));

          if (SessionManager.getUser.profile != null) {
            var image = SessionManager.getUser.profile["ProfilePicture"];
            SessionManager.profileImageUrl = image;
            _prefs.setProfileImage(image);
          }

          _dialogService.showDialog(DialogType.SuccessDialog, message,
              "Login Success", Routes.dashboardView, ok,
              isStackedCleared: true);
        } else
          _dialogService.showDialog(DialogType.SuccessDialog, message,
              "Login Success", Routes.dashboardView, ok,
              isStackedCleared: true);
      } else {
        setState(ViewState.Completed);
        _dialogService.showDialog(
            DialogType.ErrorDialog, response.message ??'_', otpVerificationFailed, "", ok);
      }
    } on Exception catch (r) {
      setState(ViewState.Completed);
      print(r);
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, otpVerificationFailed, "", ok);
    }
  }

  Future sendOtp() async {
    var request =
        GenerateOtpRequest(phoneNumber: "+91${phoneNumberController.text}");
    var response = await _commonApisService.generateOtp(request);
    otpId = response.result['id'];
    if (response.hasError == false) {
      setState(ViewState.Completed);
      incrementCurrentScreenValue();
      _snackBarService.showSnackBar(
          title: "Otp send to +91${phoneNumberController.text}",
          snackbarType: SnackbarType.success);
    } else {
      _snackBarService.showSnackBar(
          title: "Failed to send otp", snackbarType: SnackbarType.error);
    }
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future isPhoneNumberAvailable() async {
    setState(ViewState.Loading);
    try {
      GenericResponse response = await _authService
          .isPhoneNumberRegistered(internationalPhoneNumber.phoneNumber);
      if (response.hasError == false) {
         isLoginWithOtp = true;
        _prefs.setUserModel(jsonEncode(response.result));

        print(jsonEncode(response.result));
        SessionManager.setUser =
            LoginResponseModel.fromMap(response.result as Map<String, dynamic>);
        if (SessionManager.getUser.profile != null) {
          SessionManager.profileImageUrl =
              SessionManager.getUser.profile["ProfilePicture"];
          _prefs.setProfileImage(
              SessionManager.getUser.profile["ProfilePicture"]);
        }
        setState(ViewState.Completed);
        sendOtp();
      } else {
        isLoginWithOtp = true;
        setState(ViewState.Completed);
        sendOtp();
      }
    } catch (e) {
      setState(ViewState.Completed);
      _dialogService.showDialog(
          DialogType.ErrorDialog, "Messege", somethingWentWrong, "", "Ok");
    }
  }

  Future isPhoneNumberRegistered() async {
    var genericResponse = new GenericResponse();
    setState(ViewState.Loading);
    try {
      var response = await _authService
          .isPhoneNumberRegistered(internationalPhoneNumber.phoneNumber);
      genericResponse = response;
      if (response.hasError == false) {
        _prefs.setUserModel(jsonEncode(response.result));
        print(jsonEncode(response.result));
        SessionManager.setUser =
            LoginResponseModel.fromMap(response.result as Map<String, dynamic>);

        if (isLoginWithOtp || isResetPass) {
          setState(ViewState.Completed);
          sendOtp();
        } else
          _dialogService.showDialog(DialogType.ErrorDialog, message,
              userIsAlreadyRegistered, Routes.loginView, ok);
      } else if (response.hasError == true && !isLoginWithOtp && !isResetPass) {
        setState(ViewState.Completed);
        sendOtp();

        // _dialogService.showDialog(DialogType.ErrorDialog, message,
        //     somethingWentWrong, Routes.loginView, ok);
      } else {
        registerUser();
      }
    } catch (e) {
      _dialogService.showDialog(DialogType.ErrorDialog, message,
          somethingWentWrong, Routes.loginView, ok);
    }
  }

  Future registerUser() async {
    var genericResponse = new GenericResponse();
    registerRequestModel.mobileNumber = internationalPhoneNumber.phoneNumber;
    registerRequestModel.username = new Uuid().v4();

    try {
      setState(ViewState.Loading);
      registerRequestModel.deviceToken = SessionManager.fcmToken ?? "string";
      var response = await _authService.register(registerRequestModel);
      genericResponse = response;
      if (response.hasError == false) {
        _prefs.setIsLogIn(true);
        _prefs.setUserModel(jsonEncode(response.result));
        print(jsonEncode(response.result));
        SessionManager.setUser =
            LoginResponseModel.fromMap(response.result as Map<String, dynamic>);

        _navigatorService
            .navigateToAndRemoveUntil(Routes.registrationSuccessView);
      } else {
        setState(ViewState.Completed);
        _dialogService.showDialog(DialogType.ErrorDialog, message,
            response.message ?? somethingWentWrong, "", ok);
      }
    } catch (e) {
      setState(ViewState.Completed);
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", ok);
    }
  }

  Future resetPassword() async {
    var genericResponse = new GenericResponse();
    if (newPasswordController.text != confirmPasswordController.text)
      _dialogService.showDialog(DialogType.WarningDialog, 'Password not match',
          'Please enter same password', '', 'Ok');
    else
      try {
        setState(ViewState.Loading);
        var response = await _authService.resetPassword(
            new ResetPasswordRequestModel(
                password: newPasswordController.text.trim()));
        genericResponse = response;
        if (response.hasError == false) {
          setState(ViewState.Completed);
          _dialogService.showDialog(DialogType.SuccessDialog, message,
              "Password updated successfully", Routes.loginView, done);
        } else {
          setState(ViewState.Completed);
          _dialogService.showDialog(
              DialogType.ErrorDialog, message, somethingWentWrong, "", ok);
        }
      } catch (e) {
        setState(ViewState.Completed);
        _dialogService.showDialog(
            DialogType.ErrorDialog, message, somethingWentWrong, "", ok);
      }
  }
}
