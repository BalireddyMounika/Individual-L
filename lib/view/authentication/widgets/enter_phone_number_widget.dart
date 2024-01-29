import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/viewmodel/authentication/registration_viewmodel.dart';
import 'package:stacked/stacked.dart';

//ignore: must_be_immutable
class EnterPhoneNumberWidget extends ViewModelWidget<RegistrationViewModel> {
  late RegistrationViewModel _viewModel;

  @override
  Widget build(BuildContext context, RegistrationViewModel model) {
    _viewModel = model;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        verticalSpaceLarge,
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 50,
            width: 200,
            child: Image.asset(
              "images/lifeeazy.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        verticalSpaceLarge,
        Text(
          enterYourMobileNumber,
          style: mediumTextStyle,
        ),
        verticalSpaceMedium,
        _enterNumberWidget(),
        Divider(
          thickness: 1.5,
        ),
        SizedBox(
          height: 10,
        ),
        Align(
            alignment: Alignment.topRight,
            child: Text(
              sendOtpToThisNumber,
              style: bodyTextStyle.copyWith(color: darkColor),
              textAlign: TextAlign.right,
            )),
        Spacer(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            "Vivify Healthcare Pvt. Ltd.",
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
        verticalSpaceMedium,
      ],
    );
  }

  Widget _enterNumberWidget() {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        // if(_formKey.currentState!.validate())
        _viewModel.internationalPhoneNumber = number;
      },
      keyboardType: TextInputType.numberWithOptions(signed: true),
      textFieldController: _viewModel.phoneNumberController,
      inputBorder: InputBorder.none,
      onFieldSubmitted: (term) {
        if (_viewModel.phoneNumberController.text.isNotEmpty) if (_viewModel
                .phoneNumberController.text.length ==
            10) {
          _viewModel.isPhoneNumberAvailable();
        } else {
          locator<SnackBarService>().showSnackBar(
            title: "Please Enter Valid Number",
          );
        }
        else
          locator<SnackBarService>().showSnackBar(
            title: "Phone Number Required",
          );
      },
      formatInput: false,
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      initialValue: _viewModel.internationalPhoneNumber,
    );
  }
}
