import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/enums/snackbar_types.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/viewmodel/family_members/family_members_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../get_it/locator.dart';
import '../../../tools/date_formatting.dart';

//ignore: must_be_immutable
class FamilyMembersPersonalInfoWidget extends ViewModelWidget<FamilyMembersViewModel> {
  late BuildContext _context;
  final _formKey = GlobalKey<FormState>();

  bool isEdit = false;
  late FamilyMembersViewModel _viewModel;


  FamilyMembersPersonalInfoWidget({this.isEdit = false});

  @override
  Widget build(BuildContext context,FamilyMembersViewModel viewModel) {
    _context = context;
    _viewModel =viewModel;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
         child: Container(
        margin: authMargin,
        child:Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            _title(),
            _firstName(),
            _lastName(),
            _gender(),
            _dob(),
            _martialStatus(),
            _bloodGroup(),
            _relationShipToPatient(),
            _familyType(),
            _isEmergencyWidget(),
            // _preferredPhysician(),
            // _preferdPhysicianSpecialization(),
            SizedBox(
              height: 80,
            ),
            ButtonContainer(
              buttonText: _viewModel.isEdit ? edit : add,
              onPressed: (){
                _formKey.currentState!.save();
                if(_formKey.currentState!.validate() == true) {

                  if(_viewModel.selectedMartialStatus == 0)
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Select Martial Status") ));
                  else if(_viewModel.selectedBloodGroup == 0)
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Select Blood Group") ));
                  else

                    _viewModel.isEdit
                      ? _viewModel.editFamilyMembersInfo()
                      : _viewModel.addFamilyMembersInfo();
                }
                else
                  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Required fields cannot be empty") ));
              },
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
      ),
    ),
      );
  }

  Widget _firstName() {
    return TextFormField(
      obscureText: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {
        if (value!.isEmpty)
          return "Enter FirstName" ;
      },
      controller: _viewModel.firstName,
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: firstName,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _lastName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      obscureText: false,
      onFieldSubmitted: (v) {
        FocusScope.of(_context).nearestScope;
      },
      controller: _viewModel.lastName,
      onSaved: (value) {},
      validator: (value) {
        if (value!.isEmpty)
          return "Enter Last Name" ;
      },
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: lastName,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _gender() {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: darkColor, width: 0.5))),
      child: DropdownButton(

        hint: Text(_viewModel.genderList[_viewModel.selectedGender]),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        underline: Container(),
        onChanged: (value) {

          _viewModel.selectedGender = value as int;
          _viewModel.familyMemberInfoRequest.title = _viewModel.genderList[_viewModel.selectedGender];
          _viewModel.reload();
        },

        items: List.generate(_viewModel.genderList.length, (index) {
          return DropdownMenuItem(

            child: Text(
              _viewModel.genderList[index],
              style: mediumTextStyle,
              softWrap: true,
            ),
            value: index,
          );
        }),
        value: _viewModel.selectedGender,
      ),
    );
  }


  Widget _familyType() {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: darkColor, width: 0.5))),
      child: DropdownButton(

        hint: Text(_viewModel.familyTypeList[_viewModel.selectedFamilyType]),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        underline: Container(),
        onChanged: (value) {

          _viewModel.selectedFamilyType = value as int;
          _viewModel.familyMemberInfoRequest.familyMemberType = _viewModel.familyTypeList[_viewModel.selectedFamilyType];
          _viewModel.reload();
        },

        items: List.generate(_viewModel.familyTypeList.length, (index) {
          return DropdownMenuItem(

            child: Text(
              _viewModel.familyTypeList[index],
              style: mediumTextStyle,
              softWrap: true,
            ),
            value: index,
          );
        }),
        value: _viewModel.selectedFamilyType,
      ),
    );
  }



  Widget _title() {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: darkColor, width: 0.5))),
      child: DropdownButton(
        hint: Text(gender),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        underline: Container(),
        onChanged: (value) {
          _viewModel.selectedTitle = value as int;
          _viewModel.familyMemberInfoRequest.title = _viewModel.titleList[_viewModel.selectedTitle];
          _viewModel.reload();
        },
        items: List.generate(_viewModel.titleList.length, (index) {
          return DropdownMenuItem(
            child: Text(
              _viewModel.titleList[index],
              style: mediumTextStyle,
              softWrap: true,
            ),
            value: index,
          );
        }),
        value: _viewModel.selectedTitle,
      ),
    );
  }

  Widget _martialStatus() {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: darkColor, width: 0.5))),
      child: DropdownButton(
        hint: Text(martialStatus),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        underline: Container(),
        onChanged: (value) {
          _viewModel.selectedMartialStatus = value as int;
          _viewModel.familyMemberInfoRequest.martialStatus =  _viewModel.martialList[_viewModel.selectedMartialStatus];
          _viewModel.reload();
        },
        items: List.generate(_viewModel.martialList.length, (index) {
          return DropdownMenuItem(
            child: Text(
              _viewModel.martialList[index],
              style: mediumTextStyle,
              softWrap: true,
            ),
            value: index,
          );
        }),
        value: _viewModel.selectedMartialStatus,
      ),
    );
  }

  Widget _dob() {
    return GestureDetector(
      onTap: (){
        _showDatePicker();
      },
      child: TextFormField(
        obscureText: false,
        enabled: false,
        initialValue:_viewModel.profileDateController.text == ""? _viewModel.profileDateController.text : "${formatDate(_viewModel.profileDateController.text ??"")}",
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(_context).nearestScope;
        },
        onSaved: (value) {},
        validator: (value) {
          if(_viewModel.profileDateController.text.isEmpty)
            return "Enter DOB" ;
        },
        style: mediumTextStyle,
        decoration: InputDecoration(
          labelStyle: textFieldsHintTextStyle,
          hintStyle: textFieldsHintTextStyle,
          labelText: dateOfBirth,

          suffixIcon: Icon(
            Icons.calendar_today_outlined,
            color: darkColor,
            size: 24,

          ),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _bloodGroup() {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: darkColor, width: 0.5))),
      child: DropdownButton(
        hint: Text(martialStatus),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        underline: Container(),
        onChanged: (value) {
          _viewModel.selectedBloodGroup = value as int;
          _viewModel.familyMemberInfoRequest.bloodGroup =  _viewModel.bloodGroup[value];
          _viewModel.reload();
        },
        items: List.generate(_viewModel.bloodGroup.length, (index) {
          return DropdownMenuItem(
            child: Text(
              _viewModel.bloodGroup[index],
              style: mediumTextStyle,
              softWrap: true,
            ),
            value: index,
          );
        }),
        value: _viewModel.selectedBloodGroup,
      ),
    );
  }

  Widget _relationShipToPatient() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: _viewModel.relationShipController,
      obscureText: false,
      onFieldSubmitted: (v) {
        _formKey.currentState!.validate();
        if(_formKey.currentState!.validate())
          _viewModel.isEdit?   _viewModel.editFamilyMembersInfo():_viewModel.addFamilyMembersInfo();
        else
          ScaffoldMessenger.of(_context!).showSnackBar(new SnackBar(content: Text("successfully added") ));
      },
      // controller: _viewModel.relationShipController,
      onSaved: (value) {},
      validator: (value) {
        if (value!.isEmpty)
          return "Empty";
      },
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: "Relationship With User",
        alignLabelWithHint: true,
      ),
    );
  }


  Widget _preferredPhysician() {
    return TextFormField(
      obscureText: false,
      enabled: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {},
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: preferredPhysician,
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: darkColor,
          size: 24,
        ),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _preferdPhysicianSpecialization() {
    return TextFormField(
      obscureText: false,
      enabled: false,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {},
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: preferredPhysicianSpecialization,
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: darkColor,
          size: 24,
        ),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _isEmergencyWidget()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Text("IsEmergency",style:mediumTextStyle.copyWith(color: baseColor)),

        Switch(
          value: _viewModel.isEmergency,
          onChanged: (value) {
            _viewModel.setEmergency(value);
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),


      ],

    );
  }

  void _showDatePicker()
  {
    showDatePicker(
        context: _context,

        initialDate: DateTime(2021),
        //which date will display when user open the picker
        firstDate: DateTime(1950),
        //what will be the previous supported year in picker
        lastDate: DateTime(2023)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {

        return;
      }
      else
      {
        _viewModel.setProfileDate(pickedDate);
      }

    });
  }
}
