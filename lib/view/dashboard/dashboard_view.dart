import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/view/dashboard/widgets/dashboard_image.dart';
import 'package:life_eazy/view/dashboard/widgets/join_tele_call_dialog.dart';
import 'package:life_eazy/view/dashboard/widgets/location_search_widget.dart';
import 'package:life_eazy/view/dashboard/widgets/screen.dart';
import 'package:life_eazy/viewmodel/dashboard/dashboard_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DashBoardView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashBoardView();
}

class _DashBoardView extends State<DashBoardView> {
  late BuildContext _context;
  late DashBoardViewModel viewModel;
  BorderRadius commonRadius = BorderRadius.circular(10);
  List<String> carouselItem = [
    "images/dashboard/banner.jpg",
    "images/dashboard/banner.jpg",
    "images/dashboard/banner.jpg"
  ];

  late DashBoardViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return ViewModelBuilder<DashBoardViewModel>.reactive(
      onViewModelReady: (model) => model.initialiseData(),
      builder: (context, viewModel, child) {
        this.viewModel = viewModel;
        _viewModel = viewModel;
        //_context =context;
        return WillPopScope(
            child: Scaffold(
                bottomNavigationBar: _bottomNavigationBar(),
                backgroundColor: Colors.white,
                body: _currentWidget()),
            onWillPop: () async => false);
      },
      viewModelBuilder: () => DashBoardViewModel(),
    );
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: "Loading..",
        );

      case ViewState.Completed:
        return _body();

      case ViewState.Error:
        return const Center(
            child: Text(
          "Something went wrong",
          style: TextStyle(fontSize: 18),
        ));
      case ViewState.Empty:
        return EmptyListWidget("Nothing Found");

      default:
        return _body();
    }
  }

  Widget _covidVaccinationCard() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'COVID-19 Essentials',
                  style: mediumTextStyle,
                ),
                Text(
                  'Coming Soon..',
                  style: smallTextStyle.copyWith(color: redColor),
                )
              ],
            ),
            verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _covidVaccinationItemRow('Book Slot', Icons.add_chart),
                horizontalSpaceMedium,
                _covidVaccinationItemRow('Queries & Call', Icons.call),
              ],
            ),
            verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _covidVaccinationItemRow('Check Status', Icons.auto_graph),
                horizontalSpaceMedium,
                _covidVaccinationItemRow(
                    'Get Certificate', Icons.book_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _covidVaccinationItemRow(String title, IconData icon) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: baseColor), borderRadius: commonRadius),
        child: Padding(
          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
          child: Row(
            children: [
              Container(
                height: 28,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: commonRadius,
                  color: Color(0xffDCEDF9),
                ),
                child: Icon(
                  icon,
                  color: redColor,
                  size: 14,
                ),
              ),
              horizontalSpaceTiny,
              Text(
                title,
                style: bodyTextStyle.copyWith(fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _topView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 50,
                width: 55,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.settingsView);
                    },
                    child: Stack(children: [
                      DashboardImageWidget(
                        circleSize: 40,
                      ),
                      Positioned(
                        child: Image.asset(
                          "images/dashboard/premium.png",
                          height: 42,
                          width: 42,
                        ),
                        top: 12,
                        left: 20,
                      )
                    ])),
              ),
              Image.asset(
                'images/lifeeazy.png',
                width: 150,
              ),
              Text(
                '${_viewModel.getProfileResponse.authorizedCode ?? '0000'}',
                style: mediumTextStyle.copyWith(
                    color: baseColor, fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.notificationsAlertsView);
                },
                child: Icon(
                  Icons.notifications_active_outlined,
                  size: 28,
                ),
              ),
            ],
          ),
          verticalSpaceAverage,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Hi , ",
                    style:
                        mediumTextStyle.copyWith(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: SessionManager.getUser.firstName ?? "User",
                    style: bodyTextStyle.copyWith(fontWeight: FontWeight.w500)),
              ])),
              Container(
                child: GestureDetector(
                  onTap: () async {
                    var data = await Navigator.of(context)
                        .push(new MaterialPageRoute<String>(
                            builder: (BuildContext context) {
                              return new LocationSearchWidget();
                            },
                            fullscreenDialog: true));
                    _viewModel.updateLocation(data);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: baseColor,
                      ),
                      Text(
                        SessionManager.getLocation.city == null
                            ? " Your Location"
                            : '${SessionManager.getLocation.city}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: darkColor,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  Widget _body() {
    return RefreshIndicator(
      onRefresh: () async {
        _viewModel.getVideoCallRequest();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpaceSmall,
                      _topView(),
                      Container(
                        color: Color(0xffF8F8F8),
                        child: Column(
                          children: [
                            verticalSpaceMedium,
                            _bookAppointment(),
                            verticalSpaceMedium,
                            _myAppointment(),
                            verticalSpaceMedium,
                            _covidVaccinationCard(),
                            verticalSpaceMedium,
                            _vitalsHealthSection(),
                            verticalSpaceMedium,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _viewModel.isRequestVisible,
                  child: Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: MediaQuery.of(context).size.width / 1.3,
                        child: Card(
                            elevation: 5,
                            child: JoinTeleCallDialog(
                                _viewModel.callRequestResponse)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const screen()),
            );
          },
          // onPressed: () {
          //   Map maps = Map();
          //   maps['url'] = 'http://bot.vivifyhealthcare.com/';
          //   maps['title'] = 'Lifeeazy Health Companion';
          //   Navigator.pushNamed(_context, Routes.commonWebView, arguments: maps);
          // },
          child: Icon(Icons.messenger_outline),
          backgroundColor: baseColor,
        ),
      ),
    );
  }

  Widget _vitalsHealthSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: healthStatusContainer(
                  name: 'Vitals',
                  icon: Icons.post_add_sharp,
                  onTap: () {
                    locator<NavigationService>().navigateTo(Routes.vitalsView);
                  },
                ),
              ),
              Expanded(
                child: healthStatusContainer(
                  name: 'Immunization',
                  icon: Icons.local_hospital,
                  onTap: () {
                    locator<NavigationService>()
                        .navigateTo(Routes.immunizationView);
                  },
                ),
              ),
            ],
          ),
          verticalSpaceSmall,
          Row(
            children: [
              Expanded(
                flex: 1,
                child: healthStatusContainer(
                  name: 'Pharmacy',
                  icon: Icons.medical_services,
                  onTap: () {
                    locator<NavigationService>()
                        .navigateTo(Routes.areYouChronicView);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: healthStatusContainer(
                  name: 'Health Status',
                  icon: Icons.query_stats,
                  isComingSoon: true,
                  onTap: () {},
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget healthStatusContainer(
      {String? name, IconData? icon, VoidCallback? onTap, bool? isComingSoon}) {
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: commonRadius,
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      icon,
                      color: baseColor,
                      size: 38,
                    ),
                    isComingSoon ?? false
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'coming soon',
                              style: smallTextStyle.copyWith(color: redColor),
                            ))
                        : SizedBox()
                  ],
                ),
                verticalSpaceMedium,
                Text(
                  name ?? '-',
                  maxLines: 2,
                  style: bodyTextStyle.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _myAppointment() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.appointmentHistoryView);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: commonRadius,
          ),
          elevation: 2,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: baseColor,
              ),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Center(
                  child: Text(
                'My Appointments',
                style: largeTextStyle.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ))),
        ),
      ),
    );
  }

  Widget _bookAppointment() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: commonRadius,
          ),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Appointment',
                  style: mediumTextStyle,
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        var maps = new Map();
                        maps["isSpecialized"] = true;
                        maps["specialist"] = "Home";
                        locator<NavigationService>().navigateTo(
                            Routes.bookDoctorAppointmentView,
                            arguments: maps);
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.home,
                                size: 24,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xbb6d3670),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 40,
                                    color: Color.fromRGBO(0, 0, 0, 0.10),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpaceSmall,
                            Text(
                              'At Home',
                              style: smallTextStyle.copyWith(
                                  fontWeight: FontWeight.w600),
                              maxLines: 2,
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        var maps = new Map();
                        maps["isSpecialized"] = true;
                        maps["specialist"] = "Teleconsultation";
                        locator<NavigationService>().navigateTo(
                            Routes.bookDoctorAppointmentView,
                            arguments: maps);
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.video_call,
                                size: 24,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xbb0ccc86),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 40,
                                    color: Color.fromRGBO(0, 0, 0, 0.10),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpaceSmall,
                            Text(
                              'Tele Consultation',
                              style: smallTextStyle.copyWith(
                                  fontWeight: FontWeight.w600),
                              maxLines: 2,
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        var maps = new Map();
                        maps["isSpecialized"] = true;
                        maps["specialist"] = "In-clinic";
                        locator<NavigationService>().navigateTo(
                            Routes.bookDoctorAppointmentView,
                            arguments: maps);
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.local_hospital,
                                size: 24,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xbbf2b416),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 40,
                                    color: Color.fromRGBO(0, 0, 0, 0.10),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpaceSmall,
                            Text(
                              'At Clinic',
                              style: smallTextStyle.copyWith(
                                  fontWeight: FontWeight.w600),
                              maxLines: 2,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
        onTap: onTabTapped,
        showUnselectedLabels: true,
        // currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: baseColor,
        unselectedItemColor: unSelectedColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: home,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
            ),
            label: appointments,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.more_vert_outlined,
            ),
            label: more,
          )
        ]);
  }

  onTabTapped(int index) {
    switch (index) {
      case 1:
        Navigator.pushNamed(context, Routes.appointmentHistoryView);
        break;
      case 2:
        Navigator.pushNamed(context, Routes.settingsView);
        break;
      default:
        print('choose a different choice');
    }

    // setState(() {
    //   _currentIndex = index;
    //   if (_currentIndex == 2) {
    //     Navigator.pushNamed(context, Routes.settingsView);
    //   } else {
    //     if (_currentIndex == 1) {
    //       Navigator.pushNamed(context, Routes.appointmentHistoryView);
    //     }
    //   }
    // }
  }
}
