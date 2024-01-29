import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:stacked/stacked.dart';

import '../../viewmodel/vitals/vitals_viewmodel.dart';

class ChooseVitalsView extends StatefulWidget {
  var familyMemberId ;
   ChooseVitalsView(
        this.familyMemberId,
      );



  @override
  _vitalsState createState() => _vitalsState();
}

class _vitalsState extends State<ChooseVitalsView> {
  late VitalsViewModel _viewModel;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VitalsViewModel>.reactive(
        viewModelBuilder: () => VitalsViewModel(),
        // onModelReady: (model) => model.fillVitalsOption(),
        builder: (context, viewModel, child) {
          _viewModel = viewModel;
          return Scaffold(
              bottomSheet: ButtonContainer(
                buttonText: "Next",
                onPressed: () {
                  var map = new Map();
                  map["VitalResponse"] = _viewModel.getvitalResponse;
                  map['isEdit'] = false;
                  map['VitalOptionList'] = _viewModel.vitalOptionList;
                  map['familyMemberId'] = widget.familyMemberId;
                  locator<NavigationService>().navigateTo(Routes.fillVitalsDetailsView, arguments: map);
                },
              ),
              backgroundColor: Colors.white,
              appBar: CommonAppBar(
                title: "Choose Vitals",
                onBackPressed: () {
                  Navigator.pop(context);
                },
                onClearPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.dashboardView, (route) => false);
                },
              ),
              body: ListView.builder(
                  itemCount: _viewModel.vitalOptionList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Card(
                        child: CheckboxListTile(
                            activeColor: baseColor,
                            checkColor: whiteColor,
                            title:
                                Text(_viewModel.vitalOptionList[index].name!),
                            value: _viewModel.vitalOptionList[index].isChecked,
                            onChanged: (newValue) {
                              _viewModel.changeInitialValueToNewValue(
                                  newValue, index);
                            }),
                      ),
                    );
                  }));
        });
  }
}
