import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_eazy/manager/dialog_manager.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';

import 'get_it/locator.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);


  final GlobalKey<ScaffoldMessengerState> globalStateKey =
  GlobalKey<ScaffoldMessengerState>();

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    String? token = await FirebaseMessaging.instance.getToken();
    SessionManager.fcmToken = token;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white, // status bar color
    ));
    await setupLocator();
    runApp(MyApp());
  }}

  class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
  builder: (context, widget) => Navigator(
  onGenerateRoute: (settings) => MaterialPageRoute(
  builder: (context) => DialogManager(
  child: widget!,
  ),
  ),
  ),
  title: 'Lifeeazy Individual',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
  appBarTheme: AppBarTheme(
  elevation: 0,
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  ),
  // This is the theme of your application.
  primarySwatch: Colors.green,
  ),
  initialRoute: '/',
  // scaffoldMessengerKey: globalStateKey,
  navigatorKey: locator<NavigationService>().navigatorKey,
  onGenerateRoute: Routes.generateRouter,
  );
  }
  }
