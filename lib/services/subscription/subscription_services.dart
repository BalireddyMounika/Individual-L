import 'package:life_eazy/models/subscription/subscription_model.dart';
import 'package:life_eazy/models/subscription/subscription_request.dart';

import '../../models/generic_response.dart';

abstract class SubscriptionServices
{
  Future<GenericResponse> getAllMasterSubscription();
  Future<GenericResponse> postSubscriptionApi(SubscriptionModelRequest request);
  Future<GenericResponse> getBySubscriptionByUserId(int id);
}