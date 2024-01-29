import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common_widgets/button_container.dart';
import '../../common_widgets/common_appbar.dart';
import '../../common_widgets/empty_list_widget.dart';
import '../../common_widgets/loader.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../constants/styles.dart';
import '../../enums/viewstate.dart';
import '../../get_it/locator.dart';
import '../../route/routes.dart';
import '../../services/common_service/navigation_service.dart';
import '../../viewmodel/Immunization/immunization_viewmodel.dart';
enum radioEnum {BCG,AB,CD,DE,EC,EDFS,DSXD}
class SelectImmunizationView extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => _SelectImmunizationView();

}

class _SelectImmunizationView extends State<SelectImmunizationView> {
  late ImmunizationViewModel _viewModel;
  List<String> list = [];
  String selctedItem  =  "";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImmunizationViewModel>.reactive(
      onModelReady: (model) {
        model.getImmunization();
      },
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return Scaffold(
            bottomSheet: ButtonContainer(

              buttonText: "Continue",
              onPressed: () {
                Map map = new Map();
                map["selectedItem"] = _viewModel.immunizationList.where((element) => element.vaccine == _viewModel.selectedVaccine).first;
                locator<NavigationService>().navigateTo(
                    Routes.addImmunizationView,arguments:map );
              },
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: CommonAppBar(
              title: immuneVaccine,
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
      viewModelBuilder: () => ImmunizationViewModel(),
    );
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: "Fetching data ..",
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

  Widget _body()
  {

 return ListView.builder(
     itemCount: _viewModel.immunizationList.length,
     itemBuilder: (context, index) {
       return Padding(
         padding:
         EdgeInsets.symmetric(horizontal: 15, vertical: 5),
         child: Card(
           child: ListTile(
             leading:   Text(_viewModel.immunizationList[index].vaccine??"",style: mediumTextStyle,),
             trailing: Radio(
               groupValue:_viewModel.selectedVaccine,
               value:_viewModel.immunizationList[index].vaccine??"",
               onChanged: (value) {
                 print(value);
                  setState(() {
                    _viewModel.selectedVaccine = value.toString();
                  });

               },

             ),

           ),
         ),
       );
     });
  }

}

