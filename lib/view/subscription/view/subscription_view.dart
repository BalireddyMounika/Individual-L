import 'dart:math';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/view/subscription/view/widgets/rotation_animation_widget.dart';
import 'package:life_eazy/viewmodel/subscription/subscription_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'dart:math' as math;
import '../../../common_widgets/empty_list_widget.dart';
import '../../../common_widgets/loader.dart';
import '../../../constants/colors.dart';
import '../../../enums/viewstate.dart';
import '../../../get_it/locator.dart';
import '../paints/background_painter.dart';
import '../paints/custom_cliper.dart';

class SubscriptionView extends StatefulWidget  {
  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> with SingleTickerProviderStateMixin {
 late  Animation<double> animation;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 4), vsync: this);
    _controller.repeat();
    //we set animation duration, and repeat for infinity

    animation = Tween<double>(begin: -400, end: 0).animate(_controller);
    //we have set begin to -600 and end to 0, it will provide the value for
    //left or right position for Positioned() widget to creat movement from left to right
    animation.addListener(() {
      setState(() {}); //update UI on every animation value update
    });
  }
 @override
 void dispose() {
   super.dispose();
   _controller.dispose(); //destory anmiation to free memory on last
 }
  late SubscriptionViewModel _viewModel;
  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<SubscriptionViewModel>.reactive(
        onModelReady: (model) async{
         await model.getAllMasterSubscription();
         await model.getBySubscriptionUserId();
        },
        viewModelBuilder: ()=>SubscriptionViewModel(),

        builder: (context,viewmodel,child){
          _viewModel = viewmodel;
          return  Scaffold(
            appBar: CommonAppBar(
              title: "Subscriptions",
              isClearButtonVisible: true,
              onBackPressed: (){
                Navigator.pop(context);
              },
              onClearPressed: (){
                locator<NavigationService>().navigateToAndRemoveUntil(Routes.dashboardView);
              },
            ),

            body: _currentWidget(),
          );
        });

  }
  


  Widget _body() {

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment(-1.0, 0.0),
                  end: Alignment(
                    1.0,
                    0.0,
                  ),
                  transform: GradientRotation(math.pi / 4),
                  colors: [baseColor, Colors.white, secondaryColor],
                )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageRotate(),
                    verticalSpaceSmall,
                    Text(
                      "",
                      style:
                          mediumTextStyle.copyWith(fontWeight: FontWeight.w500),
                    ),
                    verticalSpaceTiny,
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        "Go beyond the limits ,Get exclusive feature ,full support by getting this subscription",
                        textAlign: TextAlign.center,
                        style: smallTextStyle.copyWith(
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(height: 5,),
          Expanded(
            flex: 7,
            child: Container(
              margin: EdgeInsets.only(left: 15,right:15,bottom: 10),
              child:ListView.builder(
                  itemCount: _viewModel.subscriptionList.length,
                  itemBuilder: (context,index){

                return _itemContainer(index);

              }),
            ),
          ),
        ],
      );
    });
  }
 Widget _currentWidget() {
   switch (_viewModel.state) {
     case ViewState.Loading:
       return Loader(
         loadingMessage: "Fetching Subscription",
         loadingMsgColor: Colors.black,
       );
     case ViewState.Empty:
       return EmptyListWidget("Nothing Found");
     case ViewState.Completed:
       return _body();

     case ViewState.Error:
       return Center(
           child: Text(
             somethingWentWrong,
             style: mediumTextStyle,
           ));

     default:
       return _body();
   }
 }

  Widget _itemContainer(index)
  {
    bool isSubscribed =false;
    var name=_viewModel.subscriptionList[index].subscriptionName;
   // bool result=_viewModel.subscriptionList.contains(_viewModel.subscribedUserModel.userId);
    if(_viewModel.subscriptionList[index].id == _viewModel.subscribedUserModel.subscriptionId?.id)
      isSubscribed = true;
    var subName=name!.toUpperCase();
    return Card(
      elevation: 1,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(left: 10,top: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$subName",style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4,),
          Text("Validity for ${_viewModel.subscriptionList[index].subscriptionValidity} days"),
          SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if(!isSubscribed)
                       _viewModel.postSubscription(_viewModel.subscriptionList[index].id);



                    },
                    child: Text(isSubscribed?('Subscribed') :('Subscribe')),
                    style: ElevatedButton.styleFrom(shape: StadiumBorder(),
                    primary:isSubscribed?Colors.orange:baseColor),
                  ),
                  SizedBox(height: 3,),
                  Text(" ₹${_viewModel.subscriptionList[index].subscriptionPrice}",style: TextStyle(fontWeight: FontWeight.bold),),

                ],
              )

            ],
          )),
    );


  }

}


