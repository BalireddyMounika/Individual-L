import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:stacked/stacked.dart';

import '../../common_widgets/empty_list_widget.dart';
import '../../common_widgets/loader.dart';
import '../../constants/strings.dart';
import '../../enums/viewstate.dart';
import '../../get_it/locator.dart';
import '../../route/routes.dart';
import '../../viewmodel/pharmacy/pharmacy_order_viewmodel.dart';

class PharmacyOrderView extends StatefulWidget {
  const PharmacyOrderView({Key? key}) : super(key: key);

  @override
  State<PharmacyOrderView> createState() => _PharmacyOrderViewState();
}

class _PharmacyOrderViewState extends State<PharmacyOrderView> {
  late PharmacyOrderViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PharmacyOrderViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.initializePaymentGateway();
          viewModel.getPahrmacyOrders();
        },
        viewModelBuilder: () => PharmacyOrderViewModel(),
        builder: (context, viewModel, child) {
          _viewModel = viewModel;
          return RefreshIndicator(
            onRefresh: () async {
              _viewModel.getPahrmacyOrders();
            },
            child: Scaffold(
                // backgroundColor: Color(0xfff2f2f2),
                backgroundColor: Colors.white,
                appBar: CommonAppBar(
                  onBackPressed: () {
                    if (Navigator.canPop(context))
                      Navigator.pop(context);
                    else
                      locator<NavigationService>()
                          .navigateToAndRemoveUntil(Routes.dashboardView);
                  },
                  onClearPressed: () {
                    locator<NavigationService>()
                        .navigateToAndRemoveUntil(Routes.dashboardView);
                  },
                  title: 'My Order',
                ),
                body: _currentWidget()),
          );
        });
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: "Fetching Orders",
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

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.only(bottom: kToolbarHeight),
      child: Column(
        children: [
          verticalSpaceSmall,
          Container(
            height: kToolbarHeight - 21,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: _viewModel.filterOptionList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _viewModel.filterManager(
                          _viewModel.filterOptionList[index].index,
                          _viewModel.filterOptionList[index].status,
                          _viewModel.filterOptionList[index].name,
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 130,
                        decoration: BoxDecoration(
                          color:
                              _viewModel.filterOptionList[index].status == true
                                  ? baseColor
                                  : Colors.white,
                          border: Border.all(color: baseColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          child: Center(
                            child: Text(
                              _viewModel.filterOptionList[index].name,
                              style: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          _viewModel.pharmacyOrderList.length <= 0
              ? Align(
                  alignment: Alignment.center,
                  child: EmptyListWidget("Nothing Found"))
              : Flexible(
                  child: ListView.builder(
                      itemCount: _viewModel.pharmacyOrderList.length,
                      itemBuilder: (context, index) {
                        return _listContainer(
                            _viewModel.pharmacyOrderList.length - (index + 1));
                      }),
                ),
        ],
      ),
    );
  }

  Widget _listContainer(index) {
    var data = _viewModel.pharmacyOrderList[index];
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF8F8F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'images/pharmacy/dummy_medical.png',
                                height: 60,
                                width: 60.0,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.pharmacyId?.pharmacyName ?? "",
                                  style: mediumTextStyle.copyWith(
                                      fontWeight: FontWeight.w700),
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffE8F3F1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 15,
                                          color: greenColor,
                                        ),
                                        horizontalSpaceTiny,
                                        Text(
                                          '5.0',
                                          style: smallTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          width: 80,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: redColor)),
                          child: Center(
                              child: Text(
                            data.orderStatus!.toUpperCase() ?? "",
                            style: smallTextStyle.copyWith(color: redColor),
                          )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Deliver to',
                          style: smallTextStyle,
                        ),
                        // Text.rich(
                        //   TextSpan(
                        //     children: [
                        //       TextSpan(
                        //           text: ' Order Status : ',
                        //           style: smallTextStyle),
                        //       TextSpan(
                        //           text: data.orderStatus ?? "",
                        //           style: smallTextStyle.copyWith(
                        //               color: greenColor,
                        //               fontWeight: FontWeight.w500)),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: Color(0xffF1FAFF),
                      width: double.infinity,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.username ?? "Rajesh",
                              style: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    size: 15, color: darkColor),
                                Flexible(
                                  child: Text(
                                    '# ${data.userAddress ?? ""}',
                                    style: smallTextStyle,
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(Icons.call, size: 15, color: darkColor),
                                Text(
                                  '+91 ${data.userPhoneNumber}',
                                  style: smallTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Map map = new Map();
                            map["pharmacyOrderResponse"] = data;
                            locator<NavigationService>().navigateTo(
                                Routes.pharmacyOrderDetailView,
                                arguments: map);
                          },
                          child: Container(
                            width: 100,
                            child: Text(
                              "View Details",
                              style: bodyTextStyle,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: data.orderStatus == "confirmed" ||
                                  data.orderStatus == "delivered"
                              ? false
                              : true,
                          child: GestureDetector(
                            onTap: () {
                              int total = 0;
                              data.medicine!.forEach((element) {
                                total = total + int.parse(element.total!);
                              });
                              if (data.orderStatus == "In-Process")
                                _viewModel.payViaPaymentGateway(total, data);
                            },
                            child: Container(
                              width: 100,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: data.orderStatus != "In-Process"
                                      ? disableColor
                                      : baseColor),
                              child: Center(
                                child: Text("Pay",
                                    style: mediumTextStyle.copyWith(
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
