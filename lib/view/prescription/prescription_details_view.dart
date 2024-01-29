import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/prescription/get_prescription_response.dart';
import 'package:life_eazy/viewmodel/prescription/prescription_viewmodel.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:stacked/stacked.dart';
import '../../common_widgets/empty_list_widget.dart';
import '../../common_widgets/loader.dart';
import '../../enums/viewstate.dart';
import '../../viewmodel/prescription/prescription_detail_viewmodel.dart';
import 'package:printing/printing.dart';

class PrescriptionDetailsView extends StatefulWidget {
  BuildContext? _context;

  int appointmentId = 0;

  PrescriptionDetailsView(this.appointmentId);

  @override
  State<StatefulWidget> createState() => _PrescriptionDetailsView();
}

class _PrescriptionDetailsView extends State<PrescriptionDetailsView> {
  late PrescriptionViewModel _viewModel;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PrescriptionViewModel>.reactive(
      viewModelBuilder: () => PrescriptionViewModel(widget.appointmentId),
      onModelReady: (viewModel) {
         viewModel.getPrescriptionInfoByAppointmentId();
      },
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return Scaffold(
          bottomSheet: _viewModel.state == ViewState.Loading? SizedBox(): _bottomContainer(_viewModel),
          appBar: CommonAppBar(
            title: " Prescription Details",
            onBackPressed: () {
              locator<NavigationService>().navigateTo(Routes.dashboardView);
            },
            isClearButtonVisible: true,
            onClearPressed: () {
              locator<NavigationService>()
                  .navigateToAndRemoveUntil(Routes.dashboardView);
            },
          ),
          body: _currentWidget(),
        );
      },
    );
    //
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(loadingMessage: 'Generating Prescription...');

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
         return Loader(loadingMessage: 'Loading...');
    }
  }

  Widget _body() {
    return Center(

      child: PdfView(
        controller: _viewModel.pdfController!,

        documentLoader: Center(child: CircularProgressIndicator(),),),
    );

  }


  Widget _bottomContainer(PrescriptionViewModel _viewModel) {
    return Container(
      height: kToolbarHeight - 5,
      decoration: BoxDecoration(
        color: Color(0xffebebeb),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                height: kToolbarHeight,
                color: Color(0xff71B5DA),
                child: TextButton.icon(
                    label: Text('Print',style: TextStyle(color: Colors.white),),
                    onPressed: () async {

                      await Printing.layoutPdf(
                        onLayout: (format) async =>
                            _viewModel.pdfFile!.readAsBytes(),
                        name: 'test Prescription',
                      );

                    },
                    icon: Icon(
                      Icons.print,
                      size: 24,
                      color: Colors.white,
                    )),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: kToolbarHeight,
              color: Color(0xff71B5DA),
              child: TextButton.icon(
                  label:
                  Text('Share Prescription',style: TextStyle(color: Colors.white),),

                  onPressed: () => _viewModel.share(),
                  icon: Icon(
                    Icons.share_rounded,
                    size: 24,
                    color: Colors.white,
                  ),),
            ),
          )
        ],
      ),
    );
  }
}

Widget _details(String title, String data) {
  return Container(
    child: Center(
      child: Row(
        children: [
          Column(children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "$title : ",
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  TextSpan(
                      text: data,
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ],
              ),
              // Text(
              //   title,
              //   style: TextStyle(
              //       color: Colors.grey,
              //       fontSize: 15,
              //       fontWeight: FontWeight.bold),
            ),
          ]),
        ],
      ),
    ),
    margin: EdgeInsets.all(4),
  );
}

Widget _data(String title, String data) {
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
                        text: "$title  ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        )),
                    TextSpan(text: data, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              // Text(
              //   title,
              //   style: TextStyle(
              //     color: Colors.grey,
              //     fontSize: 15,fontWeight: FontWeight.bold,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    ),
    margin: EdgeInsets.all(4),
    padding: EdgeInsets.all(1),
  );
}


