import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/screen_constants.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/viewmodel/authentication/login_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatefulWidget {
  static var userName = "";

  @override
  State<StatefulWidget> createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  late LoginViewModel _viewModel;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: _currentWidget());
      },
      viewModelBuilder: () => LoginViewModel(),
    );
  }

  Widget _loginContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: displayHeight(context) * 1),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: 100,
                width: 200,
                child: Image.asset(
                  "images/lifeeazy.png",
                  fit: BoxFit.contain,
                ))),
        _userName(),
        _passWord(),
        SizedBox(height: displayHeight(context) * 0.3),
        _registerAndResetPasswordHint(),
        SizedBox(height: displayHeight(context) * 0.5),
        _signInWithOtp(),
      ],
    );
  }

  Widget _passWord() {
    return TextFormField(
      obscureText: !_viewModel.isShowPassword,
      controller: _viewModel.passwordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (v) {
        if (_viewModel.userNameController.text.isEmpty ||
            _viewModel.passwordController.text.isEmpty)
          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
              content: new Text("Either Username or Password is Empty")));
        else
          _viewModel.login();
      },
      onSaved: (value) {},
      validator: (value) {},
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: password,
        suffixIcon: IconButton(
          icon: Icon(_viewModel.isShowPassword
              ? Icons.visibility
              : Icons.visibility_off),
          onPressed: () {
            _viewModel.isShowPassword =
                _viewModel.isShowPassword == false ? true : false;
          },
        ),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _userName() {
    return TextFormField(
      obscureText: false,
      controller: _viewModel.userNameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(context).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {},
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: phoneInputHint,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _registerAndResetPasswordHint() {
    return Container(
      height: kToolbarHeight - 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.registerView);
            },
            child: RichText(
              text: TextSpan(
                  text: notSignUpYet,
                  style: smallTextStyle.copyWith(color: darkColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: register,
                        style: mediumTextStyle.copyWith(
                            color: baseColor, fontWeight: FontWeight.bold))
                  ]),
            ),
          ),
          Spacer(),
          VerticalDivider(
            thickness: 1,
          ),
          Spacer(),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.resetPasswordView);
            },
            child: Text(resetPassword,
                style: bodyTextStyle.copyWith(
                    color: darkColor, fontWeight: FontWeight.normal)),
          )
        ],
      ),
    );
  }

  Widget _signInWithOtp() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.signInWithOtpView);
      },
      child: Container(
        height: kToolbarHeight,
        width: displayWidth(context) * 3.5,
        decoration: BoxDecoration(
            border: Border.all(color: baseColor, width: 1),
            borderRadius: BorderRadius.circular(standardBorderRadius)),
        child: Center(
            child: Text(
          signInWithOtp,
          style: bodyTextStyle.copyWith(color: baseColor),
        )),
      ),
    );
  }

  Widget _body() {
    return Container(
      margin: authMargin,
      child: Stack(children: [
        _loginContainer(),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: buttonBottomPadding),
              child: ButtonContainer(
                buttonText: login,
                onPressed: () {
                  if (_viewModel.userNameController.text.isEmpty ||
                      _viewModel.passwordController.text.isEmpty)
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                        content:
                            new Text("Either Username or Password is Empty")));
                  else
                    _viewModel.login();
                },
              ),
            ))
      ]),
    );
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: "Logging In",
          loadingMsgColor: Colors.black,
        );

      case ViewState.Completed:
        return _body();

      default:
        return _body();
    }
  }
}
