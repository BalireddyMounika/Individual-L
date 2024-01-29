// import 'package:flutter/material.dart';
// import 'package:life_eazy/enums/viewstate.dart';
// import 'package:life_eazy/get_it/locator.dart';
// import 'package:life_eazy/route/routes.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:stacked/stacked.dart';
//
// import '../../common_widgets/button_container.dart';
// import '../../common_widgets/common_appbar.dart';
// import '../../common_widgets/loader.dart';
// import '../../constants/colors.dart';
// import '../../services/common_service/navigation_service.dart';
// import '../../viewmodel/video_call/video_call_viewmodel.dart';
//
// class ScheduleVideoCallView extends StatefulWidget {
//   const ScheduleVideoCallView({Key? key}) : super(key: key);
//
//   @override
//   _ScheduleVideoCallState createState() => _ScheduleVideoCallState();
// }
//
// class _ScheduleVideoCallState extends State<ScheduleVideoCallView> {
//   late VideoCallViewModel _viewModel;
//
//   var _navigationService = locator<NavigationService>();
//
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<VideoCallViewModel>.reactive(
//         viewModelBuilder: () => VideoCallViewModel(),
//         builder: (context, viewModel, child) {
//           _viewModel = viewModel;
//           return Scaffold(
//             appBar: CommonAppBar(
//               title: " Schedule Appointment",
//               isClearButtonVisible: true,
//               onBackPressed: () {
//                 Navigator.pop(context);
//               },
//           onClearPressed: () {
//           Navigator.pushNamedAndRemoveUntil(
//           context, Routes.dashboardView, (route) => false);
//           },
//             ),
//             bottomSheet: ButtonContainer(
//               buttonText: 'Make Call',
//               onPressed: () async{
//                 await [Permission.microphone, Permission.camera].request();
//                 if(await Permission.microphone.status.isGranted && await Permission.camera.status.isGranted){
//                   _navigationService.navigateTo(Routes.videoCallView);
//                 }
//                 else{
//                   print('Permission denied ');
//                 }
//
//               },
//             ),
//             body: _currentWidget(),
//           );
//         });
//   }
//
//   Widget _body() {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
//           child: TextField(
//             enabled: false,
//             controller: _viewModel.channelControler,
//             decoration: InputDecoration(
//               errorBorder: commonBorder(),
//               focusedErrorBorder: commonBorder(),
//               focusedBorder: commonBorder(),
//               enabledBorder: commonBorder(),
//               errorText:
//               _viewModel.validateError ? 'Channel name is mandatory' : null,
//               hintText: 'ChanelToken',
//             ),
//           ),
//         ),
//         Text(
//           'Duration : 00:00',
//         )
//       ],
//     );
//   }
//
//   Widget _currentWidget() {
//     switch (_viewModel.state) {
//       case ViewState.Loading:
//         return Loader(
//           loadingMessage: _viewModel.loadingMsg,
//           loadingMsgColor: Colors.black,
//         );
//
//       case ViewState.Completed:
//         return _body();
//
//       default:
//         return _body();
//     }
//   }
//
//   OutlineInputBorder commonBorder() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(10)),
//       borderSide: BorderSide(width: 2, color: baseColor),
//     );
//   }
//
// }
