import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/common_widgets/network_image_widget.dart';
import 'package:life_eazy/common_widgets/search_view.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/enums/snackbar_types.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/appointments/DoctorListResponse.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/viewmodel/appointments/appointments_view_model.dart';
import 'package:stacked/stacked.dart';

class AppointmentsView extends StatefulWidget {
  bool isFromSpecialization = false;
  String specialist = "";
  AppointmentsView({this.isFromSpecialization = false, this.specialist = ""});
  @override
  State<StatefulWidget> createState() => _DoctorAppointmentView();
}

class _DoctorAppointmentView extends State<AppointmentsView> {
  late AppointmentsViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppointmentsViewModel>.reactive(
      onViewModelReady: (model) => model.getDoctorsList(),
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: CommonAppBar(
              title: bookAppointment,
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
      viewModelBuilder: () => AppointmentsViewModel(
          isFromSpecialization: widget.isFromSpecialization,
          specialist: widget.specialist),
    );
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: "Fetching Doctors",
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
    return Container(
        margin: dashBoardMargin,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchView(
              onChanged: (value) {
                _viewModel.searchFilter(value);
              },
            ),
            verticalSpaceMedium,
            Container(
              height: kToolbarHeight - 21,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: _viewModel.filterOptionList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _viewModel.filterManager(
                            _viewModel.filterOptionList[index].index,
                            _viewModel.filterOptionList[index].status,
                            _viewModel.filterOptionList[index].name,
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 140,
                          decoration: BoxDecoration(
                            color: _viewModel.filterOptionList[index].status ==
                                    true
                                ? baseColor
                                : Colors.white,
                            border: Border.all(color: baseColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Center(
                              child: Text(
                                _viewModel.filterOptionList[index].name,
                                style: bodyTextStyle.copyWith(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            verticalSpaceMedium,
            _viewModel.activeDoctorList.length >= 1
                ? Flexible(
                    flex: 1,
                    child: ListView.builder(
                        itemCount: _viewModel.tempDoctorList.length,
                        itemBuilder: (context, index) {
                          return _activeContainer(index);
                        }),
                  )
                : EmptyListWidget("Nothing Found"),
          ],
        ));
  }

  Widget _activeContainer(index) {
    var image = "";
    if (_viewModel.tempDoctorList[index].profile?.profilePicture != null) {
      image = _viewModel.tempDoctorList[index].profile!.profilePicture ?? "";
    }

    return Container(
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
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
                          child: NetworkImageWidget(
                            imageName: image,
                            height: 50,
                            width: 50,
                          ),
                        ),
                      )),
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
                            Text(
                              "Dr ${_viewModel.tempDoctorList[index].firstname ?? ""} ${_viewModel.tempDoctorList[index].lastname ?? ""}",
                              style: mediumTextStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          _viewModel.tempDoctorList[index].professional
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
                              color: _viewModel.tempDoctorList[index].scheduleV2
                                          ?.any((element) =>
                                              element.typeConsultation ==
                                              TypeConsultation.HOME) ??
                                      false
                                  ? Color(0xbb6d3670)
                                  : disableColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.video_call_sharp,
                                size: 26,
                                color: _viewModel
                                            .tempDoctorList[index].scheduleV2
                                            ?.any((element) =>
                                                element.typeConsultation ==
                                                TypeConsultation
                                                    .TELECONSULTATION) ??
                                        false
                                    ? baseColor
                                    : disableColor),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.local_hospital,
                              size: 28,
                              color: _viewModel.tempDoctorList[index].scheduleV2
                                          ?.any((element) =>
                                              element.typeConsultation ==
                                              TypeConsultation.INCLINIC) ??
                                      false
                                  ? Color(0xbbf2b416)
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
                height: 10,
              ),
              Divider(
                thickness: 1,
                color: darkColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Map<String, dynamic> args = new Map();
                      args['doctorId'] = _viewModel.tempDoctorList[index].id;
                      locator<NavigationService>()
                          .navigateTo(Routes.doctorDetailView, arguments: args);
                    },
                    child: SizedBox(
                      width: 100,
                      child: Text(
                        "View Details",
                        style: bodyTextStyle.copyWith(color: darkColor),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (SessionManager.getUser.firstName != null) {
                        Map<String, dynamic> args = new Map();
                        args['doctorDetails'] =
                            _viewModel.tempDoctorList[index];
                        locator<NavigationService>().navigateTo(
                            Routes.doctorAppointmentBookingSlotsView,
                            arguments: args);
                      } else
                        locator<SnackBarService>().showSnackBar(
                            title: "Fill Profile before booking appointments",
                            snackbarType: SnackbarType.error);
                    },
                    child: Container(
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius:
                              BorderRadius.circular(standardBorderRadius)),
                      child: Center(
                        child: Text(
                          "Book",
                          style: bodyTextStyle.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
