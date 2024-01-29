import 'package:life_eazy/models/generic_response.dart';

abstract class VideoCallService
{
  Future<GenericResponse> agoraToken(String channelName);


}