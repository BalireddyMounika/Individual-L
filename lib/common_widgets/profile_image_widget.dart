
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/net/session_manager.dart';

class ProfileImageWidget extends StatelessWidget
{
  late double circleSize;
  ProfileImageWidget({required this.circleSize});
  @override
  Widget build(BuildContext context) {
     return  Container(
       height: circleSize,
       width: circleSize ,
       decoration: BoxDecoration(
         shape: BoxShape.circle,
         border:  Border.all(color: Colors.black)

       ),
       child:SessionManager.profileImageUrl!.isNotEmpty ? SizedBox(
           height: circleSize,
           width: circleSize,
           child: CircleAvatar(
             backgroundColor: Colors.white,
             foregroundColor: baseColor,

             foregroundImage:  Image.network(SessionManager.profileImageUrl??"").image,

           )) :SizedBox(


        height: circleSize,
        width: circleSize,
        child: CircleAvatar(backgroundImage: Image.asset("images/dashboard/profile_dummy.png").image))

     ) ;
  }

}