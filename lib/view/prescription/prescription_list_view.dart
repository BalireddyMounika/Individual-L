import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/common_widgets/search_view.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/viewmodel/prescription/prescription_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PrescriptionListView extends StatefulWidget {
  int appointmentId;
  PrescriptionListView(this.appointmentId);
  @override
  State<StatefulWidget> createState() => _PrescriptionListView();
}

class _PrescriptionListView extends State<PrescriptionListView> {
  late BuildContext _context;
  late PrescriptionViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PrescriptionViewModel>.reactive(
      onModelReady: (model) => model.getPrescriptionInfoByAppointmentId(),
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        _context = context;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: CommonAppBar(
            title: "Prescriptions",
              onBackPressed: () {
                Navigator.pop(context);
              },
              onClearPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, Routes.dashboardView, (route) => false);
              },
          ),
          body: _currentWidget(),
        );
      },
      viewModelBuilder: () => PrescriptionViewModel(widget.appointmentId),
    );
  }

  Widget _body() {
    return Container(
        margin: dashBoardMargin,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SearchView(),
            verticalSpaceMedium,
            Flexible(
              child: ListView.builder(
                  itemCount: _viewModel.prescriptionList.length,
                  itemBuilder: (context, index) {
                    return _itemContainer(index);
                  }),
            ),
          ],
        ),
    );
  }

  Widget _itemContainer(index) {

    return Card(
      elevation: 2,
      child: Container(
          margin: dashBoardMargin,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // _dateContainer("${_viewModel.prescriptionList[index].userId!.firstname??""}  ${_viewModel.prescriptionList[index].userId!.lastname??""} "),
               Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _details("Appointment Id",widget.appointmentId.toString()),
                //   _details("Email","${_viewModel.prescriptionList[index]??""}"),
                //   _details("Mobile","${_viewModel.prescriptionList[index].userId!.mobileNumber??""}"),
                //   _details("Next FollowUp Date","${_viewModel.prescriptionList[index].nextFollowUpDate}"),
                 ],
              ),
              Align(
                alignment:Alignment.bottomRight,
                child:GestureDetector(
                    onTap: () {
                      var map = new Map();
                      map["prescriptionResponse"] = _viewModel.prescriptionList[index];
                      locator<NavigationService>()
                          .navigateTo(Routes.prescriptionDetailsView,arguments: map);
                    },
                    child: _create("Details")),
                // GestureDetector(
                //     onTap: () {
                //  var maps = Map();
                //  maps["appointmentResponse"] =
                // Navigator.push(
                //   _context,
                //   MaterialPageRoute(builder: (context) =>  AddEditPrescriptionView()),
                // );
                // },
                // child: _create("Create Prescription")),

              )
            ],
          )),
    );
  }

  Widget _dateContainer(String title) {
    return Center(
      child: Center(
        child: Container(
          height: 40,
          width: 700,
          child: Row(
            children: [
              Center(
                child: Text(
                  title,
                  style: TextStyle(color: baseColor, fontSize: 16),
                ),
              ),
            ],
          ),
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
              border: Border.all(color: baseColor)
          ),
        ),
      ),
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
                      TextSpan(text: "$title : ", style: TextStyle(color: Colors.black,fontSize: 15)),
                      TextSpan(text: data, style: TextStyle( color:Colors.grey,)),
                    ],
                  ),
                  // Text(
                  //   title,
                  //   style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
      margin: EdgeInsets.all(4),
      // padding: EdgeInsets.all(2),
    );
  }

  Widget _create(String title) {
    return Container(

      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      width: 100,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: baseColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: baseColor),
      ),
    );
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(loadingMessage: _viewModel.loadingMsg,);

      case ViewState.Completed:
        return _body();

      case ViewState.Error:
        return const Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(fontSize: 18),
            ));
      case ViewState.Empty:
        return  EmptyListWidget("Nothing Found");

      default:
        return _body();
    }
  }
}
