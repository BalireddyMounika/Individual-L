import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/enums/snackbar_types.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/video_call/tokenRequest.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/services/video_call/video_call_service.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';


class VideoCallViewModel extends CustomBaseViewModel {
  late RtcEngine engine;

  //new
  bool isDisplaySwitch = false;
  bool isMicMute = false;
  bool isCameraSwitch = false;
  int? remoteUId ;
  bool localUserJoined = false;
  //Agora Setting for video call Api
  String appId = "8cd2dce03a7643b0820f28f175877a73";
  String token =
      "007eJxTYDjnZVruOnvX0b6A/tWhyQJsIpI2Lc3nPrSVuYtJa8bullRgsEhOMUpJTjUwTjQ3MzFOMrAwMkgzskgzNDe1MDdPNDfmfrUtuSGQkeForSMTIwMEgvgsDCWpxSUMDACAJhyq";
  String channel = "test";
  //new end

  int localIndex = 0;
  int remoteIndex = 1;
  bool isDoctorCutCall = false ;
  late AgoraTokenRequest _agoraTokenRequest ;
  var _videoCallService = locator<VideoCallService>();
  var _navigatorService = locator<NavigationService>();
  var _dialogService = locator<DialogService>();

  int? localUid;

  TimeOfDay currentTime = TimeOfDay.now();

  DateFormat formatterTime = DateFormat('kk:mm');


  //new

  initializeData({required int agoraChannelName}) async{
   await getAgoraToke(channelName: agoraChannelName.toString());
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    engine = createAgoraRtcEngine();
    await engine.initialize( RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
            onLocalUserJoin();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          remoteUId = remoteUid;
          notifyListeners();

        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          remoteUId = null;
          isDoctorCutCall = true ;
          _navigatorService.navigateToAndRemoveUntil(Routes.dashboardView);
          locator<SnackBarService>().showSnackBar(
              title:
              "Thank for choosing Lifeeazy app you will be receiving your perception soon with in 40 minutes",
              snackbarType: SnackbarType.info,
              duration: 10);

        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          notifyListeners();
        },

      ),
    );

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future getAgoraToke({required String channelName}) async {

    try {
      var response = await _videoCallService.agoraToken(channelName);
      if (response.hasError == false) {
        channel = response.result["channelName"];
        token = response.result["token"];
      }else{
        _dialogService.showDialog(
            DialogType.ErrorDialog, message, response.message, "", done);
        setState(ViewState.Completed);
      }
    } catch (error) {
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }

  }

  onRemoteUserJoined(int remoteUId){
    remoteUId = remoteUId;
    notifyListeners();
  }

  void onLocalUserJoin(){
    localUserJoined = true;
    notifyListeners();
  }

 void onRemoteUserOffline(){

   remoteUId = null;
   isDoctorCutCall = true ;
    notifyListeners();
   // onCallEnd();

  }

  void updateMicStatus() {
    isMicMute = !isMicMute;
    engine.muteLocalAudioStream(isMicMute);
    notifyListeners();
  }

  void onCallEnd(BuildContext context) async {
    // _actualEndTime = formatterTime.format(now);
    locator<NavigationService>().navigateToAndRemoveUntil(Routes.dashboardView);
    locator<SnackBarService>().showSnackBar(
        title:
        "Thank for choosing Lifeeazy app you will be receiving your perception soon with in 40 minutes",
        snackbarType: SnackbarType.info,
        duration: 10);
  }


  void switchCamera(){
    isCameraSwitch = !isCameraSwitch ;
    engine.switchCamera();

    notifyListeners();
  }

  void isLocalUserJoined() {
    localUserJoined = true;
    notifyListeners();
  }

  void isRemoteUserJoin(int uid) {
    remoteUId = uid;
    notifyListeners();
  }

  void isRemoteUserOffline(int uid) {
    remoteUId = null;

    notifyListeners();
  }

  void updateDisplaySwitch() {
    isDisplaySwitch = !isDisplaySwitch;
    notifyListeners();
  }





}
