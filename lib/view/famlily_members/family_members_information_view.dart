import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/common_widgets/network_image_widget.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/enums/snackbar_types.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/models/family_members/get_family_members_response.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/viewmodel/family_members/family_members_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../get_it/locator.dart';
import '../../net/session_manager.dart';

class FamilyMembersInformationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FamilyMembersInformationView();
}

class _FamilyMembersInformationView
    extends State<FamilyMembersInformationView> {
  int _lisCount = 3;
  late FamilyMembersViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FamilyMembersViewModel>.reactive(
      onModelReady: (model) => model.getFamilyMembersList(),
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            bottomSheet: ButtonContainer(
              buttonText: add,
              onPressed: () {
                if (SessionManager.getUser.firstName != null) {
                  if (viewModel.familyMemberList.length < 4) {
                    Map maps = Map();
                    maps['profileResponse'] = new GetFamilyMemberResponse();
                    maps['isEdit'] = false;
                    Navigator.pushNamed(
                        context, Routes.addFamilyMembersInformationView,
                        arguments: maps);
                  } else {
                    locator<SnackBarService>().showSnackBar(
                        title: "Only four family members allowed",
                        snackbarType: SnackbarType.error);
                  }
                } else {
                  locator<SnackBarService>().showSnackBar(
                      title: "Fill your profile before adding family members",
                      snackbarType: SnackbarType.error);
                }
              },
            ),
            appBar: CommonAppBar(
              title: emergencyInfo,
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
            body: _currentWidget());
      },
      viewModelBuilder: () => FamilyMembersViewModel(),
    );
  }

  Widget _listContainerItem(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
        ),
        Center(
          child: Text(
            title,
            style: mediumTextStyle.copyWith(color: darkColor, fontSize: 15),
          ),
        ),
        Text(
          data,
          textAlign: TextAlign.end,
          style: mediumTextStyle.copyWith(color: Colors.black, fontSize: 15),
        )
        // Expanded(
        //     flex: 1,
        //     child: Text(
        //       title,
        //       style: mediumTextStyle.copyWith(color: darkColor),
        //     )),
        // Expanded(
        //     flex: 1,
        //     child: Text(data,
        //         textAlign: TextAlign.end,
        //         style: mediumTextStyle.copyWith(color: Colors.black))),
      ],
    );
  }

  Widget _body() {
    return Container(
      margin: dashBoardMargin,
      child: Stack(
        children: [
          _viewModel.familyMemberList.length == 0
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          addDependentInformation,
                          style: largeTextStyle,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: kToolbarHeight + 30),
                  shrinkWrap: true,
                  itemCount: _viewModel.familyMemberList.length,
                  itemBuilder: (context, index) {
                    return _listContainer(index);
                  }),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Padding(
          //     padding: const EdgeInsets.only(bottom: buttonBottomPadding),
          //     child: ButtonContainer(
          //       buttonText: add,
          //       onPressed: () {
          //         Map maps = Map();
          //         maps['profileResponse'] = new GetFamilyMemberResponse();
          //         maps['isEdit'] = false;
          //         Navigator.pushNamed(
          //             context, Routes.addFamilyMembersInformationView,
          //             arguments: maps);
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: "Loading Family Members",
          loadingMsgColor: Colors.black,
        );

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

  Widget _topview(index) {
    var data = _viewModel.familyMemberList[index];
    return Container(
      child: Card(
        elevation: standardCardElevation,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Row(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      //height: 50,
                      child: (Image.network(_viewModel.profileImage)),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Text("${_viewModel.familyMemberInfoRequest.firstname}")
                        _listContainerItem(
                            "", '${data.firstName} ${data.lastName}' ?? ''),
                        SizedBox(
                          height: 10,
                        ),
                        _listContainerItem(
                            "", data.relationshipToPatient ?? ""),
                        SizedBox(
                          height: 10,
                        ),
                        _listContainerItem("Is Emergency ?",
                            "${data.isEmergency == true ? "YES" : "NO"}"),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Map maps = Map();
                                  maps['profileResponse'] = data;
                                  maps['isEdit'] = true;
                                  Navigator.pushNamed(context,
                                      Routes.addFamilyMembersInformationView,
                                      arguments: maps);
                                },
                                child: Icon(Icons.edit,
                                    color: baseColor, size: 30)),
                            SizedBox(
                              width: 15,
                            ),
                            Visibility(
                              visible: false,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_lisCount >= 1)
                                        _lisCount = _lisCount - 1;
                                    });
                                  },
                                  child: Icon(Icons.delete,
                                      color: Colors.red, size: 30)),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listContainer(index) {
    var data = _viewModel.familyMemberList[index];
    return Container(
        child: Card(
            elevation: standardCardElevation,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 10,
                            width: 15,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            child: ClipOval(
                              child: NetworkImageWidget(
                                  imageName: _viewModel.familyMemberList[index]
                                          .profilePicture ??
                                      "",
                                  width: 50,
                                  height: 50),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _listContainerItem(
                                "", '${data.firstName} ${data.lastName}' ?? ''),
                            SizedBox(
                              height: 10,
                            ),
                            _listContainerItem(
                                "", data.relationshipToPatient ?? ""),
                            SizedBox(
                              height: 10,
                            ),
                            _listContainerItem("Is Emergency ? ",
                                "${data.isEmergency == true ? "YES" : "NO"}"),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Map maps = Map();
                                      maps['profileResponse'] = data;
                                      maps['isEdit'] = true;
                                      Navigator.pushNamed(
                                          context,
                                          Routes
                                              .addFamilyMembersInformationView,
                                          arguments: maps);
                                    },
                                    child: Icon(Icons.edit,
                                        color: baseColor, size: 30)),
                                SizedBox(
                                  width: 15,
                                ),
                                Visibility(
                                  visible: false,
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (_lisCount >= 1)
                                            _lisCount = _lisCount - 1;
                                        });
                                      },
                                      child: Icon(Icons.delete,
                                          color: Colors.red, size: 30)),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ]))));
  }
}
