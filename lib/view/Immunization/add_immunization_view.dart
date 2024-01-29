import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:stacked/stacked.dart';

import '../../common_widgets/button_container.dart';
import '../../common_widgets/common_appbar.dart';
import '../../common_widgets/empty_list_widget.dart';
import '../../common_widgets/loader.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../constants/styles.dart';
import '../../enums/viewstate.dart';
import '../../models/immunization/getImmuinisationResponse.dart';
import '../../route/routes.dart';
import '../../tools/date_formatting.dart';
import '../../viewmodel/Immunization/immunization_viewmodel.dart';

class AddImmunizationView extends StatefulWidget {
  GetImmunizationResponse selectedItem = new GetImmunizationResponse();

  AddImmunizationView(this.selectedItem);
  @override
  State<StatefulWidget> createState() => _AddImmunizationView();
}

class _AddImmunizationView extends State<AddImmunizationView> {
  late ImmunizationViewModel _viewModel;
  late BuildContext _context;
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  late File _image;
  bool isImageSelected = false;

  get child => null;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return ViewModelBuilder<ImmunizationViewModel>.reactive(
      onModelReady: (model) {},
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return Scaffold(
            bottomSheet: ButtonContainer(
              buttonText: "Submit",
              onPressed: () {
                _viewModel.postImmunization();
              },
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: CommonAppBar(
              title: immuneVaccine,
              isClearButtonVisible: true,
              onBackPressed: () {
                Navigator.pop(context);
              },
              onClearPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.dashboardView, (route) => false);
              },
            ),
            body: _currentWidget());
      },
      viewModelBuilder: () => ImmunizationViewModel.add(widget.selectedItem),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpaceMedium,
            Text(" Vaccine Name"),
            SizedBox(height: 5),
            _enterVaccineName(),
            SizedBox(height: 15),
            // _enterAge(),
            // _gender(),
            Text(' Date Of Immunization'),
            SizedBox(height: 5),
            _dateOfImmunization(),
            // _dueDateOfImmunization(),
            // verticalSpaceSmall,
            // //  _doseTaken(),
            // verticalSpaceSmall,
            // _upLoadDocuments(),
            //
            // verticalSpaceLarge,
            // verticalSpaceLarge,
            //
            SizedBox(
              height: 30,
            ),
            Center(
              child: Icon(
                Icons.info_outline,
                // color: baseColor,

                size: 25,
              ),
            ),
            verticalSpaceSmall,
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                widget.selectedItem.whentogive ?? "",
                style: mediumTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                "Dose: ${widget.selectedItem.dose ?? ""}",
                style: mediumTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                "Route: ${widget.selectedItem.route ?? ""}",
                style: mediumTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                "Site: ${widget.selectedItem.site ?? ""}",
                style: mediumTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            // verticalSpaceMedium,
            // _enterVaccineName(),
            // // _enterAge(),
            // // _gender(),
            // _dateOfImmunization(),
            // // _dueDateOfImmunization(),
            verticalSpaceSmall,
            //  _doseTaken(),
            verticalSpaceSmall,
            _upLoadDocuments(),

            verticalSpaceLarge,
            verticalSpaceLarge,

            // Icon(
            //   Icons.info,
            //   color: baseColor,
            //   size: 42,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _enterVaccineName() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          obscureText: false,
          enabled: false,
          initialValue: widget.selectedItem.vaccine ?? "",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) {
            FocusScope.of(_context).nearestScope;
          },
          onSaved: (value) {},
          validator: (value) {
            if (value!.isEmpty) return "Enter Name";
          },
          style: mediumTextStyle,
          decoration: InputDecoration(
            labelStyle: textFieldsHintTextStyle,
            hintStyle: textFieldsHintTextStyle,
          ),
        ),
      ),
    );
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: "Fetching data ..",
          loadingMsgColor: Colors.black,
        );
      case ViewState.Empty:
        return EmptyListWidget("Nothing Found");
      case ViewState.Completed:
        return _body();

      case ViewState.Error:
        return Center(
            child: Text(
          somethingWentWrong,
          style: mediumTextStyle,
        ));

      default:
        return _body();
    }
  }

  Widget _dateOfImmunization() {
    return GestureDetector(
      onTap: () {
        _showDatePicker();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            obscureText: false,
            enabled: false,
            controller: _viewModel.immuneDateController,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (v) {
              FocusScope.of(_context).nearestScope;
            },
            onSaved: (value) {},
            validator: (value) {
              // if(_viewModel.immuneDateController.text.isEmpty)
              //   return "Enter DOB" ;
            },
            style: mediumTextStyle,
            decoration: InputDecoration(
              labelStyle: textFieldsHintTextStyle,
              hintStyle: textFieldsHintTextStyle,
              labelText: 'dd/mm/yyyy',
              suffixIcon: Icon(
                Icons.calendar_today,
                color: darkColor,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _upLoadDocuments() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        // _documentCurrentWidget(),
        horizontalSpaceMedium,
        Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => SimpleDialog(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.pop(dialogContext);
                              var image = await _picker.pickImage(
                                  source: ImageSource.camera, imageQuality: 60);
                              setState(() {
                                _image = File(image?.path ?? "");
                                _viewModel.addDocument(_image);
                                isImageSelected = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.camera,
                                    color: baseColor,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    camera,
                                    style: mediumTextStyle,
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pop(dialogContext);
                              var image = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 60);
                              setState(() {
                                _image = File(image?.path ?? "");
                                _viewModel.addDocument(_image);
                                isImageSelected = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: baseColor,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    gallery,
                                    style: mediumTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  verticalSpaceAverage,
                  Icon(
                    Icons.cloud_download_outlined,
                    size: 70,
                    color: immunizationVaccineNameColor,
                  ),
                  verticalSpaceSmall,
                  Text(
                    "Upload your prescription",
                    style: bodyTextStyle.copyWith(
                        color: darkColor, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  verticalSpaceSmall,
                  Text(
                    "JPG,PNG,PDF,file size not more than 1MB",
                    style: bodyTextStyle.copyWith(
                        color: darkColor, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  verticalSpaceMedium,
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: greenColor),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Select File",
                        style: bodyTextStyle.copyWith(color: baseColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  verticalSpaceSmall
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker() {
    showDatePicker(
            context: _context,
            initialDate: DateTime(2001),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime(
                2023)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        return;
      } else {
        _viewModel.immuneDateController.text =
            formatDate(pickedDate.toString().split(' ').first);

        _viewModel.immuneDate = pickedDate.toString().split(' ').first;
      }
    });
  }
}
