import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName,arguments: arguments);
  }

  Future<dynamic> navigateToAndRemoveUntil(String routeName) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (routes) => false);
  }

  void goBack() {
    if(navigatorKey.currentState!.canPop())
    return navigatorKey.currentState!.pop();
  }
}
