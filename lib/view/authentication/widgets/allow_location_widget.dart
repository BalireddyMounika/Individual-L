import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/screen_constants.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/viewmodel/authentication/registration_viewmodel.dart';
import 'package:stacked/stacked.dart';


class AllowLocationWidget extends ViewModelWidget<RegistrationViewModel>
{
  @override
  Widget build(BuildContext context,RegistrationViewModel model) {
    var paddingTotal = (displayWidth(context) * 1.4) + buttonBottomPadding;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image.asset("images/allow_location.png",height: 400,),
        SizedBox(height: 10,),
        Text("Allow LifeEazy to access your location for better service",style: mediumTextStyle.copyWith(color: Colors.grey),textAlign: TextAlign.center,),

        Spacer(),
        Padding(
          padding:  EdgeInsets.only(bottom:paddingTotal +20),
          child: ButtonContainerWithBorder(
            buttonText: notNow,
            onPressed: () {

              model.incrementCurrentScreenValue();

            },
          ),
        )
      ],
    );
  }

}