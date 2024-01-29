import 'package:flutter/cupertino.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/appointments/vide_call_request_response.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:permission_handler/permission_handler.dart';

class JoinTeleCallDialog extends StatelessWidget {

  VideoCallRequestResponse response =  new  VideoCallRequestResponse();
  JoinTeleCallDialog(this.response);
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpaceSmall,
          Text(
            "Tele Connection Request",
            style: mediumTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),

         verticalSpaceSmall,

          Text("${response.appointmentId!.doctorId!.firstname??""}  ${response.appointmentId!.doctorId!.lastname??""}",style: bodyTextStyle,),
          Text(response.appointmentId!.doctorId!.mobileNumber??"",style: bodyTextStyle,),
          Text(response.appointmentId!.doctorId!.email??"",style: bodyTextStyle,),
          verticalSpaceSmall,
          Text(response.appointmentId!.date??"" ,style: smallTextStyle.copyWith(fontWeight: FontWeight.bold),),
          // Text("12:00:00",style: smallTextStyle.copyWith(fontWeight: FontWeight.bold)),
          verticalSpaceMedium,
          Text("${response.appointmentId!.doctorId!.firstname} is waiting to join the call",style: largeTextStyle,textAlign: TextAlign.center,),
         Spacer(),
          ButtonContainer(
            buttonText: "Join Call",
            onPressed: () async{
                var map =  new Map();
                map['channelName'] = response.appointmentId?.id??0;
              locator<NavigationService>().navigateTo(Routes.videoCallView,arguments: map);

            },
          ),
          verticalSpaceSmall,
        ],
      ),
    );
  }
  Future<void> handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    if(status.isPermanentlyDenied){

    }
    print(status);
  }
}
