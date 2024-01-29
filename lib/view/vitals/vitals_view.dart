import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/tools/date_formatting.dart';
import 'package:life_eazy/viewmodel/vitals/vitals_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../constants/colors.dart';
import '../../constants/margins.dart';
import '../../constants/screen_constants.dart';
import '../../constants/styles.dart';

class VitalsView extends StatefulWidget {
  @override
  _vitalsState createState() => _vitalsState();
}

class _vitalsState extends State<VitalsView> {
  late BuildContext _context;
  late VitalsViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VitalsViewModel>.reactive(
      onViewModelReady: (model) {
        // Future.wait([model.getFamilyMembersList(),model.getVitalByUserId()]);
        model.getFamilyMembersList();
        // model.getVitalByUserId();
      },
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        _context = context;
        return Scaffold(
          appBar: CommonAppBar(
            title: 'Vitals',
            onBackPressed: () {
              if (Navigator.canPop(context))
                Navigator.pop(context);
              else
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.dashboardView, (route) => false);
            },
            onClearPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.dashboardView, (route) => false);
            },
          ),
          body: _currentWidget(),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                offset: Offset(0, 0.2),
                blurRadius: 5,
                color: Color.fromRGBO(0, 0, 0, 0.5),
              )
            ]),
            height: 56,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      print('object');
                      _viewModel.getVitalByUserId();
                    },
                    child: ColoredBox(
                      color: !_viewModel.isFamilyMemberSelected
                          ? baseColor
                          : Colors.white,
                      child: Center(
                        child: Text(
                          'Self',
                          style: mediumTextStyle.copyWith(
                              color: !_viewModel.isFamilyMemberSelected
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_viewModel.familyMemberList.isNotEmpty) {
                        _viewModel.handleBottomBar();
                      }
                    },
                    child: ColoredBox(
                      color: _viewModel.isFamilyMemberSelected &&
                              _viewModel.familyMemberList.isNotEmpty
                          ? baseColor
                          : whiteColor,
                      child: Center(
                        child: Text(
                          'Family',
                          style: mediumTextStyle.copyWith(
                              color: _viewModel.isFamilyMemberSelected
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => VitalsViewModel(),
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
        return _defaultContainer();
      default:
        return _defaultContainer();
    }
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: _viewModel.vitalList.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: _viewModel.isFamilyMemberSelected,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("From Family Members : "),
                        GestureDetector(
                          onTap: () {
                            bottomFamilyMemberSelection();
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(standardBorderRadius),
                              border: Border.all(color: baseColor),
                            ),
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${_viewModel.selectedFamilyMember.firstName} ${_viewModel.selectedFamilyMember.lastName ?? ""}'),
                                    Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 24,
                                    )
                                  ],
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      commonCard('Weight',
                          '${_viewModel.fillVitals.weight.toString()}', 'kg',
                          key: "Weight"),
                      commonCard('Height',
                          '${_viewModel.fillVitals.height.toString()}', 'cm',
                          key: "Height"),
                    ],
                  ),
                  Row(
                    children: [
                      commonCard('BMI',
                          '${_viewModel.fillVitals.bmi.toString()}', 'Kg/m2',
                          key: "BMI"),
                      commonCard(
                          'Temperature',
                          '${_viewModel.fillVitals.temperature.toString()}',
                          '°F',
                          key: "Temperature"),
                    ],
                  ),
                  Row(
                    children: [
                      commonCard('Spo2',
                          '${_viewModel.fillVitals.spo2.toString()}', '%',
                          key: "Spo2"),
                      commonCard(
                        'BP',
                        '${_viewModel.fillVitals.systolic.toString()}/${_viewModel.fillVitals.diastolic.toString()}',
                        'mmHg',
                        key: "systolic",
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonCard('Pulse',
                            '${_viewModel.fillVitals.pulse.toString()}', 'bpm',
                            key: "Pulse"),
                      ],
                    ),
                  )
                ],
              )
            : EmptyListWidget('No Vitals Available'),
      ),
    );
  }

  Widget commonCard(String name, String value, String units,
      {String key = ""}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Map map = new Map();
          map['vitalList'] = _viewModel.isFamilyMemberSelected == false
              ? _viewModel.vitalList
                  .where((element) =>
                      !element[key].toString().contains("0") ||
                      element[key].toString().length > 1)
                  .toList()
                  .where((element) => element["FamilyMemberId"] == null)
                  .toList()
              : _viewModel.vitalList
                  .where((element) =>
                      !element[key].toString().contains("0") ||
                      element[key].toString().length > 1)
                  .toList()
                  .where((element) =>
                      element["FamilyMemberId"] ==
                      _viewModel.selectedFamilyMember.id)
                  .toList();
          map["name"] = name;
          map["unit"] = units;
          map["tileKey"] = key;
          map["familyId"] = _viewModel.isFamilyMemberSelected == true
              ? _viewModel.selectedFamilyMember.id
              : -1;

          locator<NavigationService>()
              .navigateTo(Routes.vitalDetailView, arguments: map);
        },
        child: Container(
          margin: EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            //  border: Border.all(color: Colors.blueGrey, width: 1.2,),
            borderRadius: const BorderRadius.all(Radius.circular(18)),
          ),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(fontSize: 24, color: baseColor),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        units,
                        style: const TextStyle(fontSize: 14.0, height: 2),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Text(
                    'Update on: ${_viewModel.updatedDateVitals[key] == "NA" || _viewModel.updatedDateVitals[key] == null ? "NA" : formatDate(_viewModel.updatedDateVitals[key]!.split('T').first)}',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: smallTextStyle.copyWith(color: disableColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _defaultContainer() {
    //this is default container
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
      child: Wrap(
        spacing: 15,
        runSpacing: 15,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Column(
            children: [
              Visibility(
                visible: _viewModel.isFamilyMemberSelected,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("From Family Members : "),
                    GestureDetector(
                      onTap: () {
                        bottomFamilyMemberSelection();
                      },
                      child: Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(standardBorderRadius),
                          border: Border.all(color: baseColor),
                        ),
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${_viewModel.selectedFamilyMember.firstName} ${_viewModel.selectedFamilyMember.lastName ?? ""}'),
                                Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  size: 24,
                                )
                              ],
                            )),
                      ),
                    )
                  ],
                ),
              ),
              verticalSpaceMedium,
              Row(
                children: [
                  defaultCard('Weight', '--/--', 'kg'),
                  defaultCard('Height', '--/--', 'cm'),
                ],
              ),
              Row(
                children: [
                  defaultCard('BMI', '--/--', 'Kg/m2'),
                  defaultCard('Temperature', '--/--', '°F'),
                ],
              ),
              Row(
                children: [
                  defaultCard('Spo2', '--/--', '%'),
                  defaultCard('BP', '--/--', 'mmhg'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget defaultCard(String name, String value, String units,
      {String key = ""}) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        Map map = new Map();
        map['vitalList'] = [];
        map["name"] = name;
        map["unit"] = units;
        map["tileKey"] = key;
        map["familyId"] = _viewModel.isFamilyMemberSelected == true
            ? _viewModel.selectedFamilyMember.id
            : -1;

        locator<NavigationService>()
            .navigateTo(Routes.vitalDetailView, arguments: map);
      },
      child: Container(
          margin: EdgeInsets.all(5),
          height: 120,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            //  border: Border.all(color: Colors.blueGrey, width: 1.2,),
            borderRadius: const BorderRadius.all(Radius.circular(18)),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                      ),
                      const Icon(
                        Icons.more_horiz,
                        size: 24.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        value,
                        style: const TextStyle(fontSize: 37.0, height: 1),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        units,
                        style: const TextStyle(
                            fontSize: 15.0,
                            height: 2,
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                ),
              ])),
    ));
  }

  void bottomFamilyMemberSelection() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.only(
                left: displayWidth(context) * .4,
                right: displayWidth(context) * .4,
                top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0))
            ),
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Family Members",
                      style: mediumTextStyle.copyWith(color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _viewModel.updateVitalsByCurrentSelectedMember();
                      },
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
                verticalSpaceMedium,
                Expanded(
                  child: ListView.builder(
                      itemCount: _viewModel.familyMemberList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _viewModel.updateVitalsByCurrentSelectedMember(
                                index: index);
                          },
                          child: Container(
                            height: kToolbarHeight - 10,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0.2))),
                            child: Center(
                                child: Text(
                                    "${_viewModel.familyMemberList[index].firstName} ${_viewModel.familyMemberList[index].lastName}",
                                    style: largeTextStyle.copyWith(
                                        color: baseColor))),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }
}
