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
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/models/appointments/appointment_request.dart';
import 'package:life_eazy/models/appointments/doctor_details_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/viewmodel/appointments/appointment_summary_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../tools/date_formatting.dart';
import '../../tools/time_formatting.dart';

class AppointmentSummaryView extends StatefulWidget {
  AppointmentRequest _appointmentRequest;
  DoctorDetailResponse _doctorDetailResponse;
  String _patientName;
  AppointmentSummaryView(
      this._appointmentRequest, this._doctorDetailResponse, this._patientName);
  @override
  State<StatefulWidget> createState() => _AppointmentSummaryView();
}

class _AppointmentSummaryView extends State<AppointmentSummaryView> {
  late AppointmentSummaryViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppointmentSummaryViewModel>.reactive(
      onModelReady: (model) => model.initializePaymentGateway(),
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: CommonAppBar(
              title: appointmentSummary,
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
          AppointmentSummaryViewModel(widget._appointmentRequest),
    );
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: _viewModel.loadingMessage,
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
      image = widget._doctorDetailResponse!.profile!.profilePicture ?? "";
    }

    return Container(
      margin: authMargin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpaceMedium,
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
                              ? baseColor
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
                              ? baseColor
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
          verticalSpaceSmall,
          Divider(
            thickness: 1,
            color: darkColor,
          ),
          verticalSpaceSmall,
          Text(
            "Appointment On : ${formatDate(widget._appointmentRequest.date ?? "")} at ${formatTime(widget._appointmentRequest.time!.split(':')[0])} : ${widget._appointmentRequest.time!.split(':')[1]} ${int.parse(widget._appointmentRequest.time!.split(':').first ?? "0") > 12 ? "PM" : "AM"}",
            style: mediumTextStyle,
          ),
          verticalSpaceSmall,
          Text(
            "Patient Name : ${"${widget._patientName}"}",
            style: mediumTextStyle,
          ),
          verticalSpaceSmall,
          Text(
            "Mobile Number : ${SessionManager.getUser.mobileNumber}",
            style: mediumTextStyle,
          ),
          verticalSpaceSmall,
          Text(
            "Appointment Type : ${widget._appointmentRequest.appointmentType}",
            style: mediumTextStyle,
          ),
          verticalSpaceSmall,
          Text(
            "Symptoms : ${widget._appointmentRequest.symptoms!.symptom}",
            style: mediumTextStyle,
          ),
          verticalSpaceSmall,
          Divider(
            thickness: 1,
            color: darkColor,
          ),
          verticalSpaceSmall,
          Text(
            "Amount Payable ",
            style: mediumTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          verticalSpaceMedium,
          Text("Consultation Fee : Rs ${widget._appointmentRequest.fees} ",
              style: mediumTextStyle),
          verticalSpaceSmall,
          Text("Total : Rs ${widget._appointmentRequest.fees} ",
              style: mediumTextStyle),
          Spacer(),
          ButtonContainer(
            buttonText: "PAY",
            onPressed: () {
              _viewModel
                  .createAppointment(widget._appointmentRequest.fees ?? 0);
            },
          ),
          verticalSpaceMedium
        ],
      ),
    );
  }
}
