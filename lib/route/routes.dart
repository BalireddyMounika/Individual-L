import 'package:flutter/material.dart';
import 'package:life_eazy/view/Immunization/add_immunization_view.dart';
import 'package:life_eazy/view/Immunization/immunization_detail_view.dart';
import 'package:life_eazy/view/Immunization/immunization_usert_type_view.dart';
import 'package:life_eazy/view/Immunization/immunization_view.dart';
import 'package:life_eazy/view/Immunization/select_immunization_view.dart';
import 'package:life_eazy/view/Vitals/vitals_view.dart';
import 'package:life_eazy/view/appointments/appointment_booking_slots_view.dart';
import 'package:life_eazy/view/appointments/appointment_detail_view.dart';
import 'package:life_eazy/view/appointments/appointment_history_view.dart';
import 'package:life_eazy/view/appointments/appointment_summary_view.dart';
import 'package:life_eazy/view/appointments/appointments_view.dart';
import 'package:life_eazy/view/appointments/book_by_symptomps_view.dart';
import 'package:life_eazy/view/appointments/doctor_detail_view.dart';
import 'package:life_eazy/view/authentication/login/login_view.dart';
import 'package:life_eazy/view/authentication/registration/registration_success_view.dart';
import 'package:life_eazy/view/authentication/registration/registration_view.dart';
import 'package:life_eazy/view/authentication/signin_with_otp/signin_otp_view.dart';
import 'package:life_eazy/view/common_web_view.dart';
import 'package:life_eazy/view/dashboard/dashboard_view.dart';
import 'package:life_eazy/view/famlily_members/add_family_members_info_view.dart';
import 'package:life_eazy/view/famlily_members/family_members_information_view.dart';
import 'package:life_eazy/view/intro_screens/intro_screens_view.dart';
import 'package:life_eazy/view/notification/notifications_alerts_view.dart';
import 'package:life_eazy/view/payment_transaction/payment_transaction_view.dart';
import 'package:life_eazy/view/pharmacy/are_you_chronic_view.dart';
import 'package:life_eazy/view/pharmacy/pharmacy_detail_view.dart';
import 'package:life_eazy/view/pharmacy/pharmacy_order_details_view.dart';
import 'package:life_eazy/view/pharmacy/pharmacy_orders_view.dart';
import 'package:life_eazy/view/prefer_physician/add_prefer_physician_view.dart';
import 'package:life_eazy/view/prefer_physician/get_prefer_physician_view.dart';
import 'package:life_eazy/view/prescription/prescription_details_view.dart';
import 'package:life_eazy/view/prescription/prescription_list_view.dart';
import 'package:life_eazy/view/profile/profile_view.dart';
import 'package:life_eazy/view/profile/settings_view.dart';
import 'package:life_eazy/view/splash_screen_view.dart';
import 'package:life_eazy/view/subscription/view/subscription_view.dart';
import 'package:life_eazy/view/video_call/video_call_view.dart';
import 'package:life_eazy/view/vitals/vitals_details_view.dart';
import 'package:life_eazy/view/vitals/vitals_option_view.dart';

import '../view/appointments/widget/symptom_view_widget.dart';
import '../view/pharmacy/add_prescription_view.dart';
import '../view/pharmacy/pharmacy_listing_view.dart';
import '../view/vitals/choose_vitals_view.dart';
import '../view/vitals/fill_vitals_details_view.dart';

class Routes {
  //Authenticatin Module

  static const String enterPhoneNumberView = "/enterPhoneNumberView";
  static const String registrationSuccessView = "/registrationSuccessView";
  static const String registerView = "/registerView";
  static const String loginView = "/loginView";
  static const String signInWithOtpView = "/signInWithOtpView";
  static const String resetPasswordView = "/resetPasswordView";
  static const String settingsView = "/settingView";
  static const String profileView = "/profileView";
  static const String prescriptionDetailsView = "/PrescriptionDetailsView";
  static const String dependentInformationView = "/dependentInformationView";
  static const String addFamilyMembersInformationView =
      "/addDependentInformationView";
  static const String editFamilyMembersInformationView =
      "/editDependentInformationView";
  static const String transactionHistoryView = "/transactionHistoryView";

  //Authentication Module end here

  //Appointment Module Start here
  static const String bookDoctorAppointmentView = "/bookDoctorAppointmentView";
  static const String bookBySymptomsView = "/bookBySymptomsView";
  static const String doctorAppointmentBookingSlotsView =
      "/doctorAppointmentBookingSlotsView";
  static const String appointmentSummaryView = "/appointmentSummaryView";
  static const String appointmentHistoryView = "/appointmentHistoryView";
  static const String appointmentDetailView = "/appointmentDetailView";
  static const String doctorDetailView = "/doctorDetailView";

