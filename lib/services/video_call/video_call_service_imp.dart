import 'package:dio/dio.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/services/video_call/video_call_service.dart';

class VideoCallServiceImp extends VideoCallService {
  late Dio dio;
  VideoCallServiceImp(this.dio);

  @override
  Future<GenericResponse> agoraToken(String channelName) async {
    var response = new GenericResponse();
    var url = "AgoraTokenGeneration/create_channel/";

    try {
      var httpResponse = await dio.post(url, data: { "channelName": "$channelName"});

      if (httpResponse.statusCode == 200)
        return GenericResponse.fromMap(httpResponse.data);

      response.message = httpResponse.statusMessage!;
      response.hasError = true;

    } catch (error) {
      if (error is DioError) {
        return GenericResponse.fromMap(error.response?.data);
      } else
        response.message = somethingWentWrong;

      response.hasError = true;
    }

    return response;
  }

}
