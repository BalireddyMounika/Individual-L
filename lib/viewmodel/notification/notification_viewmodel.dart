import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/notification/get_notification_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/services/notification/notification_service.dart';
import '../base_viewmodel.dart';

class NotificationViewModel extends CustomBaseViewModel {
  var _notificationService = locator<NotificationService>();
  var _snackBarService = locator<SnackBarService>();
  List<GetNotificationResponse> _notificationList = [];
  List<GetNotificationResponse> get notificationList => _notificationList;
  String loadingMsg = "";
  GetNotificationResponse getNotificationResponse = GetNotificationResponse();

  Future getNotificationInfo() async {
    try {
      loadingMsg = "Fetching Notifications";
       setState(ViewState.Loading);

      var response = await _notificationService
          .getNotificationInfo(SessionManager.getUser.id ?? 0);

      if (response.hasError == true ?? false) {
        setState(ViewState.Error);
      } else {
        var data = response.result as List;

        data.forEach((element) {
          _notificationList.add(GetNotificationResponse.fromMap(element));
        });

        if (notificationList.length >= 1)
          setState(ViewState.Completed);
        else
          setState(ViewState.Empty);
      }
    }
    catch (e) {
      setState(ViewState.Error);
    }
  }

}

