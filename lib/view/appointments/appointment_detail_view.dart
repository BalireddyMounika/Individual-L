import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/enums/appointment_status.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/appointments/appointment_history_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/tools/date_formatting.dart';
import 'package:life_eazy/tools/time_formatting.dart';
import 'package:life_eazy/viewmodel/appointments/appoint_detail_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AppointmentDetailView extends StatefulWidget {
  AppointmentHistoryResponse appointmentResponse;

  AppointmentDetailView(this.appointmentResponse);
  @override
  State<StatefulWidget> createState() => _AppointmentDetailView();
}

class _AppointmentDetailView extends State<AppointmentDetailView> {
  late AppointmentDetailViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppointmentDetailViewModel>.reactive(
        viewModelBuilder: () => AppointmentDetailViewModel(),
        onModelReady: (e) {
          if (widget.appointmentResponse.appointmentType ==
              'Teleconsultation') {
            if (widget.appointmentResponse.status != 'CREATED') {
              e.getScheduleCallStatusList(widget.appointmentResponse.id ?? 0);
            }
          }
        },
        builder: (context, viewModel, child) {
          _viewModel = viewModel;
          return Scaffold(
            appBar: CommonAppBar(
              title: "Appointment Details",
              isClearButtonVisible: true,
              onBackPressed: () {
                Navigator.pop(context);
              },
              onClearPressed: () {
                locator<NavigationService>()
                    .navigateToAndRemoveUntil(Routes.dashboardView);
              },
            ),
            body: _currentWidget(),
            bottomSheet: Container(
              height: kToolbarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (widget.appointmentResponse.status ==
                            appointmentStatus.CONFIRMED
                                .toString()
                                .split('.')
                                .last) {
                          Map maps = Map();
                          maps['appointmentId'] = widget.appointmentResponse.id;

                          locator<NavigationService>().navigateTo(
                              Routes.prescriptionDetailsView,
                              arguments: maps);
                        }
                      },
                      child: Container(
                        color: widget.appointmentResponse.status ==
                                appointmentStatus.CONFIRMED
                                    .toString()
                                    .split('.')
                                    .last
                            ? baseColor
                            : Colors.grey,
                        child: Center(
                          child: Text(
                            "View Prescription",
                            style: bodyTextStyle.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       var maps = Map();
                  //       maps['appointmentResponse'] =
                  //           widget.appointmentResponse;
                  //
                  //       locator<NavigationService>()
                  //           .navigateTo(Routes.addNoteView, arguments: maps);
                  //     },
                  //     child: Container(
                  //       color: Colors.white60,
                  //       child: Center(
                  //         child: Text(
                  //           "Add Notes",
                  //           style: bodyTextStyle.copyWith(color: baseColor),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        });
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: _viewModel.loadingMsg,
          loadingMsgColor: Colors.black,
        );

      case ViewState.Completed:
        return _body();

      case ViewState.Empty:
        return Center(child: Text("Empty"));
      case ViewState.Error:
        return Center(child: Text("Error"));
      default:
        return _body();
    }
  }

  String getDuration() {
    if (int.parse(_viewModel.scheduleCallStatusList.first.duration ?? "0") >
        60) {
      var min =
          (int.parse(_viewModel.scheduleCallStatusList.first.duration ?? "0") ~/
                  60)
              .toInt();
      var sec =
          (int.parse(_viewModel.scheduleCallStatusList.first.duration ?? "0") %
                  60)
              .toInt();
      return "${min.toString()} min ${sec.toString()} sec";
    }

    return "${_viewModel.scheduleCallStatusList.first.duration} sec";
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Status : ${widget.appointmentResponse.status == 'CONFIRMED' ? 'COMPLETED' : widget.appointmentResponse.status}",
                      style: mediumTextStyle.copyWith(color: Colors.white),
                    ),
                  ),
                  height: 40.0,
                  width: 200,
                ),
              ),

              Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(4),
                child: Text(
                  "Patient Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              _details(
                  "First Name",
                  widget.appointmentResponse!.familyMemberId == null
                      ? SessionManager.getUser.firstName ?? ""
                      : widget.appointmentResponse!.familyMemberId!.firstname ??
                          ""),
              _details(
                  "Last Name",
                  widget.appointmentResponse!.familyMemberId == null
                      ? SessionManager.getUser.lastName ?? ""
                      : widget.appointmentResponse!.familyMemberId!.lastname ??
                          ""),
              _details(
                  "Email Address",
                  widget.appointmentResponse!.familyMemberId == null
                      ? SessionManager.getUser.email ?? ""
                      : widget.appointmentResponse!.familyMemberId!.email ??
                          ""),
              _details(
                  "Phone Number", SessionManager.getUser.mobileNumber ?? ""),
              _details("Symptoms",
                  widget.appointmentResponse.symptoms!.symptom ?? ""),
              verticalSpaceMedium,
              Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(4),
                child: Text(
                  "Doctor Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              _details("First Name",
                  widget.appointmentResponse.doctorId!.firstname ?? ""),
              _details("Last Name",
                  widget.appointmentResponse.doctorId!.lastname ?? ""),
              _details("Email Address",
                  widget.appointmentResponse.doctorId!.email ?? ""),
              _details("Phone Number",
                  widget.appointmentResponse.doctorId!.mobileNumber ?? ""),
              // _details("Symptoms",
              //     widget.appointmentResponse.symptoms!.symptom ?? ""),
              verticalSpaceMedium,
              Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(4),
                child: Text(
                  "Appointment Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              _details("Date",
                  "${formatDate(widget.appointmentResponse.date ?? "")}"),
              _details(
                "Time",
                "${formatTime(widget.appointmentResponse.time!.split(':').first)} : ${widget.appointmentResponse.time!.split(':')[1]} ${int.parse(widget.appointmentResponse.time!.split(':').first ?? "0") > 12 ? "PM" : "AM"}",
              ),
              _details("Appointment Type",
                  widget.appointmentResponse.appointmentType ?? ""),
              // _details("Appointment Charges",
              //     widget.appointmentResponse.fees.toString() ?? ""),
              verticalSpaceMedium,

