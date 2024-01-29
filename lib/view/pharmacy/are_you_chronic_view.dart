import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';

import '../../constants/strings.dart';
import '../../get_it/locator.dart';
import '../../route/routes.dart';
import '../../services/common_service/dialog_services.dart';
import '../../services/common_service/navigation_service.dart';

class AreYouChronicView extends StatelessWidget {
  var _dialogService = locator<DialogService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: baseColor,
        appBar: CommonAppBar(
          title: "Pharmacy",
          onBackPressed: () => Navigator.pop(context),
          isClearButtonVisible: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              areYouChronicPatient,
              style: headerTextStyle.copyWith(color: Colors.white),
            ),
            verticalSpaceAverage,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    locator<NavigationService>()
                        .navigateTo(Routes.pharmacyListView);
                  },
                  child: Container(
                    height: 60,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        "Yes",
                        style: mediumTextStyle.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                horizontalSpaceLarge,
                GestureDetector(
                  onTap: () {
                    _dialogService.showDialog(
                        DialogType.WarningDialog,
                        'Sorry',
                        'Our app exclusively caters to delivering medicine for chronic illnesses only.\n We\'ll expand to serve all in the future.',
                        Routes.dashboardView,
                        'Ok',
                        isStackedCleared: true);
                  },
                  child: Container(
                    height: 60,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        "No",
                        style: mediumTextStyle.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
