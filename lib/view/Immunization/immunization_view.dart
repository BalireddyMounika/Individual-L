import 'package:flutter/material.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/enums/snackbar_types.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/viewmodel/Immunization/immunization_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../common_widgets/common_appbar.dart';
import '../../common_widgets/empty_list_widget.dart';
import '../../common_widgets/loader.dart';
import '../../constants/colors.dart';
import '../../constants/margins.dart';
import '../../constants/screen_constants.dart';
import '../../constants/strings.dart';
import '../../constants/styles.dart';
import '../../enums/viewstate.dart';
import '../../get_it/locator.dart';
import '../../route/routes.dart';
import '../../tools/date_formatting.dart';

class ImmunizationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImmunizatinView();
}

class _ImmunizatinView extends State<ImmunizationView> {
  late ImmunizationViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImmunizationViewModel>.reactive(
      onViewModelReady: (model) {
        Future.wait([model.getFamilyMembersList(), model.getImmunization()]);
      },
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: CommonAppBar(
            title: immuneVaccine,
            isClearButtonVisible: true,
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
            width: screenHeight(context),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _viewModel.getSelfImmunizationList();
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
                        _viewModel.getFamilyImmunizationList();
                      } else {
                        locator<SnackBarService>().showSnackBar(
                            title: "Please add Family Member first",
                            snackbarType: SnackbarType.info,
                            duration: 3);
                      }
                    },
                    child: ColoredBox(
                      color: _viewModel.isFamilyMemberSelected &&
                              _viewModel.familyMemberList.isNotEmpty
                          ? baseColor
                          : Colors.white,
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
      viewModelBuilder: () => ImmunizationViewModel(),
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

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: _viewModel.isFamilyMemberSelected,
          child: Container(
            margin: dashBoardMargin,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(" Immunization Of : "),
                GestureDetector(
                  onTap: () {
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
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  verticalSpaceMedium,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Select Family Members",
                                        style: mediumTextStyle.copyWith(
                                            color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          _viewModel
                                              .updateImmunizationByCurrentSelectedMember(
                                                  -1);
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
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        _viewModel.familyMemberList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          _viewModel
                                              .updateImmunizationByCurrentSelectedMember(
                                                  index);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: kToolbarHeight - 10,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.2))),
                                          child: Center(
                                            child: Text(
                                              '${_viewModel.familyMemberList[index].firstName} ${_viewModel.familyMemberList[index].lastName}',
                                              style: largeTextStyle.copyWith(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(standardBorderRadius),
                      border: Border.all(color: baseColor),
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${_viewModel.currentSelectedMember.firstName}    ${_viewModel.currentSelectedMember.lastName}"),
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
        ),
        SizedBox(
          height: 34,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ListView.builder(
            itemCount: _viewModel.immunizationList.length,
            //itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return _listContainer(index);
            },
          ),
        ))
      ],
    );
  }

  Widget _listContainer(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: immunizationContainerColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(blurRadius: 5, color: Colors.grey),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 30, top: 10),
                        child: Visibility(
                          visible: _viewModel.fromFamilyMembers(index),
                          child: Text("Date",
                              style: smallTextStyle.copyWith(
                                color: immunizationDateColor,
                              )),
                        )),
                    Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Visibility(
                          visible: _viewModel.fromFamilyMembers(index),
                          child: Text(
                              _viewModel.immunizationList[index].immunizationId!.length >=
                                      1
                                  ? _viewModel.isFamilyMemberSelected == true &&
                                          _viewModel.immunizationList[index].immunizationId!.where((element) => element.familyId == _viewModel.currentSelectedMember.id).length >=
                                              1
                                      ? formatDate(_viewModel
                                              .immunizationList[index]
                                              .immunizationId!
                                              .where((element) =>
                                                  element.familyId ==
                                                  _viewModel
                                                      .currentSelectedMember.id)
                                              .first
                                              .dateOfImmunization
                                              ?.split('T')
                                              .first ??
                                          "")
                                      : formatDate(_viewModel
                                              .immunizationList[index]
                                              .immunizationId
                                              ?.first
                                              .dateOfImmunization
                                              ?.split('T')
                                              .first ??
                                          "")
                                  : "NA",
                              style: smallTextStyle.copyWith(
                                  color: immunizationDateColor,
                                  fontWeight: FontWeight.bold)),
                        )),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (_viewModel.fromFamilyMembers(index) == false) {
                      Map map = new Map();
                      map["selectedItem"] = _viewModel.immunizationList[index];
                      locator<NavigationService>().navigateTo(
                          Routes.addImmunizationView,
                          arguments: map);
                    } else {
                      Map map = new Map();
                      map["response"] = _viewModel.immunizationList[index];
                      locator<NavigationService>().navigateTo(
                          Routes.immunizationDetailView,
                          arguments: map);
                    }
                  },

                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    child: _viewModel.fromFamilyMembers(index) == false
                        ? Icon(
                            Icons.add,
                            color: whiteColor,
                          )
                        : Icon(
                            Icons.visibility,
                            color: whiteColor,
                          ),
                  ),

                  // child: Icon(
                  //   Icons.visibility,
                  //   color: whiteColor,
                  //   size: 25.0,
                  // ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                _viewModel.immunizationList[index].vaccine ?? "",
                style: bodyTextStyle.copyWith(
                    color: blackColor, fontWeight: FontWeight.bold),
              ),
            ),
            verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    _viewModel.fromFamilyMembers(index) == false
                        ? "Pending"
                        : "Done",
                    style: bodyTextStyle.copyWith(
                        color: _viewModel.fromFamilyMembers(index) == false
                            ? Colors.red
                            : Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
