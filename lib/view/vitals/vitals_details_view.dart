import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:stacked/stacked.dart';
import '../../common_widgets/button_container.dart';
import '../../common_widgets/common_appbar.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../constants/ui_helpers.dart';
import '../../get_it/locator.dart';
import '../../route/routes.dart';
import '../../services/common_service/navigation_service.dart';
import '../../tools/date_formatting.dart';
import '../../viewmodel/vitals/vitals_viewmodel.dart';

class VitalDetailsView extends StatelessWidget {
  List<dynamic> vitalList;
  String name, unit, tileKey;
  int familyId;
  VitalDetailsView(
      this.vitalList, this.name, this.unit, this.tileKey, this.familyId);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VitalsViewModel>.nonReactive(
      builder: (BuildContext context, viewModel, Widget? child) {
        return Scaffold(
          appBar: CommonAppBar(
            title: 'Vitals Details',
            onBackPressed: () {
              if (Navigator.canPop(context))
                Navigator.pop(context);
            },
            onClearPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.dashboardView, (route) => false);
            },
          ),
          bottomSheet: ButtonContainer(
              buttonText: "Add $name",
              onPressed: () {
                viewModel.vitalOptionList.forEach((element) {
                  if (element.key == name) element.isChecked = true;
                });
                var map = new Map();
                map["VitalResponse"] = viewModel.getvitalResponse;
                map['isEdit'] = false;
                map['VitalOptionList'] = viewModel.vitalOptionList;
                map['familyMemberId'] = familyId != -1 ? familyId : null;
                locator<NavigationService>()
                    .navigateTo(Routes.fillVitalsDetailsView, arguments: map);
              }),
          body: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Padding(
              padding: const EdgeInsets.only(bottom: kToolbarHeight + 10),
              child: vitalList.length >= 1
                  ? ListView.builder(
                      itemCount: vitalList.length,
                      itemBuilder: (context, index) =>
                          commonCard(vitalList.length - (index + 1)))
                  : EmptyListWidget("Add your first $name"),
            ),
          ),
        );
      },
      viewModelBuilder: () => VitalsViewModel(),
    );
  }

  Widget commonCard(index) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 120,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        //  border: Border.all(color: Colors.blueGrey, width: 1.2,),
        borderRadius: const BorderRadius.all(Radius.circular(18)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const Icon(
                  Icons.more_horiz,
                  size: 25.0,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          Expanded(
            child: Visibility(
              child: Row(
                children: [
                  if (name == 'BP') ...[
                    Text(
                      "${vitalList[index]['systolic']}/${vitalList[index]['diastolic']}",
                      style: const TextStyle(fontSize: 37.0, height: 1),
                    ),
                  ],
                  if (name != 'BP') ...[
                    Text(
                      "${vitalList[index][tileKey]}",
                      style: const TextStyle(fontSize: 37.0, height: 1),
                    ),
                  ],
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    unit,
                    style: const TextStyle(fontSize: 15.0, height: 2),
                  )
                ],
              ),
            ),
          ),
          verticalSpaceSmall,
          Text(
              'Added on : ${vitalList[index]["UpdatedOn"] == null ? "NA" : formatDate(vitalList[index]["UpdatedOn"].split('T').first)}',
              textAlign: TextAlign.start,
              style: smallTextStyle.copyWith(color: disableColor)),
        ],
      ),
    );
  }
}