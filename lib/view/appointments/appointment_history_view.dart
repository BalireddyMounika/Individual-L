import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/tools/date_formatting.dart';
import 'package:life_eazy/tools/time_formatting.dart';
import 'package:life_eazy/view/appointments/widget/active_appointment_widget.dart';
import 'package:life_eazy/view/appointments/widget/completed_appointmet_widget.dart';
import 'package:life_eazy/viewmodel/appointments/appointment_history_viewmodel.dart';
import 'package:life_eazy/viewmodel/appointments/appointment_history_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AppointmentHistoryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppointmentHostoryView();
}

class _AppointmentHostoryView extends State<AppointmentHistoryView> {
  late AppointmentHistoryViewModel _viewModel;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ViewModelBuilder<AppointmentHistoryViewModel>.reactive(
      onModelReady: (model) => model.getAppointmentHistoryList(),
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor:Color(0xffF8F8F6),
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 130),
              child: AppBar(
                backgroundColor: appBarColor,

                centerTitle: false,
                leading: InkWell(
                  onTap:(){
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_outlined,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
                title: Text('My Appointment',style: appBarTitleTextStyle,overflow: TextOverflow.ellipsis,),
                actions: [
                  DropdownButton(
                    value: _viewModel.dropDownInitialValue,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items:_viewModel.dropdownValueItems.map((String items) {
                      return DropdownMenuItem(
                          value: items,
                          child: Text(items ,style: bodyTextStyle,)
                      );
                    }
                    ).toList(),
                    onChanged: (newValue){
                      _viewModel.changedValue(newValue);
                    },
                  ),
                ],
                bottom:TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          'Active',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Completed',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
              )

            ),
            body: _currentWidget(),
          ),
        );
      },
      viewModelBuilder: () => AppointmentHistoryViewModel(),
    );
  }
  onBackPressed(){

  }
  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: "Fetching Appointments",
          loadingMsgColor: Colors.black,
        );
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

  Widget _listContainer(index) {
    return Container(
        child: Card(
      elevation: standardCardElevation,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _listContainerItem(doctorName,
                "${_viewModel.activeAppointmentHistoryList[index].doctorId?.firstname} ${_viewModel.activeAppointmentHistoryList[index].doctorId?.lastname}"),
            SizedBox(
              height: 10,
            ),
            _listContainerItem(specialization,
                _viewModel.activeAppointmentHistoryList[index].specialization ?? ""),
            SizedBox(
              height: 10,
            ),
            _listContainerItem(dateOfBooking,
              "${formatDate(_viewModel.activeAppointmentHistoryList[index].bookingDate ?? "NA")}"),
            SizedBox(
              height: 10,
            ),
            _listContainerItem(appointmentDate,
              "${formatDate(_viewModel.activeAppointmentHistoryList[index].date ?? "")}"),
            SizedBox(
              height: 10,
            ),
            _listContainerItem(appointmentTime,
             //_viewModel.activeAppointmentHistoryList[index].time ?? ""),
              "${formatTime(_viewModel.activeAppointmentHistoryList[index].time!.split(':').first)} : 00 ${int.parse(_viewModel.activeAppointmentHistoryList[index].time!.split(':').first??"0")>12?"PM":"AM"}",),
            SizedBox(
              height: 10,
            ),
            _listContainerItem(appointmentType,
                _viewModel.activeAppointmentHistoryList[index].appointmentType ?? ""),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  status,
                  style: bodyTextStyle.copyWith(color: darkColor),
                ),
                Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(standardBorderRadius),
                    color: Colors.white,
                  ),
                  child: Card(
                      elevation: standardCardElevation,
                      child: Center(
                        child: Text(
                            _viewModel.activeAppointmentHistoryList[index].status ??
                                "",
                            style: mediumTextStyle.copyWith(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold)),
                      )),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
              visible:
                  _viewModel.activeAppointmentHistoryList[index].status == "CONFIRMED"
                      ? true
                      : false,
              child: ButtonContainer(
                buttonText: "View Prescription",
                onPressed: () {
                  Map maps = Map();
                  maps['appointmentId'] =
                      _viewModel.activeAppointmentHistoryList[index].id;

                  locator<NavigationService>()
                      .navigateTo(Routes.prescriptionView, arguments: maps);
                },
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget _listContainerItem(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Text(
              title,
              style: bodyTextStyle.copyWith(color: darkColor),
            )),
        Expanded(
            flex: 1,
            child: Text(data,
                textAlign: TextAlign.end,
                style: mediumTextStyle.copyWith(color: Colors.black))),
      ],
    );
  }

  Widget _body() {
    return TabBarView(
      children: [
        ActiveAppointmentWidget(),
        CompleteAppointmentWidget()
      ],
    );
  }


}
