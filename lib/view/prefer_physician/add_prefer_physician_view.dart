import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/common_widgets/search_view.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/viewmodel/prefer_physician/prefer_physician_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AddPreferPhysicianView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddPreferPhysicianView();
}

class _AddPreferPhysicianView extends State<AddPreferPhysicianView> {
  late PreferedPhysicianViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PreferedPhysicianViewModel>.reactive(
      onModelReady: (model) => model.getDoctorsList(),
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: CommonAppBar(
              title: addPreferredPhysician,
              isClearButtonVisible: true,
              onBackPressed: () {

                Navigator.pop(context);
              },
              onClearPressed: () {
                locator<NavigationService>()
                    .navigateToAndRemoveUntil(Routes.dashboardView);
              },
            ),
            body: _currentWidget());
      },
      viewModelBuilder: () => PreferedPhysicianViewModel(),
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
          children: [
            SearchView(
              onChanged:  (value) {

                _viewModel.searchPhysicianFilter(value);
              },

            ),
            verticalSpaceMedium,
          _viewModel.state == ViewState.Empty? EmptyListWidget("Nothing Found") :Flexible(
              child: ListView.builder(
                  itemCount: _viewModel.doctorList.length,
                  itemBuilder: (context, index) {
                    return _itemContainer(index);
                  }),
            ),
          ],
        ));
  }



  Widget _itemContainer(index) {

    var image = "";
    if (_viewModel.doctorList[index].profile!= null)
    {
      image = _viewModel.doctorList[index].profile!.profilePicture??"";
    }
    return Container(
      child: Card(
        elevation: standardCardElevation,
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
                      child: CircleAvatar(
                        foregroundImage:
                        image ==  ""?  Image.asset("images/dashboard/profile_dummy.png").image : Image.network( image)
                            .image,
                      ),
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
                    "Dr. ${_viewModel.doctorList[index].firstname??""}   ${_viewModel.doctorList[index].lastname??""}",


                          style: mediumTextStyle,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          _viewModel.doctorList[index].professional?.specialization??"",
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
                              color: _viewModel.doctorList[index].professional?.appointmentType?.contains("Home")==true? baseColor : disableColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.video_call_sharp,
                              size: 26,
                              color: _viewModel.doctorList[index].professional?.appointmentType?.contains("Teleconsultation")==true? baseColor : disableColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.local_hospital,
                              size: 28,
                              color:  _viewModel.doctorList[index].professional?.appointmentType?.contains("In-clinic")==true? baseColor : disableColor,
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Text(
                  //   "Available on :${_viewModel.doctorList[index].schedule!.fromTIme} to ${_viewModel.doctorList[index].schedule!.toTime}",
                  //   style: bodyTextStyle.copyWith(color: darkColor),
                  // ),
                  GestureDetector(
                    onTap: () {

                     _viewModel.addPreferPhysician(_viewModel.doctorList[index].profile!.hcpId??0);
                    },
                    child: Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius:
                          BorderRadius.circular(standardBorderRadius)),
                      child: Center(
                        child: Text(
                          "Add",
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
