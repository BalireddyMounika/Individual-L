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
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/view/profile/widgets/address_info_widget.dart';
import 'package:life_eazy/view/profile/widgets/personal_info_widget.dart';
import 'package:life_eazy/viewmodel/profile/profile_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../enums/profile_image_state.dart';

class ProfileView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyProfileView();
}

class _MyProfileView extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final _picker = ImagePicker();
  late File _image;
  bool isImageSelected = false;
  late ProfileViewModel _viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _selectedIndex = _tabController.index;
//      viewModel.reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      onModelReady: (model) => model.getProfile(),
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        return Scaffold(
            resizeToAvoidBottomInset: true,
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
      viewModelBuilder: () => ProfileViewModel(),
    );
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 20,
        ),
        Column(
          children: [
            GestureDetector(
                onTap: () {
                  if (_tabController.index == 0)
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
                                        source: ImageSource.camera,
                                        imageQuality: 60);
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
                                        source: ImageSource.gallery,
                                        imageQuality: 60);
                                    setState(() {
                                      if (image?.path != null) {
                                        _image = File(image?.path ?? "");
                                        _viewModel.addUserProfileImage(_image);
                                        isImageSelected = true;
                                      }
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
                child: _profileCurrentWidget()),
            SizedBox(
              height: 20,
            ),
            Text(
              "${SessionManager.getUser.firstName ?? ""} ${SessionManager.getUser.lastName ?? ""}",
              style: mediumTextStyle.copyWith(
                  color: darkColor, fontWeight: FontWeight.bold),
            ),
            Text(
              "${SessionManager.getUser.email ?? ""}",
              style: bodyTextStyle.copyWith(color: darkColor),
              textAlign: TextAlign.right,
            ),
            Text(
              "${SessionManager.getUser.mobileNumber}",
              style: bodyTextStyle.copyWith(color: darkColor),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        // _topView(),

        DefaultTabController(
          initialIndex: _selectedIndex,
          length: 2,
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
              Tab(text: personalInfo),
              Tab(text: contactInfo),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              PersonalInfoWidget(),
              AddressInfoWidget(),
            ],
          ),
        ),
      ],
    );
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
              imageName: SessionManager.profileImageUrl ?? "",
              width: 100,
              height: 100,
            )));

      case ProfileImageState.Error:
        return Center(
          child: Icon(Icons.error),
        );

      case ProfileImageState.Idle:
        return Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 1), // changes position of shadow
                ),
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

  Widget _topView() {
    return Row(
      children: [
        SizedBox(
          width: 75,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.dashboardView);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset("images/dashboard/profile_dummy.png"),
                ),
                Text(
                  "${SessionManager.getUser.firstName} ${SessionManager.getUser.lastName}",
                  style: mediumTextStyle.copyWith(color: darkColor),
                ),
                Text(
                  "${SessionManager.getUser.email}",
                  style: mediumTextStyle.copyWith(color: darkColor),
                  textAlign: TextAlign.right,
                ),
                Text(
                  "${SessionManager.getUser.mobileNumber}",
                  style: mediumTextStyle.copyWith(color: darkColor),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 30,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${SessionManager.getUser.firstName} ${SessionManager.getUser.lastName}",
              style: mediumTextStyle.copyWith(color: darkColor),
            ),
            Text(
              "${SessionManager.getUser.email}",
              style: mediumTextStyle.copyWith(color: darkColor),
              textAlign: TextAlign.right,
            ),
            Text(
              "${SessionManager.getUser.mobileNumber}",
              style: mediumTextStyle.copyWith(color: darkColor),
              textAlign: TextAlign.right,
            ),
          ],
        )
      ],
    );
  }
}
