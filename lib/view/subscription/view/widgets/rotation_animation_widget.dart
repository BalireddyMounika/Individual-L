import 'package:flutter/material.dart';






class ImageRotate extends StatefulWidget {
  @override
  _ImageRotateState createState() => new _ImageRotateState();
}

class _ImageRotateState extends State<ImageRotate>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 7),
    );

    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(

      color: Colors.transparent,
      alignment: Alignment.center,
      // color: Colors.transparent,
      child: new AnimatedBuilder(
        animation: animationController,
        child: new Container(
          height: 40.0,
          width: 40.0,
          child: Image.asset('images/icon/img.png'),
        ),
        builder: (BuildContext context, _widget) {
          return Transform.rotate(
            angle: animationController.value * 11.3,
            child: _widget,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }
}