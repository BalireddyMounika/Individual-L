
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/viewmodel/family_members/family_members_viewmodel.dart';
import 'package:stacked/stacked.dart';

//ignore: must_be_immutable
class FamilyMembersAddressInfoWidget extends ViewModelWidget<FamilyMembersViewModel> {
  // BuildContext? _context;
  bool isEdit = false;
  late FamilyMembersViewModel _viewModel;
  BuildContext? _context;
   final _formKey = GlobalKey<FormState>();
  FamilyMembersAddressInfoWidget({this.isEdit = false});
  // late FamilyMembersViewModel _viewModel;
  @override
  Widget build(BuildContext context,FamilyMembersViewModel viewModel) {
    _context = context;
    _viewModel =viewModel;
    return Scaffold(
        resizeToAvoidBottomInset: false,
   body: SingleChildScrollView(
      child: Container(
        margin: authMargin,
        child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _address(),
            _country(),
            _state(),
            _city(),
            _zipCode(),
            _primaryNo(),


            // SizedBox(
            //   height: 15,
            // ),
            // CustomExpandedWidget(
            //   expandWidget: false,
            //   header: Padding(
            //     padding: EdgeInsets.all(15),
            //     child: Text(
            //       emergencyContactInfo,
            //       style: mediumTextStyle.copyWith(color: baseColor),
            //     ),
            //   ),
            //   body: Column(
            //     children: [
            //       _emergencyPersonName(),
            //       _emergencyRelationShipToPatient(),
            //       _emergencyPrimaryPhoneNumber(),
            //       _emergencyMobileNumber(),
            //       _emergencyEmail()
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 210,
            ),
            ButtonContainer(
              buttonText: _viewModel.isEdit ? edit : add,
              onPressed: (){
                _formKey.currentState!.save();
                if(_formKey.currentState!.validate() == false)
                _viewModel.isEdit?  _viewModel.editFamilyMemberAddress() :_viewModel.addFamilyMemberAddress();
                else
                  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Fields Required") ));
              },
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
      ),
    )
    );
  }

  Widget _emergencyPersonName() {
    return TextFormField(
      obscureText: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {},
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: personName,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _emergencyRelationShipToPatient() {
    return TextFormField(
      obscureText: false,
      enabled: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {},
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: relationShipToPatient,
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: darkColor,
          size: 24,
        ),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _emergencyPrimaryPhoneNumber() {
    return TextFormField(
      obscureText: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {},
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: primaryPhoneNumber,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _emergencyMobileNumber() {
    return TextFormField(
      obscureText: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {},
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: mobileNumber,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _emergencyEmail() {
    return TextFormField(
      obscureText: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {},
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: email,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _address() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      obscureText: false,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      controller: _viewModel.addressController,
      onSaved: (value) {},
      validator: (value) {
        if(value!.isEmpty)
          return "Empty Address";
      },
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: address,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _country() {
    return TextFormField(
      obscureText: false,
      enabled: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {
        if (value!.isEmpty)
          return "Enter Country" ;
      },
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: "India",
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: darkColor,
          size: 24,
        ),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _state() {
    return TextFormField(
      obscureText: false,
      enabled: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {
        if (value!.isEmpty)
          return "Enter State";
      },
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: "Andhra Pradesh",
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: darkColor,
          size: 24,
        ),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _city() {
    return TextFormField(
      obscureText: false,
      enabled: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {
        if (value!.isEmpty)
          return "Enter City";
      },
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: "Visakhapatnam",
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: darkColor,
          size: 24,
        ),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _zipCode() {
    return TextFormField(
      obscureText: false,
      keyboardType : TextInputType.phone,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      controller: _viewModel.zipController,
      validator: (value) {
        if (value!.isEmpty)
          return "Enter Zipcode";

      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly
      ],
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: zipCode,

        alignLabelWithHint: true,
      ),
    );
  }

  Widget _primaryNo() {
    return TextFormField(
      obscureText: false,
      keyboardType:TextInputType.phone,
      textInputAction: TextInputAction.done,
      controller: _viewModel.phoneController,
      onFieldSubmitted: (v) {
        if(_formKey.currentState!.validate())
            _viewModel.isEdit?  _viewModel.editFamilyMemberAddress() :_viewModel.addFamilyMemberAddress();
        else
          ScaffoldMessenger.of(_context!).showSnackBar(new SnackBar(content: Text("Fields Required") ));
      },
      onSaved: (value) {},
      // controller: _viewModel.phoneController,
      validator: (value) {
        if (value!.isEmpty)
          return "Enter Primary Number";
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly
      ],
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: primaryNo,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _mobileNo() {
    return TextFormField(
      obscureText: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {},
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: mobileNumber,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _email() {
    return TextFormField(
      obscureText: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {},
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: email,
        alignLabelWithHint: true,
      ),
    );
  }
}
