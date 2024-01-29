import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';

enum DialogType { ErrorDialog, WarningDialog, SuccessDialog }
//ignore: must_be_immutable
class PopUpDialog extends StatelessWidget {
  DialogType dialogType = DialogType.ErrorDialog;

  String? routes = "";
  final String? buttonText;
  final String? title;
  final String? message;
  final _navigationService = locator<NavigationService>();
  bool isStackCleared =false;
  bool isNoButtonVisible =  false;

  PopUpDialog(
      {
      this.routes,
      this.buttonText,
      this.title,
      this.message,
        this.isStackCleared =false,
        this.isNoButtonVisible =false,
      required this.dialogType});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        // height: displayHeight(context) * 4,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            topIcon(),
            SizedBox(
              height: 30,
            ),
            Flexible(
              child: Text(
                title ?? "",
                textAlign: TextAlign.center,
                style: largeTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              message ?? "",
              style: bodyTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Visibility(
                visible: isNoButtonVisible,
                child: _container(context)),

            ButtonContainer(
              buttonText: this.buttonText,
              height: 35,
              width: 80,
              //height: kToolbarHeight - 10,
              onPressed: (){
                if(routes!.isEmpty)
                Navigator.pop(context);
                else if (this.isStackCleared ==true) {
                  Navigator.pop(context);
                  _navigationService.navigateToAndRemoveUntil(routes!);
                }
                  else {
                  Navigator.pop(context);
                  _navigationService.navigateTo(routes!);
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ]
    )
      )
    );
  }

  Widget headerContainer(Color colors, Widget icon) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(color: colors),
        shape: BoxShape.circle,
      ),
      child: Center(child: icon),
    );
  }
  Widget _container(context) {
    return Center(
      child: Container(
        height: 35,
        width: 80,
        color: Colors.grey,
        margin: EdgeInsets.only(right: 30,left: 30),
        child: TextButton(
          child: Text('No', style: TextStyle(color: Colors.white,fontSize: 14),),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

    );
  }
  Widget topIcon() {
    switch (dialogType) {
      case DialogType.ErrorDialog:
        return headerContainer(
            Colors.red,
            Icon(
              Icons.clear,
              size: 48,
              color: Colors.red,
            ));

      case DialogType.WarningDialog:
        // TODO: Handle this case.
        return headerContainer(
            Colors.orange,
            Icon(
              Icons.warning,
              size: 48,
              color: Colors.orange,
            ));

      case DialogType.SuccessDialog:
        // TODO: Handle this case.
        return headerContainer(
            Colors.green,
            Icon(
              Icons.done,
              size: 48,
              color: Colors.green,
            ));
    }
  }
}
