import 'package:get_it/get_it.dart';
import 'package:life_eazy/net/api_service_config.dart';
import 'package:life_eazy/prefs/local_storage_services.dart';
import 'package:life_eazy/services/appointments/appointment_service_imp.dart';
import 'package:life_eazy/services/appointments/appointment_services.dart';
import 'package:life_eazy/services/authentication/auth_servcices.dart';
import 'package:life_eazy/services/authentication/auth_service_imp.dart';
import 'package:life_eazy/services/common_service/common_api/common_api_service.dart';
import 'package:life_eazy/services/common_service/common_api/common_api_service_imp.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/services/family_members/family_members_services.dart';
import 'package:life_eazy/services/family_members/family_members_services_imp.dart';
import 'package:life_eazy/services/immunization/immunization_services.dart';
import 'package:life_eazy/services/notification/notification_service.dart';
import 'package:life_eazy/services/notification/notification_service_imp.dart';
import 'package:life_eazy/services/payment_transactions/payment_transaction_service_imp.dart';
import 'package:life_eazy/services/payment_transactions/payment_transaction_services.dart';
import 'package:life_eazy/services/prefer_physician/prefer_physician_services.dart';
import 'package:life_eazy/services/prefer_physician/prefer_physician_services_imp.dart';
import 'package:life_eazy/services/prescription/prescription_service.dart';
import 'package:life_eazy/services/prescription/prescription_service_imp.dart';
import 'package:life_eazy/services/profile/profile_service.dart';
import 'package:life_eazy/services/profile/profile_service_imp.dart';
import 'package:life_eazy/services/subscription/subscription_services.dart';
import 'package:life_eazy/services/subscription/subscription_services_imp.dart';
import 'package:life_eazy/services/video_call/video_call_service.dart';
import 'package:life_eazy/services/video_call/video_call_service_imp.dart';
import 'package:life_eazy/services/vitals/vital_service_imp.dart';
import 'package:life_eazy/services/vitals/vitals_seirvice.dart';

import '../services/immunization/immunization_service_imp.dart';
import '../services/pharmacy/pharmacy_service.dart';
import '../services/pharmacy/pharmacy_service_imp.dart';

final locator = GetIt.instance;
var config = ApiServiceConfig();
Future<void> setupLocator()async
{
  locator.registerSingleton<FamilyMembersServices>(FamilyMembersServicesImp(config.dio));
  locator.registerSingleton<ProfileService>(ProfileServiceImp(config.dio));
  locator.registerSingleton<AuthService>(AuthServiceImp(config.dio));
  locator.registerSingleton<AppointmentService>(AppointmentServiceImp(config.dio));
  locator.registerSingleton<VideoCallService>(VideoCallServiceImp(config.dio));
  locator.registerSingleton<DialogService>(DialogService());
  locator.registerSingleton<NavigationService>(NavigationService());
  locator.registerSingleton<PaymentTransactionService>(PaymentTransactionServiceImp(config.dio));
  locator.registerSingleton<PreferPhysicianServices>(PreferPhysicianServiceImp(config.dio));
  locator.registerSingleton<PrescriptionService>(PrescriptionServiceImp(config.dio));
  locator.registerSingleton<CommonApiService>(CommonApiServiceImp(config.dio));
  locator.registerSingleton<ImmunizationService>(ImmunizationServiceImp(config.dio));
  locator.registerSingleton<SubscriptionServices>(SubscriptionServiceImp(config.dio));

  var instance = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(instance!);
  locator.registerSingleton<VitalService>(VitalServiceImp( config.dio));
  locator.registerSingleton<NotificationService>(NotificationServiceImp(config.dio));
  locator.registerSingleton<SnackBarService>(SnackBarService());
  locator.registerSingleton<PharmacyService>(PharmacyServiceImp(config.dio));



}
