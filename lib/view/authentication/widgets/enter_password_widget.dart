// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:life_eazy/constants/screen_constants.dart';
// import 'package:life_eazy/constants/strings.dart';
// import 'package:life_eazy/constants/styles.dart';
// import 'package:life_eazy/viewmodel/authentication/registration_viewmodel.dart';
// import 'package:stacked/stacked.dart';
//
// class EnterPasswordWidget extends ViewModelWidget<RegistrationViewModel>
// {
//   late  BuildContext _context;
//   final _formKey = GlobalKey<FormState>();
//   late RegistrationViewModel _viewModel;
//   @override
//   Widget build(BuildContext context,RegistrationViewModel model) {
//      this._context =context;
//      _viewModel  =model;
//
//      return Column(
//        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: [
//
//          SizedBox(
//            height: displayHeight(context) * 0.5,
//          ),
//          Text(
//            changeYourPassword,
//            style:authHeaderTextStyle,
//          ),
//          SizedBox(
//            height: displayHeight(context) * .2,
//
//          ),
//
//           _enterNewPassword(),
//           _confirmNewPassword(),
//        ],
//      );
//   }
//   Widget _enterNewPassword() {
//     return TextFormField(
//       obscureText: false,
//       controller: _viewModel.resetPasswordController,
//       textInputAction: TextInputAction.next,
//       onFieldSubmitted: (v) {
//         FocusScope.of(_context).nearestScope;
//       },
//       onSaved: (value) {},
//       validator: (value) {
//         if(value!.isEmpty)
//           return "Empty Address";
//       },
//       style: mediumTextStyle,
//       decoration: InputDecoration(
//         labelStyle: textFieldsHintTextStyle,
//         hintStyle: textFieldsHintTextStyle,
//         labelText: enterNewPassword,
//         alignLabelWithHint: true,
//       ),
//     );
//   }
//
//   Widget _confirmNewPassword() {
//     return TextFormField(
//       obscureText: false,
//       textInputAction: TextInputAction.next,
//       onFieldSubmitted: (v) {
//         FocusScope.of(_context).nearestScope;
//       },
//       onSaved: (value) {},
//       validator: (value) {},
//       style: mediumTextStyle,
//       decoration: InputDecoration(
//         labelStyle: textFieldsHintTextStyle,
//         hintStyle: textFieldsHintTextStyle,
//         labelText: confirmNewPassword,
//         alignLabelWithHint: true,
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/constants/screen_constants.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/viewmodel/authentication/registration_viewmodel.dart';
import 'package:stacked/stacked.dart';

class EnterPasswordWidget extends ViewModelWidget<RegistrationViewModel>
{
  late  BuildContext _context;
  late RegistrationViewModel _viewModel;
  @override
  Widget build(BuildContext context,RegistrationViewModel model) {
    this._context =context;
    _viewModel  =model;
    return SingleChildScrollView(
      child:Form(
        key: _viewModel.formState,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(
              height: displayHeight(context) * 0.5,
            ),
            Text(
              changeYourPassword,
              style:authHeaderTextStyle,
            ),
            SizedBox(
              height: displayHeight(context) * .2,

            ),

            _enterNewPassword(),
            _confirmNewPassword(),

          ],
        ),
      ),
    );
  }
  Widget _enterNewPassword() {
    return TextFormField(
      obscureText: false,
      controller: _viewModel.newPasswordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context).nearestScope;
      },
      onSaved: (value) {},
      validator: (value){
        if (value!.isEmpty)
          return "Password must be enter";
        else if (value!.length <=6)
          return "Password must be at least 6 characters";
        return null;
      },
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: enterNewPassword,
        helperMaxLines: 2,
        helperText: "Password must contain one capital letter, special character & numbers",
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _confirmNewPassword() {
    return TextFormField(
      controller:_viewModel.confirmPasswordController ,
      obscureText: _viewModel.confirmPasswordObscureTextStatus,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (v) {
      if (_viewModel.formState.currentState!.validate()) {
        _viewModel.formState.currentState!.save();
        if (_viewModel.currentScreen == 1)
          _viewModel.isPhoneNumberRegistered();
        else if (_viewModel.currentScreen == 3)
          _viewModel.resetPassword();
      }
      },
      onSaved: (value) {},
      validator: (value) {
        if (value!.isEmpty)
          return "Enter Confirm Password";
        else if (value!.length <=6)
          return "Password must be at least 6 characters";
        return null;
      },
      style: mediumTextStyle,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(_viewModel.confirmPasswordObscureTextStatus?Icons.visibility:Icons.visibility_off),
          onPressed:()=>_viewModel.changeObscureTextStatus() ,
        ),
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: confirmNewPassword,
        alignLabelWithHint: true,
      ),
    );
  }
}





