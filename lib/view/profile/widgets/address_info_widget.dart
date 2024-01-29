import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/view/dashboard/widgets/location_search_widget.dart';
import 'package:life_eazy/viewmodel/profile/profile_view_model.dart';
import 'package:stacked/stacked.dart';

//ignore: must_be_immutable
class AddressInfoWidget extends ViewModelWidget<ProfileViewModel> {
  BuildContext? _context;
  late ProfileViewModel _viewModel;
  bool isEdit = false;
  final _formKey = GlobalKey<FormState>();
  AddressInfoWidget({this.isEdit = false});
  // late ProfileViewModel _viewModel;
  @override
  Widget build(BuildContext context,ProfileViewModel viewModel) {
    _context = context;
    _viewModel =viewModel;
     return Scaffold(
       bottomSheet: ButtonContainer(buttonText: _viewModel.isEditAddress? 'Update': 'Add' ,
         onPressed: (){

            if(_viewModel.isEditProfile) {
              _formKey.currentState!.save();

              if (_formKey.currentState!.validate())
                _viewModel.isEditAddress
                    ? _viewModel.updateProfileAddress()
                    : _viewModel.addUserProfileAddress();
              else
                ScaffoldMessenger.of(context).showSnackBar(
                    new SnackBar(content: Text("Fields cannot be empty")));
            }
         },
       ),
       resizeToAvoidBottomInset: false,

     body:_viewModel.isEditProfile ? _body(context) : Center(
       child: Column(

         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Icon(Icons.warning,size: 56,color: Colors.grey,),
           verticalSpaceMedium,
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 24),
             child: Text( "Add Personal Info then You Can Add Your Address Information",textAlign: TextAlign.center,style: mediumTextStyle,),
           ),
         ],
       ),
     )

     );
  }

  Widget _body(context)
  {
    return  SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 13,right: 13),
        //margin: authMargin,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _address(context),
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
                height:40,
              ),
              // ButtonContainer(
              //   buttonText: _viewModel.isEditAddress ? edit : add,
              //   onPressed: (){
              //
              //
              //     _formKey.currentState!.save();
              //
              //  if(_formKey.currentState!.validate())
              //    _viewModel.isEditAddress? _viewModel.updateProfileAddress() : _viewModel.addUserProfileAddress();
              //
              //  else
              //     Scaffold.of(context).showSnackBar(new SnackBar(content: Text("Fields cannot be empty") ));
              //
              //
              //
              //   },
              // ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );


  }



  Widget _address(context) {
    return
      TextFormField(
      obscureText: false,
      maxLines: 2,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
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
        suffixIcon: GestureDetector(onTap: ()
          async{
            var data =   await Navigator.of(context).push(new MaterialPageRoute<String>(
                builder: (BuildContext context) {
                  return new LocationSearchWidget();
                },
                fullscreenDialog: true));
            _viewModel.updateLocation(data);

          },

          child: Icon(Icons.location_on,color: baseColor,),)
      ),
    );
  }

  Widget _country() {
    return TextFormField(
      obscureText: false,
      enabled: true,

      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      controller: _viewModel.countryController,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {
        if (value!.isEmpty)
          return "Enter Country";
      },
      style: mediumTextStyle,
      decoration: InputDecoration(

        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText:'Country',
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _state() {
    return TextFormField(
      obscureText: false,
      enabled: true,
      controller: _viewModel.stateController,
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
        labelText: 'State',

        alignLabelWithHint: true,
      ),
    );
  }

  Widget _city() {
    return TextFormField(
      obscureText: false,
      enabled: true,
      controller: _viewModel.cityController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {
        if (value!.isEmpty)
          return "Enter city";
      },
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: 'City',

        alignLabelWithHint: true,
      ),
    );
  }

  Widget _zipCode() {
    return TextFormField(
       keyboardType: TextInputType.numberWithOptions(signed: true),
      textInputAction: TextInputAction.next,
      obscureText: false,
      onFieldSubmitted: (v) {
        FocusScope.of(_context!).nearestScope;
      },
      onSaved: (value) {},
      controller: _viewModel.zipController,
      validator: (value) {
        if(value!.isEmpty)
          return "Empty Zipcode";
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly
      ],
      style: mediumTextStyle,
      maxLength: 6,
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
      keyboardType: TextInputType.numberWithOptions(signed: true),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (v) {
        _formKey.currentState!.save();

        if (_formKey.currentState!.validate())
          _viewModel.isEditAddress
              ? _viewModel.updateProfileAddress()
              : _viewModel.addUserProfileAddress();
        else
          ScaffoldMessenger.of(_context!).showSnackBar(
              new SnackBar(content: Text("Fields cannot be empty")));
      },
      onSaved: (value) {},
      controller: _viewModel.phoneController,
      validator: (value) {
        if(value!.isEmpty)
          return "Secondary Mobile Num.";
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: mediumTextStyle,
      maxLength: 13,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: secondaryNo,
        alignLabelWithHint: true,
      ),
    );
  }

}
