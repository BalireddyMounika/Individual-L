import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/constants/screen_constants.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import '../../common_widgets/empty_list_widget.dart';
import '../../common_widgets/loader.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../enums/viewstate.dart';
import '../../models/pharmacy/get_all_pharmacy_list.dart';
import '../../route/routes.dart';
import '../../tools/date_formatting.dart';
import '../../viewmodel/pharmacy/add_prescription_viewmodel.dart';
import '../dashboard/widgets/location_search_widget.dart';

class AddPrescriptionView extends StatefulWidget {
  GetAllPharmacyListResponse pharmacyResponse;
  AddPrescriptionView(this.pharmacyResponse);

  @override
  State<StatefulWidget> createState() => _AddPrescriptionView();
}

class _AddPrescriptionView extends State<AddPrescriptionView> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  late File _image;
  bool isImageSelected = false;
  late AddPrescriptionViewModel _viewModel;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddPrescriptionViewModel>.reactive(
        viewModelBuilder: () => AddPrescriptionViewModel(),
        builder: (context, viewModel, child) {
          _viewModel = viewModel;
          _context = context;
          return Scaffold(
              appBar: CommonAppBar(
                title: "Add Prescription",
                isClearButtonVisible: true,
                onBackPressed: () => Navigator.pop(context),
                onClearPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, Routes.dashboardView, (route) => false),
              ),
              bottomSheet: ButtonContainer(
                buttonText: "Book",
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    _viewModel.postPharmacyOrder(widget.pharmacyResponse);
                    // locator<NavigationService>().navigateTo(Routes.pharmacyOrderView);
                  }
                },
              ),
              body: _currentWidget());
        });
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: "Adding Prescription",
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

  // Widget _profileCurrentWidget() {
  //   switch (_viewModel.profileState) {
  //     case ProfileImageState.Loading:
  //       return Loader(
  //         isScaffold: false,
  //       );
  //
  //     case ProfileImageState.Completed:
  //       return NetworkImageWidget(
  //           imageName: _viewModel.document, width: 110, height: 110);
  //
  //     case ProfileImageState.Error:
  //       return Container(
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(12),
  //               border: Border.all(color: disableColor, width: 2)),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(
  //                 Icons.upload_file,
  //                 size: 32,
  //                 color: disableColor,
  //               ),
  //               verticalSpaceSmall,
  //               Flexible(
  //                 child: Text(
  //                   "Upload Prescription",
  //                   style: smallTextStyle.copyWith(color: disableColor),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ),
  //             ],
  //           ));
  //     case ProfileImageState.Idle:
  //       return Container(
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(color: disableColor, width: 1)),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(
  //               Icons.upload_file,
  //               size: 32,
  //               color: disableColor,
  //             ),
  //             verticalSpaceSmall,
  //             Flexible(
  //                 child: _viewModel.selectedFileName.isNotEmpty ? Text('${_viewModel.selectedFileName}',style: smallTextStyle.copyWith(color: disableColor),) :  Text(
  //                   "Upload \n"
  //                       " Prescription ",
  //                   style: smallTextStyle.copyWith(color: disableColor),
  //                   textAlign: TextAlign.center,
  //                 )
  //
  //
  //                )
  //           ],
  //         ),
  //       );
  //     default:
  //       return _body();
  //   }
  // }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceSmall,
              Container(
                height: 110,
                width: displaySize(context).width,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: GestureDetector(
                  onTap: () => _viewModel.pickFile(),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _viewModel.isFilesSelect
                                ? disableBaseColor
                                : disableColor,
                            width: 1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 32,
                          color: _viewModel.isFilesSelect
                              ? disableBaseColor
                              : disableColor,
                        ),
                        verticalSpaceSmall,
                        Flexible(
                            child: _viewModel.isFilesSelect
                                ? Text(
                                    _viewModel.selectedFilesName.first ?? '_',
                                    style: mediumTextStyle.copyWith(
                                        color: disableBaseColor),
                                  )
                                : Text(
                                    "Upload \n"
                                    " Prescription ",
                                    style: mediumTextStyle.copyWith(
                                        color: disableColor),
                                    textAlign: TextAlign.center,
                                  ))
                      ],
                    ),
                  ),
                ),
              ),
              verticalSpaceMedium,
              Text(
                "Name",
                style: mediumTextStyle.copyWith(color: Colors.black),
              ),
              verticalSpaceSmall,
              Container(
                height: kToolbarHeight - 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.black54)),
                child: _userName(),
              ),
              verticalSpaceMedium,
              Text(
                "Mobile Number",
                style: mediumTextStyle.copyWith(color: Colors.black),
              ),
              verticalSpaceSmall,
              Container(
                height: kToolbarHeight - 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.black54)),
                child: _mobileNumber(),
              ),
              verticalSpaceMedium,
              Text(
                "Prescribed By",
                style: mediumTextStyle.copyWith(color: Colors.black),
              ),
              verticalSpaceSmall,
              Container(
                height: kToolbarHeight - 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.black54)),
                child: _prescribedBy(),
              ),
              verticalSpaceMedium,
              Row(
                children: [
                  Text(
                    "Expected Delivery Date",
                    style: mediumTextStyle.copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  Tooltip(
                    message: 'Expected delivery within 7 day',
                    child: Icon(
                      Icons.info_outline,
                      color: baseColor,
                      size: 20,
                    ),
                  )
                ],
              ),
              verticalSpaceSmall,
              GestureDetector(
                onTap: () {
                  _showDatePicker();
                },
                child: Container(
                  height: kToolbarHeight - 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black54)),
                  child: _expectedDeliveryDate(),
                ),
              ),
              verticalSpaceMedium,
              Text(
                "DeliveryAddress",
                style: mediumTextStyle.copyWith(color: Colors.black),
              ),
              verticalSpaceSmall,
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.black54)),
                child: deliveryAdd(),
              ),
              verticalSpaceLarge,
              verticalSpaceLarge,
              verticalSpaceLarge
            ],
          ),
        ),
      ),
    );
  }

  Widget _userName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _viewModel.userNameTextController,
        obscureText: false,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).nearestScope;
        },
        onSaved: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            return 'enter name';
          }
        },
        style: mediumTextStyle,
        decoration: InputDecoration(
          labelStyle: textFieldsHintTextStyle,
          hintStyle: textFieldsHintTextStyle,
          border: InputBorder.none,
          hintText: "Enter Name",
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _prescribedBy() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _viewModel.prescribedByTextController,
        obscureText: false,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).nearestScope;
        },
        onSaved: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter Prescribed By';
          }
        },
        style: mediumTextStyle,
        decoration: InputDecoration(
          labelStyle: textFieldsHintTextStyle,
          hintStyle: textFieldsHintTextStyle,
          border: InputBorder.none,
          hintText: "Prescribed By",
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _mobileNumber() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _viewModel.mobileNumberTextController,
        obscureText: false,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).nearestScope;
        },
        onSaved: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            return 'enter contact';
          }
        },
        style: mediumTextStyle,
        decoration: InputDecoration(
          labelStyle: textFieldsHintTextStyle,
          hintStyle: textFieldsHintTextStyle,
          border: InputBorder.none,
          hintText: "Enter Mobile Number",
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget deliveryAdd() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        minLines: 3,
        maxLines: 4,
        enabled: true,
        controller: _viewModel.deliveryAddressTextController,
        obscureText: false,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).nearestScope;
        },
        onSaved: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            return 'enter delivery address';
          }
        },
        style: mediumTextStyle,
        decoration: InputDecoration(
          labelStyle: textFieldsHintTextStyle,
          hintStyle: textFieldsHintTextStyle,
          border: InputBorder.none,
          hintText: "Enter Delivery Address",
          contentPadding: EdgeInsets.zero,
          suffixIcon: InkWell(
            onTap: () async {
              var data = await Navigator.of(context)
                  .push(new MaterialPageRoute<String>(
                      builder: (BuildContext context) {
                        return new LocationSearchWidget();
                      },
                      fullscreenDialog: true));
              _viewModel.deliveryAddressTextController.text = data ?? '';
            },
            child: Icon(
              Icons.location_on,
              color: baseColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _expectedDeliveryDate() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: false,
        controller: _viewModel.deliveryDateTextController,
        obscureText: false,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).nearestScope;
        },
        onSaved: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            return 'enter delivery address';
          }
        },
        style: mediumTextStyle,
        decoration: InputDecoration(
          labelStyle: textFieldsHintTextStyle,
          hintStyle: textFieldsHintTextStyle,
          border: InputBorder.none,
          hintText: "Expected Delivery Date",
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  void _showDatePicker() {
    showDatePicker(
            context: _context,
            initialDate: DateTime.now().add(new Duration(days: 2)),
            //which date will display when user open the picker
            firstDate: DateTime.now().add(new Duration(days: 2)),
            //what will be the previous supported year in picker
            lastDate: DateTime.now().add(new Duration(
                days: 7))) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        return;
      } else {
        _viewModel.deliveryDateTextController.text =
            formatDate(pickedDate.toString().split(' ').first);
        _viewModel.deliveryDate = pickedDate.toString().split(' ').first;
      }
    });
  }
}
