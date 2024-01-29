import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/view/authentication/widgets/enter_otp_widget.dart';
import 'package:life_eazy/view/authentication/widgets/enter_phone_number_widget.dart';
import 'package:life_eazy/viewmodel/authentication/registration_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../enums/snackbar_types.dart';
import '../../../get_it/locator.dart';
import '../../../services/common_service/snackbar_service.dart';

class SignInWithOtpView extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()  =>  _SignInWithOtpView();

}

class _SignInWithOtpView extends State<SignInWithOtpView>
{
 late RegistrationViewModel _viewModel;
  @override
  Widget build(BuildContext context) {

    return  ViewModelBuilder<RegistrationViewModel>.reactive(
      builder: (BuildContext context, RegistrationViewModel model, Widget? child) {
        _viewModel = model;
        return _viewModel.state == ViewState.Loading? Loader(loadingMessage: "Loading..",isScaffold: true,) : Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: appBarColor,
          bottomNavigationBar: Visibility(
            visible: _viewModel.currentScreen==2 ? false : true,
            child: ButtonContainer(
              buttonText: _currentButtonText(),
              onPressed: () {
                _onPressedFun();
              },
            ),
          ),
          body: SafeArea(
            child: Container(
              margin: authMargin,
              child: Stack(
                children: [
                  _currentWidget(),
                ],
              ),
            ),
          ),
        );
      }, viewModelBuilder: () =>   RegistrationViewModel.signInWithOtp(true),

    );
  }
 Widget _currentWidget() {
   int position = _viewModel.currentScreen;
   switch (position) {
     case (1):
       return EnterPhoneNumberWidget();

     case (2):
       return EnterOtpWidget();

     default:
       return EnterPhoneNumberWidget();
   }
 }

 String _currentButtonText() {
   int position = _viewModel.currentScreen;
   switch (position) {
     case (1):
       return next;


     case (2):
       return verifyOtp;


     default:
       return next;
   }
 }

 void _onPressedFun()
 {
   if(_viewModel.phoneNumberController.text.isNotEmpty) {
     if(_viewModel.phoneNumberController.text.length == 10) {
       _viewModel.isPhoneNumberAvailable();
     }else{
       locator<SnackBarService>().showSnackBar(title: "Please Enter Valid Number");
     }
   }else{
     locator<SnackBarService>().showSnackBar(title: "Phone Number Required");
   }

 }
}


