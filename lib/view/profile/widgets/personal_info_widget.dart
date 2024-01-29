import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/viewmodel/profile/profile_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../../tools/date_formatting.dart';

//ignore: must_be_immutable
class PersonalInfoWidget extends ViewModelWidget<ProfileViewModel> {
  late BuildContext _context;



  bool isEdit = false;
  final _formKey = GlobalKey<FormState>();
  late ProfileViewModel _viewModel;
  bool viewVisible = true ;



  PersonalInfoWidget({this.isEdit = false});

  @override
  Widget build(BuildContext context,ProfileViewModel viewModel) {
    _context = context;
    _viewModel =viewModel;
    return Scaffold(
      bottomSheet:  ButtonContainer(
        buttonText: _viewModel.isEditProfile ? update : add,
        onPressed: (){
          _formKey.currentState!.validate();
          if(_formKey.currentState!.validate())
            if(_viewModel.isEditProfile)
              {
                if(_viewModel.selectedMartialStatus == 0)
                  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Select Martial Status") ));
                else if(_viewModel.selectedBloodGroup == 0)
                  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Select Blood Group") ));
                else

                  _viewModel.updateUserProfile();
              }
          else
            {
              // if(SessionManager.profileImageUrl!.isEmpty)
              //   locator<SnackBarService>().showSnackBar(
              //       title: "Add Profile Image",
              //       snackbarType: SnackbarType.error
              //   );
              // else

                 if(_viewModel.selectedMartialStatus == 0){
                   ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Select Martial Status") ));}
                 else if(_viewModel.selectedBloodGroup == 0){
                   ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Select Blood Group") ));
                 }
                  else{
                 _viewModel.multiApiCall();
                  }
            }

          else
            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Fields cannot be empty") ));

        },
      ),
      resizeToAvoidBottomInset: false,
   body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(right: 13,left: 13),
       // margin: authMargin,
        child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Visibility(
                visible: true,
                child: _firstName()),
            Visibility(
                visible: true,
                child: _lastname()),
            Visibility(
                visible: true,
                child: _email()),
            _title(),
            _gender(),
            _dob(),
            _martialStatus(),
            _bloodGroup(),

            SizedBox(
              height: 170,
            ),
            // ButtonContainer(
            //   buttonText: _viewModel.isEditProfile ? edit : add,
            //   onPressed: (){
            //    _formKey.currentState!.validate();
            //    if(_formKey.currentState!.validate())
            //     _viewModel.isEditProfile? _viewModel.updateUserProfile() : _viewModel.addUserProfile();
            //     else
            //     Scaffold.of(context).showSnackBar(new SnackBar(content: Text("Fields cannot be empty") ));
            //
            //   },
            // ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    ),
   )
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
        if(value!.isEmpty)
          return 'Enter Firstname';
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
  Widget _lastname() {
    return TextFormField(
      obscureText: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {
        if(value!.isEmpty)
          return 'Enter Name';
      },

      controller: _viewModel.lastName,
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: lastName,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _email() {
    return TextFormField(
      obscureText: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(_context).nearestScope;
      },
      onSaved: (value) {},
      validator: (value) {
        if(value!.isEmpty)
          return 'Enter Email ';
      },

     controller: _viewModel.email,
      style: mediumTextStyle,
      decoration: InputDecoration(
        labelStyle: textFieldsHintTextStyle,
        hintStyle: textFieldsHintTextStyle,
        labelText: email,
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
          _viewModel.profileRequest.title = _viewModel.genderList[_viewModel.selectedGender];
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
          _viewModel.profileRequest.title = _viewModel.titleList[_viewModel.selectedTitle];
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
          _viewModel.profileRequest.martialStatus =  _viewModel.martialList[_viewModel.selectedMartialStatus];
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
        enabled: true,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (v) {

        },
        onSaved: (value) {},
        validator: (value) {
          if(_viewModel.profileDate.isEmpty)
            return 'Please enter DOB';
        },
        style: mediumTextStyle,
        initialValue: _viewModel.profileDate.isEmpty? ""  : formatDate(_viewModel.profileDate),
        decoration: InputDecoration(
          labelStyle: textFieldsHintTextStyle,
          hintStyle: textFieldsHintTextStyle,
           labelText: "Date of Birth",
         //labelText:_viewModel.profileDate.isEmpty? "Date of Birth"  : formatDate(_viewModel.profileDate),
          suffixIcon: GestureDetector(
            onTap: () {
              _showDatePicker();
            },
            child: Icon(
              Icons.calendar_today_outlined,
              color: darkColor,
              size: 24,

            ),
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
          _viewModel.profileRequest.bloodGroup =  _viewModel.bloodGroupList[value];
          _viewModel.reload();
        },
        items: List.generate(_viewModel.bloodGroupList.length, (index) {
          return DropdownMenuItem(
            child: Text(
              _viewModel.bloodGroupList[index].toString(),
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



  void _showDatePicker()
  {
    
     showDatePicker(
        context: _context,
        initialDate: DateTime(2021),
        //which date will display when user open the picker
        firstDate: DateTime(1900),
        //what will be the previous supported year in picker
        lastDate: DateTime(2022)) //what will be the up to supported date in picker
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
