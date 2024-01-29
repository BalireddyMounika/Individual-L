import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:life_eazy/tools/date_formatting.dart';
import 'package:life_eazy/viewmodel/notification/notification_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NotificationAlertsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotificationAlertsView();
}

class _NotificationAlertsView extends State<NotificationAlertsView> {
  late BuildContext _context;
  late NotificationViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationViewModel>.reactive(
      onModelReady: (model) => model.getNotificationInfo(),
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        _context = context;
        return Scaffold(
          appBar: CommonAppBar(
            title: "Notifications & Alerts",
            onBackPressed: () {
              Navigator.pop(context);
            },
            isClearButtonVisible: true,
            onClearPressed: () {
              locator<NavigationService>()
                  .navigateToAndRemoveUntil(Routes.dashboardView);
            },
          ),
          body: _currentWidget(),
        );
      },
      viewModelBuilder: () => NotificationViewModel(),
    );
  }

  Widget _body() {
    return Container(
        child:  ListView.builder(
              itemCount: _viewModel.notificationList.length,
              itemBuilder: (context, index) {
                return _itemContainer(
                    _viewModel.notificationList.length - (index + 1));
              }),
        );
  }

  Widget _itemContainer(index) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5 , horizontal: 16),
            child: Row(
              children: [

                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: baseColor,
                    child: Center(
                      child: Image.asset(
                        "images/vector.png",
                        cacheHeight: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${_viewModel.notificationList[index].title ?? ""}",
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                   Container(
                     width: MediaQuery.of(context).size.width * 0.7,
                     child: Text(
                          " ${_viewModel.notificationList[index].body ?? ""}",
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                   ),

                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${formatDate(_viewModel.notificationList[index].currentDate!.split('T').first.toString())}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: baseColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: _viewModel.loadingMsg,
        );

      case ViewState.Completed:
        return _body();

      case ViewState.Error:
        return const Center(
            child: Text(
          "Something Went Wrong",
          style: TextStyle(fontSize: 18),
        ));
      case ViewState.Empty:
        return EmptyListWidget("Nothing Found");

      default:
        return _body();
    }
  }
}
