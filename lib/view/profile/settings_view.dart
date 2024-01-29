import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/prefs/local_storage_services.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../services/common_service/navigation_service.dart';

class SettingsView extends StatefulWidget {
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String currentAppVersion = '';

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      currentAppVersion = info.version;
    });
  }

  void initState() {
    _initPackageInfo();
    super.initState();
  }

  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _context = context;
    return Scaffold(
      appBar: CommonAppBar(
        title: myProfile,
        // isClearButtonVisible: false,
        // onBackPressed: () {
        //   Navigator.pop(context);
        // },
        isClearButtonVisible: true,
        onBackPressed: () {
          if (Navigator.canPop(context))
            Navigator.pop(context);
          else
            locator<NavigationService>()
                .navigateToAndRemoveUntil(Routes.dashboardView);
        },
        onClearPressed: () {
          locator<NavigationService>()
              .navigateToAndRemoveUntil(Routes.dashboardView);
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: profileMargin,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30,
              ),
              _itemContainer(myDetails, Icons.person,
                  routes: Routes.profileView),
              _itemContainer(transactionHistory, Icons.history,
                  routes: Routes.transactionHistoryView),
              _itemContainer(emergencyInfo, Icons.people,
                  routes: Routes.dependentInformationView),
              _itemContainer(preferredPhysician, Icons.people_outline,
                  routes: Routes.preferPhysicianView),
              _itemContainer('My Order', Icons.note_rounded,
                  routes: Routes.pharmacyOrderView),
              _itemContainer("Subscription", Icons.workspace_premium,
                  hintText: 'coming soon..'),
              _helpContainer(
                  "Contact Us / HelpCenter",
                  Icons.person,
                  "https://vivifyhealthcare.atlassian.net/servicedesk/customer/portal/5/group/-1",
                  "HelpCenter",
                  routes: Routes.commonWebView),
              _helpContainer(
                  "Privacy Policy",
                  Icons.privacy_tip_outlined,
                  "https://www.vivifyhealthcare.com/privacy-policy/",
                  "Privacy Policy",
                  routes: Routes.commonWebView),
              _helpContainer(
                  "Terms & Conditions",
                  Icons.note,
                  "https://www.vivifyhealthcare.com/terms-condition-lifeeazy/",
                  "Terms & Conditions",
                  routes: Routes.commonWebView),
              _helpContainer(
                  "Cancellation & Refund Policy",
                  Icons.policy,
                  "https://www.vivifyhealthcare.com/cancellation-refund-policy/",
                  "Cancellation & Refund Policy",
                  routes: Routes.commonWebView),
              _itemContainer(logOut, Icons.logout),
              Text(
                "Vivify Healthcare Pvt. Ltd. \n"
                "V $currentAppVersion",
                style: bodyTextStyle.copyWith(
                    color: baseColor, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              verticalSpaceLarge,
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemContainer(label, icon, {routes, hintText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: () {
          if (label == "Log Out") {
            locator<LocalStorageService>().setIsLogIn(false);
            SessionManager.profileImageUrl = "";
            locator<LocalStorageService>().setProfileImage("");
            showDialog(
                context: _context,
                builder: (context) => PopUpDialog(
                      dialogType: DialogType.WarningDialog,
                      title: "Are you sure you want to Log Out",
                      buttonText: "Yes",
                      isStackCleared: true,
                      isNoButtonVisible: true,
                      routes: Routes.signInWithOtpView,
                    ));
          } else
            Navigator.pushNamed(_context, routes);
        },
        child: Card(
          elevation: standardCardElevation,
          shadowColor: Colors.white70,
          child: Container(
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      icon,
                      color: baseColor,
                      size: 24,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      label,
                      style: mediumTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.5)),
                    )
                  ],
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Text(
                        hintText ?? '',
                        style: smallTextStyle.copyWith(color: baseColor),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _helpContainer(label, icon, url, title, {routes}) {
    Map maps = Map();
    maps['url'] = url;
    maps['title'] = title;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: () {
          if (label == "Log Out")
            showDialog(
                context: _context,
                builder: (context) => PopUpDialog(
                      dialogType: DialogType.WarningDialog,
                      title: "Are you sure you want to Log Out",
                      buttonText: "Yes",
                      isStackCleared: true,
                      routes: Routes.loginView,
                    ));
          else
            Navigator.pushNamed(_context, routes, arguments: maps);
        },
        child: Card(
          elevation: standardCardElevation,
          shadowColor: Colors.white70,
          child: Container(
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      icon,
                      color: baseColor,
                      size: 24,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      label,
                      style: mediumTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.5)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
