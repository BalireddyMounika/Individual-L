
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/search_view.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/route/routes.dart';

class BookBySymptomsView extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() =>_BookBySyptomsView();

}

class _BookBySyptomsView extends State<BookBySymptomsView>
{
  var items=  [new Item(text: "Fever",image: "images/symptoms/Fever.png"),
    new Item(text: "Fever",image: "images/symptoms/acne.png"),
    new Item(text: "Headche",image: "images/symptoms/headache.png"),
    new Item(text: "Dark Circles",image: "images/symptoms/darkcircles.png"),
    new Item(text: "Achne",image: "images/symptoms/acne.png"),
    new Item(text: "Blocked Nose",image: "images/symptoms/blockednose.png"),
    new Item(text: "Cough",image: "images/symptoms/cough.png"),
    new Item(text: "Vomiting",image: "images/symptoms/vomting.png"),
    new Item(text: "Hair Falling",image: "images/symptoms/hairfalling.png"),
    new Item(text: "Itching",image: "images/symptoms/itching.png"),
    new Item(text: "Heart Burn",image: "images/symptoms/Heartburn.png"),
    new Item(text: "Allergies",image: "images/symptoms/allergy.png"),
    new Item(text: "Heart Stroke",image: "images/symptoms/Heartstroke.png"),

  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CommonAppBar(
        title: appointments,
        onBackPressed: () {
          Navigator.pop(context);
        },
        onClearPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.dashboardView, (route) => false);
        },
      ),

      body: Container(
        margin: dashBoardMargin,
        child: Column(
          children: [
             SizedBox(height:30),

             SearchView(),
             SizedBox(height:20),
              Flexible(child: GridView.builder(
                itemCount:items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).orientation ==
                      Orientation.landscape ? 3: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: (2 / 1),
                ),
                itemBuilder: (context,index,) {
                  return _gridContainer(items[index].image, items[index].text);
                },
              )),


            SizedBox(height: 20,)

          ],

        ),
      ),


    );
  }

  Widget _searchView() {
    return Container(
        height: kToolbarHeight + 10,
        child: Card(
          elevation: 2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: baseColor,
                  size: 24,
                ),
              ),
              Flexible(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: TextFormField(
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).nearestScope;
                      },
                      onSaved: (value) {},
                      validator: (value) {},
                      onChanged: (value) {

                      },
                      style: mediumTextStyle,
                      decoration: InputDecoration(
                        labelStyle: textFieldsHintTextStyle,
                        hintStyle: textFieldsHintTextStyle,
                        hintText: search,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _gridContainer(image,title)
  {
    return Card(
      elevation: standardCardElevation,

      child: Container(

        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [

            Image.asset(image,color: baseColor,height: 28,),
            SizedBox(height: 10,),
            Text(title,style:mediumTextStyle,
                textAlign: TextAlign.center),
          ],
        ),

      ),
    );
  }

}

class Item
{
  String? image;
  String? text;

  Item(
  {
    this.text,
    this.image
}
      );

}