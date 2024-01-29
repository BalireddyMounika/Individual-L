import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackGroundPainter extends CustomPainter
{

  @override
  void paint(Canvas canvas, Size size) {

    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 15;

    var path = Path();




    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.7,
        size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9,
        size.width * 1.0, size.height * 0.8);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {

    return false;
  }
  
}



class SecondBackGroundPainter extends CustomPainter
{

  @override
  void paint(Canvas canvas, Size size) {

    var paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 15;

    var path = Path();


    path.lineTo(0, size.height); //start path with this if you are making at bottom

    // var firstStart = Offset(size.width / 5, size.height);
    // //fist point of quadratic bezier curve
    // var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    // //second point of quadratic bezier curve
    // path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width/2, size.height/2.5);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0); //end with this path if you are making wave at bottom

    // path.moveTo(0, size.height);
    // path.quadraticBezierTo(size.width, size.height/2, size.width/2, size.height);
    canvas.drawPath(path, paint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {

    return false;
  }

}