              Visibility(
                visible: widget.appointmentResponse.appointmentType ==
                            'Teleconsultation' &&
                        _viewModel.scheduleCallStatusList.length >= 1
                    ? true
                    : false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(2),
                      padding: EdgeInsets.all(4),
                      child: Text(
                        "TeleConsultation",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),

                    _details('Date',
                        "${_viewModel.scheduleCallStatusList.length >= 1 ? formatDate(_viewModel.scheduleCallStatusList.first.createdDate.toString().split(' ').first) : ''}"),
                    _details(
                        'Duration',
                        _viewModel.scheduleCallStatusList.length >= 1
                            ? getDuration()
                            : ''),
                    // _details('Duration',"${_viewModel.scheduleCallStatusList.length>=1?formatTime(_viewModel.scheduleCallStatusList.first.duration!.split(':').first):""} : 00 ${int.parse(widget.appointmentResponse.time!.split(':').first??"0")>12?"PM":"AM"}",),
                    _details(
                        'Status',
                        _viewModel.scheduleCallStatusList.length >= 1
                            ? _viewModel.scheduleCallStatusList.first.status
                                .toString()
                            : ''),
                  ],
                ),
              ),

              SizedBox(
                height: 50,
              ),

              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   margin:  EdgeInsets.all(4),
    //   padding: EdgeInsets.all(4),
    //   child: Text("Doctor Details"),
    // );
  }

  RichText statusDetails(String name, String value) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: name, style: bodyTextStyle.copyWith(color: Colors.grey)),
          TextSpan(
              text: value,
              style: mediumTextStyle.copyWith(color: Colors.black)),
        ],
      ),
      // Text(
      //   title,
      //   style: TextStyle(fontWeight: FontWeight.normal),
      // ),
    );
  }

  Widget _details(String title, String data) {
    return Container(
      child: Center(
        child: Row(
          children: [
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "$title : ",
                          style: bodyTextStyle.copyWith(color: Colors.grey)),
                      TextSpan(
                          text: data,
                          style: mediumTextStyle.copyWith(color: Colors.black)),
                    ],
                  ),
                  // Text(
                  //   title,
                  //   style: TextStyle(fontWeight: FontWeight.normal),
                  // ),
                )
              ],
            ),
          ],
        ),
      ),
      margin: EdgeInsets.all(8),
    );
  }
}
