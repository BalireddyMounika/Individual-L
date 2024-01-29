import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/common_widgets/network_image_widget.dart';
import 'package:life_eazy/common_widgets/search_view.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/viewmodel/prefer_physician/prefer_physician_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PreferPhysiciansView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PreferPhysiciansView();
}

class _PreferPhysiciansView extends State<PreferPhysiciansView> {
  late PreferedPhysicianViewModel _viewModel;

  get dialogType => null;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PreferedPhysicianViewModel>.reactive(
      onModelReady: (model) => model.getPreferPhysicianList(),
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            bottomSheet: ButtonContainer(
              buttonText: add,
              height: 45,
              onPressed: () {
                Navigator.pushNamed(context, Routes.addPreferPhysicianView);
              },
            ),
            appBar: CommonAppBar(
              title: preferredPhysician,
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
      viewModelBuilder: () => PreferedPhysicianViewModel(),
    );
  }

  Widget _body() {
    return Container(
      margin: dashBoardMargin,
      child: Column(
        children: [
          SearchView(
            onChanged: (value) {
              _viewModel.searchFilter(value);
            },
          ),
          Flexible(
              flex: 1,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 5),
                  itemCount: _viewModel.preferPhysicianList.length,
                  itemBuilder: (context, index) {
                    return _activeContainer(
                        _viewModel.preferPhysicianList.length - (index + 1));
                  })),
        ],
      ),
    );
  }

  Widget _activeContainer(index) {
    var image = "";
    if (_viewModel.preferPhysicianList[index].profile != null) {
      image =
          _viewModel.preferPhysicianList[index].profile!.profilePicture ?? "";
    }
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Card(
        elevation: standardCardElevation,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              //_popup(),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      height: 50,
                      width: 50,
                      child: ClipOval(
                          child: image == ""
                              ? Image.asset(
                                  "images/dashboard/profile_dummy.png")
                              : NetworkImageWidget(
                                  imageName: image, width: 50, height: 50)),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 8,
                              child: Text(
                                "Dr. ${_viewModel.preferPhysicianList[index].firstname ?? ""} ${_viewModel.preferPhysicianList[index].lastname ?? ""}",
                                style: mediumTextStyle,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextButton(
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                          content: const Text(
                                            'Are you sure you want to remove',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          actions: <Widget>[
                                        ButtonContainer(
                                          buttonText: 'No',
                                          onPressed: () => Navigator.pop(
                                            context,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ButtonContainer(
                                          buttonText: 'Yes',
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _viewModel.deletePreferPhysician(
                                                _viewModel
                                                        .preferPhysicianResponse[
                                                            index]
                                                        .id ??
                                                    0);
                                          },
                                        ),
                                        // FlatButton(
                                        //   minWidth: 10,
                                        //   child: Text(
                                        //     'Yes',
                                        //     style: TextStyle(
                                        //         color: Colors.white,
                                        //         fontSize: 14),
                                        //   ),
                                        //   color: Colors.grey,
                                        //   onPressed: () {
                                        //     Navigator.pop(context);
                                        //     _viewModel.deletePreferPhysician(
                                        //         _viewModel
                                        //                 .preferPhysicianResponse[
                                        //                     index]
                                        //                 .id ??
                                        //             0);
                                        //   },
                                        // ),
                                      ]),
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _viewModel.preferPhysicianList[index].professional
                                  ?.specialization ??
                              "",
                          style: bodyTextStyle.copyWith(color: darkColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.home,
                              size: 26,
                              color: _viewModel.preferPhysicianList[index]
                                          .professional?.appointmentType
                                          ?.contains("Home") ==
                                      true
                                  ? baseColor
                                  : disableColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.video_call_sharp,
                              size: 26,
                              color: _viewModel.preferPhysicianList[index]
                                          .professional?.appointmentType
                                          ?.contains("Teleconsultation") ==
                                      true
                                  ? baseColor
                                  : disableColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.local_hospital,
                              size: 28,
                              color: _viewModel.preferPhysicianList[index]
                                          .professional?.appointmentType
                                          ?.contains("In-clinic") ==
                                      true
                                  ? baseColor
                                  : disableColor,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 2,
              ),
              Divider(
                thickness: 1,
                color: darkColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                    visible:
                        _viewModel.preferPhysicianList[index].schedule != null,
                    child: InkWell(
                        onTap: () {
                          Map<String, dynamic> args = new Map();
                          args['doctorDetails'] =
                              _viewModel.preferPhysicianList[index];
                          locator<NavigationService>().navigateTo(
                              Routes.doctorDetailView,
                              arguments: args);
                        },
                        child: Text('view details')),
                  ),
                  _viewModel.preferPhysicianList[index].schedule == null
                      ? Text(
                          "InActive",
                          style: mediumTextStyle.copyWith(color: Colors.red),
                        )
                      : !_viewModel.preferPhysicianList[index].schedule!.toDate!
                              .isBefore(DateTime.now())
                          ? SizedBox()
                          : Text(
                              "InActive",
                              style:
                                  mediumTextStyle.copyWith(color: Colors.red),
                            ),
                  GestureDetector(
                    onTap: () {
                      if (_viewModel.preferPhysicianList[index].schedule !=
                          null) {
                        if (!_viewModel
                            .preferPhysicianList[index].schedule!.toDate!
                            .isBefore(DateTime.now())) {
                          Map<String, dynamic> args = new Map();
                          args['doctorDetails'] =
                              _viewModel.preferPhysicianList[index];
                          locator<NavigationService>().navigateTo(
                              Routes.doctorAppointmentBookingSlotsView,
                              arguments: args);
                        }
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          color:
                              _viewModel.preferPhysicianList[index].schedule ==
                                      null
                                  ? Colors.grey
                                  : !_viewModel.preferPhysicianList[index]
                                          .schedule!.toDate!
                                          .isBefore(DateTime.now())
                                      ? baseColor
                                      : Colors.grey,
                          borderRadius:
                              BorderRadius.circular(standardBorderRadius)),
                      child: Center(
                        child: Text(
                          "Book",
                          style: bodyTextStyle.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: "Fetching Preferred Doctors",
          loadingMsgColor: Colors.black,
        );

      case ViewState.Completed:
        return _body();

      case ViewState.Empty:
        return EmptyListWidget("Nothing Found");
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
}
