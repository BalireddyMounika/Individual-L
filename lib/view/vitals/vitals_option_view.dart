import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/search_view.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:stacked/stacked.dart';

import '../../common_widgets/empty_list_widget.dart';
import '../../common_widgets/loader.dart';
import '../../constants/styles.dart';
import '../../enums/viewstate.dart';
import '../../viewmodel/vitals/vitals_viewmodel.dart';

class VitalsOptionView extends StatefulWidget {
  const VitalsOptionView({Key? key}) : super(key: key);

  @override
  _vitalsState createState() => _vitalsState();
}

class _vitalsState extends State<VitalsOptionView> {
  late VitalsViewModel _viewModel;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VitalsViewModel>.reactive(
        viewModelBuilder: () => VitalsViewModel(),
        onModelReady: (model) => model.getFamilyMembersList(),
        builder: (context, viewModel, child) {
          _viewModel = viewModel;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CommonAppBar(
              title: "Add / Track Vitals",
              onBackPressed: () {
                Navigator.pop(context);
              },
              onClearPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.dashboardView, (route) => false);
              },
            ),
            body: _currentWidget(),
          );
        });
  }

  Widget _body() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        GestureDetector(
          onTap: () {
            var map = Map();
            map['familyMemberId'] = null;
            locator<NavigationService>()
                .navigateTo(Routes.chooseVitalsView, arguments: map  );
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Container(child: Image.asset('images/vitals/avatar.png')),
                  verticalSpaceSmall,
                  Container(
                    child: Text(
                      'My Self',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        verticalSpaceMedium,
        GestureDetector(
          onTap: () {
            showFamilyMember();
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Container(child: Image.asset('images/vitals/avatar.png')),
                  verticalSpaceSmall,
                  Container(
                    child: Text(
                      'For Family Members',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void showFamilyMember (){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.all(20),
            child:
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Select Family Members",
                        style:
                        mediumTextStyle.copyWith(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      verticalSpaceLarge,
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: _viewModel.familyMemberList.length,
                          itemBuilder: (context, index){
                            return Container(
                              height: kToolbarHeight - 10,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 0.2))),
                              child: GestureDetector(
                                onTap:(){
                                  var map = Map();
                                  map['familyMemberId'] = _viewModel.familyMemberList[index].id;
                                  locator<NavigationService>().navigateTo(Routes.chooseVitalsView, arguments: map );
                                },
                                child: Center(
                                  child: Text(
                                    "${_viewModel.familyMemberList[index].firstName} ${_viewModel.familyMemberList[index].lastName}",
                                    style: largeTextStyle.copyWith(
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            );
                          })
                    ],
                  )),
            ),
          );
        });
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
}
