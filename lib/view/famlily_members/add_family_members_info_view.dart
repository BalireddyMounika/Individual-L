import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/common_widgets/network_image_widget.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/models/family_members/get_family_members_response.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/view/famlily_members/widgets/family_members_info_widget.dart';
import 'package:life_eazy/viewmodel/family_members/family_members_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../enums/profile_image_state.dart';

class AddFamilyMembersInfoView extends StatefulWidget {
  GetFamilyMemberResponse _familyMemberResponse;
  bool isEdit = false;
  AddFamilyMembersInfoView(this._familyMemberResponse, this.isEdit);
  @override
  State<StatefulWidget> createState() => _AddFamilyMembersInfoView();
}

class _AddFamilyMembersInfoView extends State<AddFamilyMembersInfoView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final _picker = ImagePicker();
  late File _image;
  bool isImageSelected = false;
  late FamilyMembersViewModel _viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(() {
      _selectedIndex = _tabController.index;
//      viewModel.reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FamilyMembersViewModel>.reactive(
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: CommonAppBar(
              title: myDetails,
              onBackPressed: () {
                Navigator.pop(context);
              },
              onClearPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.dashboardView, (route) => false);
              },
            ),
            body: _currentWidget());
      },
      viewModelBuilder: () => widget.isEdit
          ? FamilyMembersViewModel.edit(widget._familyMemberResponse, true)
          : FamilyMembersViewModel(),
    );
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (dialogContext) => SimpleDialog(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.pop(dialogContext);
                            var image = await _picker.pickImage(
                                source: ImageSource.camera, imageQuality: 60);
                            setState(() {
                              _image = File(image?.path ?? "");
                              _viewModel.addUserProfileImage(_image);
                              isImageSelected = true;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.camera,
                                  color: baseColor,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  camera,
                                  style: mediumTextStyle,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.pop(dialogContext);
                            var image = await _picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 60);
                            setState(() {
                              _image = File(image?.path ?? "");
                              _viewModel.addUserProfileImage(_image);
                              isImageSelected = true;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.image,
                                  color: baseColor,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  gallery,
                                  style: mediumTextStyle,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          child: _profileCurrentWidget(),
        ),
        // GestureDetector(
        //   onTap: (){
        //     // SimpleDialog dialog = SimpleDialog(
        //     //   children: [ Container(
        //     //     padding: EdgeInsets.all(5),
        //     //     child: Row(
        //     //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     //       crossAxisAlignment: CrossAxisAlignment.start,
        //     //       children: [
        //     //         InkWell(
        //     //             onTap: () async{
        //     //               Navigator.pop(context);
        //     //               var image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 60);
        //     //               setState(() {
        //     //                 _image = File(image?.path??"");
        //     //                 isImageSelected =true;
        //     //               });
        //     //             },
        //     //             child: Padding(
        //     //               padding: const EdgeInsets.all(8.0),
        //     //               child: Column(children: [Icon(Icons.camera,color: baseColor,),SizedBox(height: 5,),Text(camera,style: mediumTextStyle,)],),
        //     //             )),
        //     //         InkWell(
        //     //             onTap: () async {
        //     //
        //     //               Navigator.pop(context);
        //     //               var image = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 60);
        //     //               setState(() {
        //     //                 _image = File(image?.path??"");
        //     //                 isImageSelected =true;
        //     //               });
        //     //             },
        //     //             child: Padding(
        //     //               padding: const EdgeInsets.all(8.0),
        //     //               child: Column(children: [Icon(Icons.image,color: baseColor,),SizedBox(height: 5,),Text(gallery,style: mediumTextStyle,)],),
        //     //             ))
        //     //       ],),)],
        //     //
        //     // );
        //     //
        //     // showDialog(context: context,builder:(_)=> dialog);
        //
        //   },
        //   child: isImageSelected? SizedBox(
        //       height: 120,
        //       width: 120,
        //       child: CircleAvatar(
        //         backgroundColor: Colors.white,
        //         foregroundColor: baseColor,
        //
        //         foregroundImage:  Image.file(_image,fit: BoxFit.contain,).image,
        //
        //       )) : Container(
        //     height: 120,
        //     width: 120,
        //     decoration: BoxDecoration(
        //         color: Colors.white,
        //         shape: BoxShape.circle
        //     ),
        //
        //     child:  Center(
        //       child: Icon(
        //         Icons.add_a_photo,
        //         color: darkColor,
        //         size: 40,
        //       ),
        //     ),
        //
        //
        //   ),
        // ),
        DefaultTabController(
          initialIndex: _selectedIndex,
          length: 1,
          child: TabBar(
            indicatorColor: secondaryColor,
            isScrollable: false,
            unselectedLabelColor: darkColor,
            labelColor: baseColor,
            automaticIndicatorColorAdjustment: true,
            controller: _tabController,
            onTap: (index) {
              _tabController.animateTo(index);
            },
            tabs: [
              Tab(text: "FamilyMember Info"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              FamilyMembersPersonalInfoWidget(),
            ],
          ),
        ),
        // Expanded(
        //   child: TabBarView(
        //     controller: _tabController,
        //     children: [FamilyMembersPersonalInfoWidget(),FamilyMembersViewModel.tempFamilyMemberId==0? Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         SizedBox(height: 100,),
        //         Icon(Icons.warning,size: 70,),
        //         SizedBox(height: 40,),
        //          Center(child: Text("Add Personal Info before filling the address section",style: mediumTextStyle,),),
        //       ],
        //     ) : FamilyMembersAddressInfoWidget()],
        //   ),
        // ),
      ],
    );
  }

  Widget _profileCurrentWidget() {
    switch (_viewModel.profileState) {
      case ProfileImageState.Loading:
        return Loader(
          isScaffold: false,
        );
      case ProfileImageState.Completed:
        return SizedBox(
          height: 100,
          width: 100,
          child: ClipOval(
            child: NetworkImageWidget(
              imageName: _viewModel.profileImage,
              width: 100,
              height: 100,
            ),
          ),
        );

      case ProfileImageState.Error:
        return Center(child: Icon(Icons.error));

      case ProfileImageState.Idle:
        return Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(color: Colors.white,
              //shape: BoxShape.circle,
              boxShadow: [
                // BoxShadow(
                //   color: Colors.grey.withOpacity(0.3),
                //   spreadRadius: 1,
                //   blurRadius: 3,
                //   offset: Offset(0, 1), // changes position of shadow
                // ),
              ]),
          child: Center(
            child: Icon(
              Icons.add_a_photo,
              color: darkColor,
              size: 40,
            ),
          ),
        );

      default:
        return _body();
    }
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: _viewModel.loaderMsg,
          loadingMsgColor: Colors.black,
        );

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
}
