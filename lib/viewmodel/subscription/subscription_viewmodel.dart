import 'package:life_eazy/models/subscription/subscription_model.dart';
import 'package:life_eazy/models/subscription/subscription_request.dart';
import 'package:life_eazy/models/subscription/user_subscription_response_model.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/services/subscription/subscription_services.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

import '../../common_widgets/popup_dialog.dart';
import '../../constants/strings.dart';
import '../../enums/viewstate.dart';
import '../../get_it/locator.dart';
import '../../route/routes.dart';
import '../../services/common_service/dialog_services.dart';

class SubscriptionViewModel extends CustomBaseViewModel {
  var _subscriptionService = locator<SubscriptionServices>();
  var _dialogService = locator<DialogService>();
  List<SubscriptionModel> _subscriptionList = [];
  List<SubscriptionModel> get subscriptionList => _subscriptionList;
   SubscriptionModelRequest request = SubscriptionModelRequest();
  UserSubscriptionResponseModel subscribedUserModel =  UserSubscriptionResponseModel();

  Future getAllMasterSubscription() async
  {
    try {
      setState(ViewState.Loading);
      var response = await _subscriptionService.getAllMasterSubscription();
      if (response.hasError ?? false) {
        _dialogService.showDialog(
            DialogType.ErrorDialog, message, response.message, "", done);
      }
      else
        {
          var data = response.result as List;
          data.forEach((element) {


            _subscriptionList.add( SubscriptionModel.fromMap(element));

          });

          setState(ViewState.Completed);

        }
    }
    catch (e) {
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
    }


   Future postSubscription(id)async
   {
       setState(ViewState.Loading);
       request.subscriptionId =id;
       request.userId = SessionManager.getUser.id;
       request.transactionId = "sdsd";
       request.expired = "no";

     try
         {
            var response =   await _subscriptionService.postSubscriptionApi(request);
            if (response.hasError ?? false) {
              setState(ViewState.Completed);

              _dialogService.showDialog(
                  DialogType.ErrorDialog, message, response.message, "", done);
            }
            else
            {
              _dialogService.showDialog(
                  DialogType.SuccessDialog, message, "Successfully Subscribed", Routes.dashboardView, done,isStackedCleared: true);


              setState(ViewState.Completed);

            }
         }
         catch(e)
     {
       _dialogService.showDialog(
           DialogType.ErrorDialog, message, somethingWentWrong, "", done);
       setState(ViewState.Completed);
     }
   }

Future getBySubscriptionUserId() async
{
  try {
    setState(ViewState.Loading);
    var response = await _subscriptionService.getBySubscriptionByUserId(SessionManager.getUser.id??0);
    if (response.hasError ?? false) {
      setState(ViewState.Completed);
    }
    else
    {

        var data =  response.result as List;
         subscribedUserModel =  UserSubscriptionResponseModel.fromMap(response.result.first);
        setState(ViewState.Completed);

    }
  }
  catch (e) {
    _dialogService.showDialog(
        DialogType.ErrorDialog, message, somethingWentWrong, "", done);
    setState(ViewState.Completed);
  }

}




  }