  // Vitals
  static const String vitalsView = "/vitalsView";
  static const String vitalsOptionView = "/vitalsOptionView";
  static const String chooseVitalsView = "/chooseVitalsView";
  static const String fillVitalsDetailsView = "/fillVitalsDetailsView";
  static const String vitalDetailView = "/vitalDetailsView";

  // Notification
  static const String notificationsAlertsView = "/notificationsAlertsView";

  //Appointment Module ends here
  static const String dashboardView = "/dashboardView";
  static const String splashScreenView = "/splashScreenView";

  //PreferfPhysician
  static const String preferPhysicianView = "/preferPhysicianView";
  static const String addPreferPhysicianView = "/addPreferPhysicianView";
  static const String prescriptionView = "/PrescriptionView";

  //PreferPhysicianEndsHere

  static const String commonWebView = "/commonWebView";

  // Video Call
  static const String videoCallView = "/videoCallView";
  static const String scheduleVideoCallView = "/scheduleVideoCallView";

  //IntroScreens
  static const String introScreensView = "/introScreensView";
  static const String symptomsViewWidget = "/symptomsViewWidget";

  //Immunization
  static const String immunizationView = "/ImmunizationView";
  static const String selectImmunizationView = "/selectImmunizationView";
  static const String addImmunizationView = "/addImmunizationView";
  static const String immunizationUserTypeView = "/immunizationUserTypeView";
  static const String immunizationDetailView = "/immunisationDetailView";

  //Pharmacy
  static const String areYouChronicView = "/areYouChronicView";
  static const String pharmacyListView = "/pharmacyListView";
  static const String pharmacyDetailView = "/pharmacyDetailView";
  static const String addPrescriptionView = "/addPrescriptionView";
  static const String pharmacyOrderView = "/pharmacyOrderView";
  static const String pharmacyOrderDetailView = "/pharmacyOrderDetailView";

  //Subscription
  static const String subscriptionView = "/subscriptionView";

  static Route<dynamic> generateRouter(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreenView());
      case commonWebView:
        Map maps = args as Map;
        var url = maps['url'];
        var title = maps['title'];
        return MaterialPageRoute(builder: (_) => CommonWebView(url, title));

      case registerView:
        return MaterialPageRoute(builder: (_) => RegisterView());
      case addFamilyMembersInformationView:
        Map maps = args as Map;
        var profileResponse = maps['profileResponse'];
        var isEdit = maps['isEdit'];
        return MaterialPageRoute(
            builder: (_) => AddFamilyMembersInfoView(profileResponse, isEdit));
      case bookDoctorAppointmentView:
        if (args == null)
          return MaterialPageRoute(builder: (_) => AppointmentsView());

        Map maps = args as Map;
        var isSpecialized = maps["isSpecialized"];
        var specialist = maps["specialist"];

        return MaterialPageRoute(
            builder: (_) => AppointmentsView(
                  isFromSpecialization: isSpecialized,
                  specialist: specialist,
                ));
      case doctorAppointmentBookingSlotsView:
        Map maps = args as Map;
        var doctorDetails = maps['doctorDetails'];
        return MaterialPageRoute(
            builder: (_) => AppointmentBookingSlotsView(doctorDetails));

      case doctorDetailView:
        Map maps = args as Map;
        var doctorId = maps['doctorId'];
        return MaterialPageRoute(builder: (_) => DoctorDetailView(doctorId));
      case appointmentSummaryView:
        Map maps = args as Map;
        var doctorDetails = maps['doctorDetails'];
        var appointmentRequest = maps['appointmentRequest'];
        var patientName = maps['patientName'];
        return MaterialPageRoute(
            builder: (_) => AppointmentSummaryView(
                appointmentRequest, doctorDetails, patientName));
      case bookBySymptomsView:
        return MaterialPageRoute(builder: (_) => BookBySymptomsView());
      case vitalsView:
        return MaterialPageRoute(builder: (_) => VitalsView());

      case vitalDetailView:
        Map maps = args as Map;
        var vitalList = maps['vitalList'];
        var name = maps["name"];
        var unit = maps["unit"];
        var tileKey = maps["tileKey"];
        var familyId = maps["familyId"];

        return MaterialPageRoute(
            builder: (_) =>
                VitalDetailsView(vitalList, name, unit, tileKey, familyId));

      case chooseVitalsView:
        Map maps = args as Map;
        var familyMemberId = maps['familyMemberId'];
        return MaterialPageRoute(
            builder: (_) => ChooseVitalsView(familyMemberId));

      case vitalsOptionView:
        return MaterialPageRoute(builder: (_) => VitalsOptionView());

      case fillVitalsDetailsView:
        Map maps = args as Map;
        var vitalResponse = maps['VitalResponse'];
        var isEdit = maps['isEdit'];
        var vitalOptionList = maps['VitalOptionList'];
        var familyMemberId = maps['familyMemberId'];
        return MaterialPageRoute(
            builder: (_) => FillVitalsDetailsView(
                vitalResponse, isEdit, vitalOptionList, familyMemberId));

