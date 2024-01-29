import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/viewmodel/video_call/video_call_viewmodel.dart';
import 'package:stacked/stacked.dart';

class VideoCallView extends StatefulWidget {

  int appointmentId = 0;
  VideoCallView(this.appointmentId);

 @override
 _VideoCallViewState createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  late VideoCallViewModel _viewModel;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // destroy sdk
    _viewModel.engine.leaveChannel();
    _viewModel.engine.release();
    _viewModel.onCallEnd(context);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VideoCallViewModel>.reactive(

        onModelReady: (model)=> model.initializeData(agoraChannelName : widget.appointmentId),
        builder: (context, viewModel, child) {
          _viewModel = viewModel;
          return Scaffold(
            body: Stack(
              children: [
                Center(
                  child: remoteVideo(),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 100,
                    height: 150,
                    child: Center(
                      child: _viewModel.localUserJoined
                          ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _viewModel.engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                          : const CircularProgressIndicator(),
                    ),
                  ),
                ),
                toolbar()
              ],
            ),
          );
        },
      viewModelBuilder: () => VideoCallViewModel(),
        );
  }



  Widget remoteVideo() {
    if(_viewModel.isDoctorCutCall){
      _viewModel.onCallEnd(context);
    }
    if (_viewModel.remoteUId != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _viewModel.engine,
          canvas: VideoCanvas(uid: _viewModel.remoteUId),
          connection:  RtcConnection(channelId: _viewModel.channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }


  Widget toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              _viewModel.updateMicStatus();
              _viewModel.engine.muteLocalAudioStream(_viewModel.isMicMute);
            },
            child: Icon(
              _viewModel.isMicMute ? Icons.mic_off : Icons.mic,
              color: _viewModel.isMicMute ? Colors.white : baseColor ,
              size: 30.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: _viewModel.isMicMute ?  baseColor:Colors.white ,
            padding: const EdgeInsets.all(12.0),
          ),

          RawMaterialButton(
            onPressed: () {
              _viewModel.switchCamera();
            },
            child: Icon(
              Icons.switch_camera,
              color: _viewModel.isCameraSwitch ? baseColor : Colors.white,
              size: 30.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor:_viewModel.isCameraSwitch ? Colors.white : baseColor,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

}
