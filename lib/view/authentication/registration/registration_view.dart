
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/authentication/location_response_model.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/prefs/local_storage_services.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/view/authentication/widgets/allow_location_widget.dart';
import 'package:life_eazy/view/authentication/widgets/enter_details_widget.dart';
import 'package:life_eazy/view/authentication/widgets/enter_otp_widget.dart';
import 'package:life_eazy/view/authentication/widgets/enter_phone_number_widget.dart';
import 'package:life_eazy/viewmodel/authentication/registration_viewmodel.dart';
import 'package:stacked/stacked.dart';

class RegisterView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterView();
}

class _RegisterView extends State<RegisterView> {
  late RegistrationViewModel _viewModel;
  final GlobalKey<FormState> _formState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegistrationViewModel>.reactive(
      builder:
          (BuildContext context, RegistrationViewModel model, Widget? child) {
        _viewModel = model;
        return Scaffold(
          resizeToAvoidBottomInset: false,

          
          backgroundColor: appBarColor,
          appBar: CommonAppBar(
            title: "",
            onClearPressed: (){
              locator<NavigationService>().navigateToAndRemoveUntil(Routes.loginView);
            },
            onBackPressed: () {
              if (_viewModel.currentScreen == 1)
                Navigator.pop(context);
              else
                _viewModel.decrementCurrentScreenValue();
            },

          ),
        //   appBar: CommonAppBar(
        //     onBackPressed: () {
        //       Navigator.pop(context);
        //     },
        //         onClearPressed: () {
        //           Navigator.pushNamedAndRemoveUntil(
        //              context, Routes.loginView, (route) => false);
        // },
        //     onBackPressed: () {
        //       if (_viewModel.currentScreen == 1)
        //         Navigator.pop(context);
        //       else
        //         _viewModel.decrementCurrentScreenValue();
        //     },
        //   ),
          body: SafeArea(
            child: _viewModel.state == ViewState.Loading? Loader(loadingMessage:"Loading",loadingMsgColor: Colors.black,) : Container(
              margin: authMargin,
              child: Container(
                child: Stack(
                  children: [
                  Form(
                      key: _formState,
                      child: _currentWidget()),

                    Visibility(
                      visible: _viewModel.currentScreen==2 ?false :true,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: buttonBottomPadding),
                            child: ButtonContainer(
                              buttonText: _currentButtonText(),
                              onPressed: () {
                                // if (_viewModel.currentScreen != 4)
                                //   _viewModel.incrementCurrentScreenValue();
                                // else
                                //   Navigator.pushNamedAndRemoveUntil(
                                //       context,
                                //       Routes.registrationSuccessView,
                                //       (route) => false);

                                _onPressedFun();
                              },
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => RegistrationViewModel(),
    );
  }

  Widget _currentWidget() {
    int position = _viewModel.currentScreen;
    switch (position) {
      case (1):
        return EnterPhoneNumberWidget();

      case (2):
        return EnterOtpWidget();

      // case (3):
      //   return AllowLocationWidget();

      case (3):
        return EnterDetailsWidget();

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

      // case (3):
      //   return allowLocation;

      case (3):
        return submit;

      default:
        return next;
    }
  }

  // void _onPressedFun()async
  // {
  //   if(_viewModel.currentScreen ==1)
  //    _viewModel.isPhoneNumberRegistered();
  //   else if(_viewModel.currentScreen ==3) {
  //     {
  //
  //       var pos =  await  _viewModel.determinePosition();
  //
  //       SessionManager.setLocation = new LocationResponseModel(
  //           lat: pos.latitude,
  //           long: pos.longitude,
  //           city: "Visakhapatnam",
  //           country: "India",
  //           pinCode: 530040,
  //           state: "Andhra Pradesh",
  //           address: "M.V.P Colony, Sector No.1, HIG 31, Opposite Pullocks Kinder Garden School Near to Vuda Kalyanamadapam, Tennis Court, Dondaparthy, Gajuwaka, Visakhapatnam, Andhra Pradesh 530017, India"
  //
  //       );
  //       locator<LocalStorageService>().setLocation(SessionManager.getLocation.toJson());
  //       _viewModel.incrementCurrentScreenValue();
  //
  //     }
  //   // else if(_viewModel.currentScreen ==4) {
  //     _formState.currentState!.save();
  //     _viewModel.registerUser();
  //   }
  //   else {
  //     if(_viewModel.currentScreen <4)
  //       _viewModel.incrementCurrentScreenValue();
  //   }
  //
  // }
  void _onPressedFun()async
  {
    if(_viewModel.currentScreen ==1)
      _viewModel.isPhoneNumberRegistered();
    // else  if(_viewModel.currentScreen == 3)
    // {
    //
    //   var pos =  await  _viewModel.determinePosition();
    //
    //   SessionManager.setLocation = new LocationResponseModel(
    //       lat: pos.latitude,
    //       long: pos.longitude,
    //       city: "Visakhapatnam",
    //       country: "India",
    //       pinCode: 530040,
    //       state: "Andhra Pradesh",
    //       address: "M.V.P Colony, Sector No.1, HIG 31, Opposite Pullocks Kinder Garden School Near to Vuda Kalyanamadapam, Tennis Court, Dondaparthy, Gajuwaka, Visakhapatnam, Andhra Pradesh 530017, India"
    //
    //   );
    //   locator<LocalStorageService>().setLocation(SessionManager.getLocation.toJson());
    //   _viewModel.incrementCurrentScreenValue();
    //
    // }
    else if(_viewModel.currentScreen ==3) {
      _formState.currentState!.validate();
      _formState.currentState!.save();

      if( _formState.currentState!.validate())
        _viewModel.registerUser();

    }
    else {
      if(_viewModel.currentScreen <3)
        _viewModel.incrementCurrentScreenValue();
    }

  }


}