      case transactionHistoryView:
        return MaterialPageRoute(builder: (_) => PaymentTransactionView());
      case appointmentHistoryView:
        return MaterialPageRoute(builder: (_) => AppointmentHistoryView());

      case appointmentDetailView:
        Map maps = args as Map;
        var appointmentResponse = maps['appointmentResponse'];
        return MaterialPageRoute(
            builder: (_) => AppointmentDetailView(appointmentResponse));

      case introScreensView:
        return MaterialPageRoute(builder: (_) => IntroScreensView());

      // case editFamilyMembersInformationView:
      //   return MaterialPageRoute(
      //       builder: (_) => EditFamilyMembersInformationView());
      case dependentInformationView:
        return MaterialPageRoute(
            builder: (_) => FamilyMembersInformationView());
      case loginView:
        return MaterialPageRoute(builder: (_) => LoginView());
      case profileView:
        return MaterialPageRoute(builder: (_) => ProfileView());
      case preferPhysicianView:
        return MaterialPageRoute(builder: (_) => PreferPhysiciansView());
      case addPreferPhysicianView:
        return MaterialPageRoute(builder: (_) => AddPreferPhysicianView());
      case settingsView:
        return MaterialPageRoute(builder: (_) => SettingsView());
      case pharmacyOrderView:
        return MaterialPageRoute(builder: (_) => PharmacyOrderView());
      case prescriptionView:
        Map maps = args as Map;
        var appointmentId = maps['appointmentId'];
        return MaterialPageRoute(
            builder: (_) => PrescriptionListView(appointmentId));

      case prescriptionDetailsView:
        Map maps = args as Map;
        var appointmentResponse = maps['appointmentId'];
        return MaterialPageRoute(
            builder: (_) => PrescriptionDetailsView(appointmentResponse));
      case registrationSuccessView:
        return MaterialPageRoute(builder: (_) => RegistrationSuccessView());
      // case resetPasswordView:
      //   return MaterialPageRoute(builder: (_) => ResetPasswordView());
      case signInWithOtpView:
        return MaterialPageRoute(builder: (_) => SignInWithOtpView());
      case dashboardView:
        return MaterialPageRoute(builder: (_) => DashBoardView());

      case videoCallView:
        Map maps = args as Map;
        var appId = maps['channelName'];
        return MaterialPageRoute(builder: (_) => VideoCallView(appId));
      // case scheduleVideoCallView:
      //   return MaterialPageRoute(builder: (_) => ScheduleVideoCallView());
      case notificationsAlertsView:
        return MaterialPageRoute(builder: (_) => NotificationAlertsView());
      case symptomsViewWidget:
        Map maps = args as Map;
        var doctorDetailResponse = maps['doctorDetailResponse'];
        return MaterialPageRoute(
            builder: (_) => SymptomViewWidget(doctorDetailResponse));

      case immunizationView:
        return MaterialPageRoute(builder: (_) => ImmunizationView());

      case immunizationUserTypeView:
        return MaterialPageRoute(builder: (_) => ImmunizationUserTypeView());
      case selectImmunizationView:
        return MaterialPageRoute(builder: (_) => SelectImmunizationView());
      case immunizationDetailView:
        Map maps = args as Map;
        var response = maps['response'];
        return MaterialPageRoute(
            builder: (_) => ImmunizationDetailView(response));

      case addImmunizationView:
        Map maps = args as Map;
        var selectedItem = maps['selectedItem'];
        return MaterialPageRoute(
            builder: (_) => AddImmunizationView(selectedItem));

      case areYouChronicView:
        return MaterialPageRoute(builder: (_) => AreYouChronicView());

      case pharmacyListView:
        return MaterialPageRoute(builder: (_) => PharmacyListingView());

      case pharmacyDetailView:
        Map maps = args as Map;
        var pharmacyResponse = maps['pharmacyResponse'];
        return MaterialPageRoute(
            builder: (_) => PharmacyDetalView(pharmacyResponse));

      case addPrescriptionView:
        Map maps = args as Map;
        var pharmacyResponse = maps['pharmacyResponse'];
        return MaterialPageRoute(
            builder: (_) => AddPrescriptionView(pharmacyResponse));
      case pharmacyOrderDetailView:
        Map maps = args as Map;
        var pharmacyOrderResponse = maps['pharmacyOrderResponse'];
        return MaterialPageRoute(
            builder: (_) => PharmacyOrderDetailView(pharmacyOrderResponse));

      case subscriptionView:
        return MaterialPageRoute(builder: (_) => SubscriptionView());

      default:
        return MaterialPageRoute(builder: (_) => LoginView());
    }
  }
}
