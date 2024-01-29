import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/viewmodel/vitals/vitals_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../common_widgets/button_container.dart';
import '../../common_widgets/empty_list_widget.dart';
import '../../common_widgets/loader.dart';
import '../../constants/strings.dart';
import '../../constants/styles.dart';
import '../../enums/viewstate.dart';
import '../../models/vitals/get_vital_response.dart';
import '../../route/routes.dart';

class FillVitalsDetailsView extends StatefulWidget {
  GetVitalResponse _vitalResponse;
  bool isEdit = false;
  List<VitalsOptionModel> vitalOptionList;
  var familyMemberId;

  FillVitalsDetailsView(this._vitalResponse, this.isEdit, this.vitalOptionList,
      this.familyMemberId);

  @override
  State<FillVitalsDetailsView> createState() => _FillVitalsDetailsViewState();
}

class _FillVitalsDetailsViewState extends State<FillVitalsDetailsView> {
  final _formKey = GlobalKey<FormState>();
  BuildContext? _context;
  late VitalsViewModel _viewModel;

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController bmiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VitalsViewModel>.reactive(
        // onModelReady: (model) => model.getVitalByUserId(),
        builder: (context, viewModel, child) {
          _viewModel = viewModel;
          _context = context;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CommonAppBar(
              title: "Add Vitals",
              onBackPressed: () {
                Navigator.pop(context);
              },
              onClearPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.dashboardView, (route) => false);
              },
            ),
            body: _currentWidget(),
            bottomSheet: ButtonContainer(
                buttonText: _viewModel.isEdit ? edit : add,
                // buttonText: "Edit",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _viewModel.postvitalRequest.familyMemberId =
                        widget.familyMemberId;
                    _viewModel.postVitalInfo();
                  }
                  //   Scaffold.of(context).showSnackBar(new SnackBar(content: Text("successfully added") ));
                }),
            // body: _currentWidget(),
            // _viewModel.vitalResponse.height.toString();
          );
        },
        viewModelBuilder: () => widget.isEdit
            ? VitalsViewModel.edit(widget._vitalResponse, true)
            : VitalsViewModel());
  }

  Widget _body() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Visibility(
              visible: widget.vitalOptionList[0].isChecked,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            'Temperature(°F)',
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                    Expanded(child: _temperature()),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: widget.vitalOptionList[1].isChecked,
              child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                'Pulse(bpm)',
                                style: TextStyle(fontSize: 16),
                              )),
                        ),
                        Expanded(
                          child: _pulse(),
                        ),
                      ])),
            ),

            Visibility(
              visible: widget.vitalOptionList[2].isChecked,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Spo2(%)',
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                      Expanded(
                        child: _sp(),
                      ),
                    ]),
              ),
            ),

            Visibility(
              visible: widget.vitalOptionList[3].isChecked,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: _bp(),
              ),
            ),

            Visibility(
              visible: widget.vitalOptionList[4].isChecked ||
                  widget.vitalOptionList[5].isChecked ||
                  widget.vitalOptionList[6].isChecked,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Height(cm)',
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                      Expanded(child: _height()),
                    ]),
              ),
            ),

            Visibility(
              visible: widget.vitalOptionList[5].isChecked ||
                  widget.vitalOptionList[4].isChecked ||
                  widget.vitalOptionList[6].isChecked,
              child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Weight(kg)',
                              style: TextStyle(fontSize: 16),
                            )),
                        _weight(),
                      ])),
            ),

            Visibility(
              visible: false,
              child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                'BMI(kg/m2)',
                                style: TextStyle(fontSize: 16),
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: _bmi(),
                        ),
                      ])),
            ),

            //    ),
          ],
        ),
      ),
    );
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: _viewModel.loadingMsg,
        );

      case ViewState.Completed:
        return _body();

      case ViewState.Error:
        return const Center(
            child: Text(
          "Something went wrong",
          style: TextStyle(fontSize: 18),
        ));
      case ViewState.Empty:
        return EmptyListWidget("Nothing Found");
      default:
        return _body();
    }
  }

  Widget _height() {
    return Container(
        width: 200,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          controller: heightController,
          keyboardType: TextInputType.numberWithOptions(signed: true),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) {
            FocusScope.of(context).nearestScope;
          },
          onSaved: (value) {
            double currentBmi = heightController.text.isNotEmpty &&
                    weightController.text.isNotEmpty
                ? calculateBmi(
                    heightStr: heightController.text,
                    weight: weightController.text)
                : 0.0;
            _viewModel.postvitalRequest.height = int.parse(value ?? "0");
            _viewModel.postvitalRequest.bmi = currentBmi.toInt();
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
          },
          style: mediumTextStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: commonInputBorder(),
            errorBorder: commonInputBorder(),
            labelText: Height,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        ));
  }

  Widget _weight() {
    return Container(
        width: 200,
        margin: EdgeInsets.only(right: 10),
        child: TextFormField(
          controller: weightController,
          keyboardType: TextInputType.numberWithOptions(signed: true),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) {
            FocusScope.of(context).nearestScope;
          },
          onSaved: (value) {
            _viewModel.postvitalRequest.weight = int.parse(value ?? "0");
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            errorBorder: commonInputBorder(),
            border: commonInputBorder(),
            labelText: Weight,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        ));
  }

  OutlineInputBorder commonInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(width: 0.5),
      gapPadding: 5,
      // borderRadius: BorderRadius.circular(2),
    );
  }

  Widget _bmi() {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          controller: bmiController,
          keyboardType: TextInputType.numberWithOptions(signed: true),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) {
            FocusScope.of(context).nearestScope;
          },
          onSaved: (value) {
            int bmi = bmiController.text.isNotEmpty
                ? int.parse(bmiController.text)
                : 0;
            _viewModel.postvitalRequest.bmi = bmi;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            errorBorder: commonInputBorder(),
            border: commonInputBorder(),
            labelText: Bmi,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        ));
  }

  Widget _temperature() {
    return Container(
        width: 200,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) {
            FocusScope.of(context).nearestScope;
          },
          onSaved: (value) {
            _viewModel.postvitalRequest.temperature = value ?? "0";
            // "${_viewModel.vitalList.toString()??""}";
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,
          decoration: InputDecoration(
            border: commonInputBorder(),
            errorBorder: commonInputBorder(),
            labelText: Temperature,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        ));
  }

  Widget _bp() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
              child: Text('Blood Pressure (mmHg)',
                  style: TextStyle(fontSize: 18), maxLines: 2)),
          horizontalSpaceMedium,
          Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                        controller: _viewModel.systolicTextController,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                        ],
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          if (value.length == 3)
                            FocusScope.of(context).nextFocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'systolic',
                          hintStyle:
                              smallTextStyle.copyWith(color: Colors.grey),
                          border: InputBorder.none,
                        )),
                  ),
                  Text(
                    '/',
                    style: mediumTextStyle,
                  ),
                  horizontalSpaceTiny,
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: _viewModel.diastolicTextController,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: InputDecoration(
                        hintText: 'diastolic',
                        hintStyle: smallTextStyle.copyWith(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      onSaved: (value) {
                        _viewModel.postvitalRequest.systolic =
                            int.parse(_viewModel.systolicTextController.text);
                        _viewModel.postvitalRequest.diastolic =
                            int.parse(_viewModel.diastolicTextController.text);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pulse() {
    return Container(
        width: 200,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          keyboardType: TextInputType.numberWithOptions(signed: true),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) {
            FocusScope.of(context).nearestScope;
          },
          onSaved: (value) {
            _viewModel.postvitalRequest.pulse = int.parse(value ?? "0");
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: commonInputBorder(),
            errorBorder: commonInputBorder(),
            labelText: pulse,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        ));
  }

  Widget _sp() {
    return Container(
        width: 200,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          keyboardType: TextInputType.numberWithOptions(signed: true),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) {
            FocusScope.of(context).nearestScope;
          },
          onSaved: (value) {
            _viewModel.postvitalRequest.spo2 = int.parse(value ?? "0");
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: commonInputBorder(),
            errorBorder: commonInputBorder(),
            labelText: spo2,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        ));
  }

  double calculateBmi({required String heightStr, required String weight}) {
    if (heightStr.isNotEmpty && weight.isNotEmpty) {
      int height = int.parse(heightStr);
      double heightInMeters = height / 100;
      double weightInKg = double.parse(weight);
      double bmi = weightInKg / (heightInMeters * heightInMeters);
      return bmi;
    }
    // handle invalid input case
    return 0.0;
  }
}
