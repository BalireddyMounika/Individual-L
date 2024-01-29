import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:life_eazy/common_widgets/network_image_widget.dart';
import 'package:life_eazy/models/pharmacy/pharmacy_order_response.dart';
import 'package:life_eazy/tools/date_formatting.dart';
import 'package:life_eazy/viewmodel/pharmacy/pharmacy_order_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../common_widgets/button_container.dart';
import '../../common_widgets/common_appbar.dart';
import '../../common_widgets/loader.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../constants/styles.dart';
import '../../constants/ui_helpers.dart';
import '../../enums/viewstate.dart';
import '../../get_it/locator.dart';
import '../../route/routes.dart';
import '../../services/common_service/navigation_service.dart';

class PharmacyOrderDetailView extends StatefulWidget {
  PharmacyOrderResponse pharmacyOrderResponse = PharmacyOrderResponse();
  int total = 0;

  PharmacyOrderDetailView(this.pharmacyOrderResponse) {
    pharmacyOrderResponse.medicine?.forEach((element) {
      total = total + int.parse(element.total ?? "0");
    });
  }

  @override
  State<StatefulWidget> createState() => _PharmacyOrderView();
}

class _PharmacyOrderView extends State<PharmacyOrderDetailView> {
  final textColor = Color(0xff9B9B9B);
  late PharmacyOrderViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PharmacyOrderViewModel>.reactive(
        onModelReady: (model) {
          model.initializePaymentGateway();
        },
        viewModelBuilder: () => PharmacyOrderViewModel(),
        builder: (context, viewModel, child) {
          _viewModel = viewModel;
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: CommonAppBar(
                title: "Pharmacy Order Detail",
                isClearButtonVisible: true,
                onClearPressed: () {
                  locator<NavigationService>()
                      .navigateToAndRemoveUntil(Routes.dashboardView);
                },
                onBackPressed: () {
                  locator<NavigationService>().goBack();
                },
              ),
              bottomSheet: ButtonContainer(
                buttonText: "View Prescription",
                onPressed: () {
                  showDialog(
                      useSafeArea: true,
                      context: context,
                      builder: (dialogContext) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 120),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(dialogContext);
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.clear,
                                    size: 34,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              verticalSpaceMedium,
                              NetworkImageWidget(
                                imageName: widget
                                        .pharmacyOrderResponse.uploadDocument ??
                                    "",
                                height: double.infinity,
                                width: double.infinity,
                              )
                            ],
                          ),
                        );
                      });
                },
              ),
              body: _body());
        });
  }

  Widget _body() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      verticalSpaceMedium,
                      verticalSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(widget.pharmacyOrderResponse.username ?? "NA",
                              style: largeTextStyle.copyWith(
                                  fontWeight: FontWeight.w500)),
                          Container(
                            width: 100,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: redColor)),
                            child: Center(
                                child: Text(
                              widget.pharmacyOrderResponse.orderStatus!
                                      .toUpperCase() ??
                                  "",
                              style: bodyTextStyle.copyWith(color: redColor),
                            )),
                          )
                        ],
                      ),
                      verticalSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_pin,
                            size: 16,
                            color: textColor,
                          ),
                          horizontalSpaceSmall,
                          Flexible(
                              child: Text(
                            widget.pharmacyOrderResponse.userAddress ?? "",
                            style: bodyTextStyle.copyWith(color: textColor),
                          ))
                        ],
                      ),
                      verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: textColor,
                          ),
                          horizontalSpaceSmall,
                          Text(
                            "+91 ${widget.pharmacyOrderResponse.userPhoneNumber}",
                            style: smallTextStyle.copyWith(color: textColor),
                          )
                        ],
                      ),
                      verticalSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Expected Delivery",
                            style: mediumTextStyle.copyWith(
                                color: textColor, fontWeight: FontWeight.w500),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (widget.pharmacyOrderResponse.orderStatus ==
                                  "In-Process")
                                _viewModel.payViaPaymentGateway(
                                    widget.total, widget.pharmacyOrderResponse);
                            },
                            child: Visibility(
                              visible:
                                  widget.pharmacyOrderResponse.orderStatus ==
                                              "confirmed" ||
                                          widget.pharmacyOrderResponse
                                                  .orderStatus ==
                                              "delivered"
                                      ? false
                                      : true,
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: widget.pharmacyOrderResponse
                                                .orderStatus !=
                                            "In-Process"
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
                      ),
                      verticalSpaceSmall,
                      Text(
                        "${formatDate(widget.pharmacyOrderResponse.deliveredDate ?? "")}",
                        style: mediumTextStyle.copyWith(
                            fontWeight: FontWeight.w500),
                      ),
                      verticalSpaceMedium,
                      verticalSpaceMedium,
                      Text(
                        "Order Details",
                        style: mediumTextStyle.copyWith(
                            color: textColor, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        color: textColor,
                        thickness: .5,
                      ),
                      verticalSpaceSmall,
                      widget.pharmacyOrderResponse.orderStatus == "pending"
                          ? EmptyListWidget("No Medicines Added Yet")
                          : Flexible(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: widget
                                      .pharmacyOrderResponse.medicine?.length,
                                  itemBuilder: (context, index) {
                                    return _itemContainer(index);
                                  })),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                Visibility(
                  visible: widget.pharmacyOrderResponse.orderStatus == "pending"
                      ? false
                      : true,
                  child: Container(
                    height: kToolbarHeight,
                    width: MediaQuery.of(context).size.width / 1.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                        color: Color(0xffF8F8F6)),
                    child: Center(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Quantity : ",
                              style: bodyTextStyle.copyWith(color: textColor)),
                          TextSpan(
                              text: widget
                                  .pharmacyOrderResponse.medicine?.length
                                  .toString(),
                              style: mediumTextStyle.copyWith(
                                  fontWeight: FontWeight.w500))
                        ]),
                      ),
                    ),
                  ),
                ),
                verticalSpaceSmall,
                Visibility(
                  visible: widget.pharmacyOrderResponse.orderStatus == "pending"
                      ? false
                      : true,
                  child: Container(
                    height: kToolbarHeight,
                    width: MediaQuery.of(context).size.width / 1.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                        color: redColor.withOpacity(0.5)),
                    child: Center(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Total : ",
                              style: bodyTextStyle.copyWith(color: textColor)),
                          TextSpan(
                              text: "₹ ${widget.total}",
                              style: mediumTextStyle.copyWith(
                                  fontWeight: FontWeight.w500))
                        ]),
                      ),
                    ),
                  ),
                ),
                verticalSpaceMedium,
                verticalSpaceMedium,
                verticalSpaceMedium,
                verticalSpaceMedium,
              ],
            ),
          ),
        ),

        // Positioned(
        //     bottom: 1,
        //     right: 1,
        //     child: Padding(
        //       padding: const EdgeInsets.only(bottom: 30.0,right: 30),
        //       child: FloatingActionButton(
        //         child: Center(
        //           child: Icon(Icons.add,size: 24,color: Colors.white,),
        //         ),
        //         onPressed: () {
        //
        //           locator<NavigationService>().navigateTo(Routes.addPharmacyMedicineView);
        //
        //         },),
        //     ))
      ],
    );
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

  Widget _itemContainer(index) {
    var data = widget.pharmacyOrderResponse.medicine![index];
    return Container(
      height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 5,
              child: Text(
                data.medicine ?? "",
                style: mediumTextStyle.copyWith(fontWeight: FontWeight.w500),
              )),
          Expanded(
              flex: 2,
              child: Text(
                "${data.quantity} x ₹${data.cost}",
                style: bodyTextStyle.copyWith(color: textColor),
              )),
          Expanded(
              flex: 2,
              child: Text(
                "₹${data.total}",
                style: mediumTextStyle.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.end,
              )),
        ],
      ),
    );
  }
}
