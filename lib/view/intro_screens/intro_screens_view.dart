import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';

class IntroScreensView extends StatefulWidget {
  @override
  _IntroScreensViewState createState() => _IntroScreensViewState();
}

class _IntroScreensViewState extends State<IntroScreensView> {
  // IntroductionScreen IntroductionScreenController = IntroductionScreen();
  List<Widget> getPages() {
    return [
      Container(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Image.asset('images/lifeeazy.png',width: 200,),
            SizedBox(height: 30,),
            Image.asset('images/introscreens/intro_screen1.png',height: 300,),
            SizedBox(height: 60,),
            Padding(padding: EdgeInsets.symmetric( horizontal: 20),
                child:
                Text('Relationships emotions surroundings of  your life impact to our overall health . One click to improve your well-being',
                  style: TextStyle(fontWeight:FontWeight.w400,fontSize: 20, ),
                  textAlign: TextAlign.center,
                )
            ),
          ],
        ),
      ),
      Container(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Image.asset('images/lifeeazy.png',width: 200,),
            SizedBox(height: 30,),
            Image.asset('images/introscreens/intro_screen2.png',height: 300,),
            SizedBox(height: 60,),
            Padding(padding: EdgeInsets.symmetric( horizontal: 20),
                child:
                Text('Get the best healthcare  Experience , without leaving  home.',
                  style: TextStyle(fontWeight:FontWeight.w400,fontSize: 20, ),
                  textAlign: TextAlign.center,
                )
            ),
          ],
        ),
      ),
      Container(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Image.asset('images/lifeeazy.png',width: 200,),
            SizedBox(height: 30,),
            Image.asset('images/introscreens/intro_screen3.png',height: 300,),
            SizedBox(height: 60,),
            Padding(padding: EdgeInsets.symmetric( horizontal: 20),
                child:
                Text('We manage your  medical data,  monitoring  appointments, and your Health records',
                  style: TextStyle(fontWeight:FontWeight.w400,fontSize: 20, ),
                  textAlign: TextAlign.center,
                )
            ),
          ],
        ),
      ),


    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  IntroductionScreen(
        globalBackgroundColor: Colors.white,
        globalFooter: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: 54,
              width: double.infinity,
              child: ButtonContainer(
                buttonText: ' Skip & Get Start',
                onPressed: () {
                  locator<NavigationService>()
                      .navigateToAndRemoveUntil(Routes.signInWithOtpView);
                },
              )),
        ),
        rawPages: getPages(),
        showDoneButton: false,
        showNextButton: false,
        showSkipButton: false,
        isBottomSafeArea: true,

      ),
    );
  }
}
