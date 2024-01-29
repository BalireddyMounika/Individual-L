import 'package:flutter/material.dart';

class VitalsWidget extends StatelessWidget {
  final String name ;
  final String value;
  final String img;
  const VitalsWidget({Key? key, required this.name , required this.value , required this.img}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.all(0),

      // width: 115,
      // height: 110,
      child:
      Card(
        elevation: 1,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding:EdgeInsets.all(10),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(name,style:TextStyle(fontSize: 12) ,),
            Image.asset(img , height: 22,),
            Text(value, style: TextStyle(fontSize: 12),),
          ],
        ),
      ),
    ),);


  }
}