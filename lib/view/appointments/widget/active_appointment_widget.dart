import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/tools/date_formatting.dart';
import 'package:life_eazy/tools/time_formatting.dart';
import 'package:life_eazy/viewmodel/appointments/appointment_history_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/colors.dart';

class ActiveAppointmentWidget
    extends ViewModelWidget<AppointmentHistoryViewModel> {
  late AppointmentHistoryViewModel _viewModel;
  late BuildContext context;
  @override
  Widget build(context, AppointmentHistoryViewModel viewModel) {
    this.context = context;
    _viewModel = viewModel;
    return _viewModel.activeAppointmentHistoryList.isEmpty
        ? EmptyListWidget('Data Not Available')
        : ListView.builder(
            shrinkWrap: true,
            itemCount: _viewModel.activeAppointmentHistoryList.length,
            itemBuilder: (context, index) {
              return _listContainer(context,
                  _viewModel.activeAppointmentHistoryList.length - (index + 1));
            });
  }

  Widget _listContainer(context, index) {
    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      shadowColor: Colors.white,
      elevation: standardCardElevation,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(standardBorderRadius),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpaceSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 50,
                    width: 50,
                    child: Image.network(
                      "https://img.icons8.com/clouds/100/000000/medical-doctor.png",
                    )),
                horizontalSpaceMedium,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Dr ${_viewModel.activeAppointmentHistoryList[index].doctorId?.firstname} ${_viewModel.activeAppointmentHistoryList[index].doctorId?.lastname}",
                              style: mediumTextStyle.copyWith(
                                color: blackColor,
                                fontWeight: FontWeight.w500,
                              )),
                          Text(
                              "${formatDate(_viewModel.activeAppointmentHistoryList[index].bookingDate!.split('T').first ?? "NA")}",
                              style: smallTextStyle.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    Text(
                        _viewModel.activeAppointmentHistoryList[index]
                                .specialization ??
                            "",
                        style: bodyTextStyle.copyWith(
                          color: Colors.grey,
                        )),
                    verticalSpaceTiny,
                    Text(
                        "${_viewModel.activeAppointmentHistoryList[index].appointmentType ?? ""}",
                        style: bodyTextStyle.copyWith(
                          color: redColor,
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.date_range,
                          color: Colors.grey,
                          size: 16,
                        ),
                        horizontalSpace(5),
                        Text(
                            "${formatDate(_viewModel.activeAppointmentHistoryList[index].date ?? "")}",
                            style: smallTextStyle.copyWith(
                              color: Colors.grey,
                            )),
                        horizontalSpaceSmall,
                        Icon(
                          Icons.access_time,
                          color: Colors.grey,
                          size: 16,
                        ),
                        horizontalSpace(5),
                        Text(
                            "${formatTime(_viewModel.activeAppointmentHistoryList[index].time!.split(':').first)} : ${_viewModel.activeAppointmentHistoryList[index].time!.split(':')[1]} ${int.parse(_viewModel.activeAppointmentHistoryList[index].time!.split(':').first ?? "0") > 12 ? "PM" : "AM"}",
                            style: bodyTextStyle.copyWith(
                              color: Colors.grey,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Map maps = new Map();
                      maps['appointmentResponse'] =
                          _viewModel.activeAppointmentHistoryList[index];

                      locator<NavigationService>().navigateTo(
                          Routes.appointmentDetailView,
                          arguments: maps);
                    },
                    child: Container(
                        height: 20,
                        width: 100,
                        child: Text(
                          "View Details",
                          style: bodyTextStyle.copyWith(
                              color: baseColor, fontWeight: FontWeight.w500),
                        )),
                  ),
                  Container(
                    height: 25,
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                          _viewModel
                                  .activeAppointmentHistoryList[index].status ??
                              "",
                          style: bodyTextStyle.copyWith(
                              color: redColor, fontWeight: FontWeight.w500)),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: redColor, width: 1),
                    ),
                  )
                ]),
            verticalSpaceTiny
          ],
        ),
      ),
    );
  }
}
