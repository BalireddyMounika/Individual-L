import 'package:life_eazy/models/generic_response.dart';

abstract class NotificationService
{
  Future<GenericResponse> getNotificationInfo(int id);
}