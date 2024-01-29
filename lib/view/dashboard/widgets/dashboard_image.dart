import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/network_image_widget.dart';
import 'package:life_eazy/net/session_manager.dart';

class DashboardImageWidget extends StatelessWidget {
  late double circleSize;
  DashboardImageWidget({required this.circleSize});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: circleSize,
        width: circleSize,
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: Colors.black)),
        child: SessionManager.profileImageUrl!.isNotEmpty
            ? SizedBox(
                height: circleSize,
                width: circleSize,
                child: ClipOval(
                  child: NetworkImageWidget(
                      imageName: SessionManager.profileImageUrl ?? "",
                      width: circleSize,
                      height: circleSize),
                ))
            : SizedBox(
                height: circleSize,
                width: circleSize,
                child: CircleAvatar(
                    backgroundImage:
                        Image.asset("images/dashboard/profile_dummy.png")
                            .image)));
  }
}
