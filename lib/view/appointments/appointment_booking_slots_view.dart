import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/network_image_widget.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/screen_constants.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/enums/appointment_status.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/appointments/appointment_request.dart';
import 'package:life_eazy/models/appointments/doctor_details_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/tools/date_formatting.dart';
import 'package:life_eazy/view/appointments/widget/symptom_view_widget.dart';
import 'package:life_eazy/viewmodel/appointments/doctor_appointment_booking_slots_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../common_widgets/loader.dart';
import '../../enums/viewstate.dart';
import '../../services/common_service/snackbar_service.dart';
import '../../tools/time_formatting.dart';

class AppointmentBookingSlotsView extends StatefulWidget {
  DoctorDetailResponse _doctorDetailResponse;
  AppointmentBookingSlotsView(this._doctorDetailResponse);
  @override
  State<StatefulWidget> createState() => _DoctorAppointmentBookingSlotsView();
}

class _DoctorAppointmentBookingSlotsView
    extends State<AppointmentBookingSlotsView> {
  late DoctorAppointmentBookingSlotsViewModel _viewModel;
  // var _items = ["9.00 AM ", "10.00 AM", "11.00 AM", "12.00 PM", "13.00 PM"];
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DoctorAppointmentBookingSlotsViewModel>.reactive(
      onViewModelReady: (model) => model.getFamilyMembersList(),
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
      viewModelBuilder: () =>
          DoctorAppointmentBookingSlotsViewModel(widget._doctorDetailResponse),
    );
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: "",
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

  Widget _body() {
    var image = "";
    if (widget._doctorDetailResponse.profile != null) {
      image = widget._doctorDetailResponse.profile!.profilePicture ?? "";
    }

    return SingleChildScrollView(
      child: Container(
        margin: authMargin,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: _viewModel.familyMemberList.length == 0 ? false : true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("For : "),
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
            _viewModel.familyMemberList.length == 0
                ? verticalSpaceSmall
                : verticalSpaceLarge,
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
                            ? Image.asset("images/dashboard/profile_dummy.png")
                            : NetworkImageWidget(
                                imageName: image,
                                width: 50,
                                height: 50,
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
                      Text(
                        "Dr ${widget._doctorDetailResponse.firstname ?? ""}   ${widget._doctorDetailResponse.lastname ?? ""}",
                        style: mediumTextStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget._doctorDetailResponse.professional
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
                            color: widget._doctorDetailResponse.professional
                                        ?.appointmentType
                                        ?.contains("Home") ==
                                    true
                                ? redColor
                                : disableColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.video_call_sharp,
                            size: 26,
                            color: widget._doctorDetailResponse.professional
                                        ?.appointmentType
                                        ?.contains("Teleconsultation") ==
                                    true
                                ? redColor
                                : disableColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.local_hospital,
                            size: 28,
                            color: widget._doctorDetailResponse.professional
                                        ?.appointmentType
                                        ?.contains("In-clinic") ==
                                    true
                                ? redColor
                                : disableColor,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Divider(
              thickness: 1,
              color: darkColor,
            ),
            verticalSpaceSmall,
            Text(
              "Patient Name : ${_viewModel.patientName}",
              style: mediumTextStyle,
            ),
            verticalSpaceSmall,
            Text(
              "Appointment: ${formatDate(_viewModel.selectedDate.toString())} at ${formatTime(_viewModel.timeSlotsList.where((element) => element.isSelected == true).first.value.toString())} : ${_viewModel.timeSlotsList.where((element) => element.isSelected == true).first.index! % 2 == 0 ? "00" : "30"} ${_viewModel.timeSlotsList.where((element) => element.isSelected == true).first.value! >= 12 ? "PM" : "AM"}",
              style: mediumTextStyle,
            ),
            verticalSpaceSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Choose Consultancy Type : "),
                GestureDetector(
                  onTap: () {
                    bottomAppointmentSelection();
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(standardBorderRadius),
                      border: Border.all(color: baseColor),
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${_viewModel.consultancyType}'),
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
            verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: Text(
                    'Symptoms :${_viewModel.symptomTextController.text.isEmpty ? '' : _viewModel.symptomTextController.text}',
                    overflow: TextOverflow.visible,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ButtonContainer(
                    height: 30,
                    width: 60,
                    buttonText: 'Add',
                    onPressed: () async {
                      var result = await Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SymptomViewWidget(
                                  widget._doctorDetailResponse),
                              fullscreenDialog: true));
                      _viewModel.assignSymptomandComment(result[0], result[1]);
                    },
                  ),
                ),
              ],
            ),
            verticalSpaceMedium,
            Text(
              bookAppointmentSlots,
              style: mediumTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            verticalSpaceSmall,
            _viewModel.doctorDetailResponse.schedule!.toDate!
                        .isAfter(DateTime.now()) ==
                    false
                ? Text("InActive Doctor")
                : _calendarView(
                    fromDate:
                        _viewModel.doctorDetailResponse.schedule!.fromDate!,
                    toDate: _viewModel.doctorDetailResponse.schedule!.toDate!),
            Divider(
              thickness: 1,
              color: darkColor,
            ),
            Text(
              setTime,
              style: mediumTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            verticalSpaceSmall,
            Flexible(child: _timeSlots()),
            verticalSpaceLarge,
            ButtonContainer(
                buttonText: confirm,
                // onPressed: _viewModel.assignDataToAppointmentRequest(widget._doctorDetailResponse),
                onPressed: () {
                  if (_viewModel.symptomTextController.text.isNotEmpty) {
                    _viewModel.appointmentRequest.userId =
                        SessionManager.getUser.id;
                    _viewModel.appointmentRequest.scheduleId =
                        widget._doctorDetailResponse.schedule!.id ?? 0;
                    if (_viewModel.isMemberSelected) {
                      _viewModel.appointmentRequest.familyMemberId =
                          _viewModel.selectedFamilyMember.id;
                      _viewModel.appointmentRequest.familyMemberGender =
                          _viewModel.selectedFamilyMember.id;
                      _viewModel.appointmentRequest.familyMemberAge =
                          _viewModel.selectedFamilyMember.id;
                    }
                    _viewModel.appointmentRequest.doctorId =
                        widget._doctorDetailResponse.profile?.hcpId;
                    _viewModel.appointmentRequest.appointmentType =
                        _viewModel.consultancyType;
                    _viewModel.appointmentRequest.specialization = widget
                        ._doctorDetailResponse.professional?.specialization;
                    _viewModel.appointmentRequest.date =
                        _viewModel.selectedDate.toString().split(' ')[0];
                    _viewModel.appointmentRequest.time = _viewModel
                            .timeSlotsList
                            .where((element) => element.isSelected == true)
                            .first
                            .value
                            .toString() +
                        '${_viewModel.timeSlotsList.where((element) => element.isSelected == true).first.index! % 2 == 0 ? ":00" : ":30"}' +
                        ":00";

                    _viewModel.appointmentRequest.status =
                        appointmentStatus.CREATED.toString().split('.').last;
                    _viewModel.appointmentRequest.fees =
                        _viewModel.getConsultancyFess();
                    _viewModel.appointmentRequest.symptoms = Symptoms(
                        symptom: _viewModel.symptomTextController.text,
                        comments: _viewModel.commentTextController.text);

                    Map<String, dynamic> args = new Map();
                    args['doctorDetails'] = widget._doctorDetailResponse;
                    args['appointmentRequest'] = _viewModel.appointmentRequest;
                    args['patientName'] = _viewModel.isMemberSelected
                        ? "${_viewModel.selectedFamilyMember.firstName} ${_viewModel.selectedFamilyMember.lastName}"
                        : "${SessionManager.getUser.firstName} ${SessionManager.getUser.lastName}";
                    locator<NavigationService>().navigateTo(
                        Routes.appointmentSummaryView,
                        arguments: args);
                  } else {
                    locator<SnackBarService>().showSnackBar(
                      title: 'Please Add Symptoms',
                    );
                  }
                }),
            verticalSpaceLarge,
          ],
        ),
      ),
    );
  }

  void bottomAppointmentSelection() {
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
                Text(
                  "Select Consultation Mode",
                  style: mediumTextStyle.copyWith(color: Colors.black),
                  textAlign: TextAlign.left,
                ),
                verticalSpaceMedium,
                ListView.builder(
                    itemCount: widget._doctorDetailResponse.professional
                        ?.appointmentType?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _viewModel.consultancyType = widget
                              ._doctorDetailResponse
                              .professional
                              ?.appointmentType?[index];
                          _viewModel.reload();
                        },
                        child: Container(
                          height: kToolbarHeight - 10,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2))),
                          child: Center(
                              child: Text(
                                  widget._doctorDetailResponse.professional
                                          ?.appointmentType?[index] ??
                                      "",
                                  style: largeTextStyle.copyWith(
                                      color: Colors.black))),
                        ),
                      );
                    }),
              ],
            ),
          );
        });
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
                Text(
                  "Select Family Members",
                  style: mediumTextStyle.copyWith(color: Colors.black),
                  textAlign: TextAlign.left,
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
                            _viewModel.selectedFamilyMember =
                                _viewModel.familyMemberList[index];
                            _viewModel.patientName =
                                "${_viewModel.familyMemberList[index].firstName} ${_viewModel.familyMemberList[index].lastName}";
                            _viewModel.isMemberSelected = true;
                            _viewModel.reload();
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
                                        color: Colors.black))),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  Widget _calendarView({required DateTime fromDate, required DateTime toDate}) {
    return CalendarDatePicker(
      initialDate:
          fromDate.isBefore(DateTime.now()) ? DateTime.now() : fromDate,
      lastDate: toDate,
      firstDate: fromDate.isBefore(DateTime.now()) ? DateTime.now() : fromDate,
      onDateChanged: (DateTime value) {
        _viewModel.selectDate(value);
      },
    );
  }

  Widget _timeSlots() {
    return GridView.builder(
      itemCount: _viewModel.timeSlotsList.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: (2 / 0.8),
      ),
      itemBuilder: (
        context,
        index,
      ) {
        return GestureDetector(
          onTap: () {
            if (_viewModel.timeSlotsList[index].isAvailable == true)
              _viewModel.selectTimeSlots(index);
          },
          child: Container(
            height: kToolbarHeight - 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _viewModel.timeSlotsList[index].isSelected == true
                    ? secondaryColor
                    : (_viewModel.timeSlotsList[index].isAvailable ?? true
                        ? baseColor
                        : disableColor)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${_viewModel.timeSlotsList[index].value! >= 12 ? (_viewModel.timeSlotsList[index].value! - 12).toString() : _viewModel.timeSlotsList[index].value.toString()}: ${_viewModel.timeSlotsList[index].index! % 2 == 0 ? '00' : '30'} ${_viewModel.timeSlotsList[index].value! >= 12 ? "PM" : "AM"}",
                    style: mediumTextStyle.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
