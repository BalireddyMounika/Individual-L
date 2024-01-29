import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:stacked/stacked.dart';

import '../../common_widgets/empty_list_widget.dart';
import '../../common_widgets/loader.dart';
import '../../constants/colors.dart';
import '../../enums/viewstate.dart';
import '../../get_it/locator.dart';
import '../../route/routes.dart';
import '../../viewmodel/pharmacy/pharmacy_listing_viewmodel.dart';

class PharmacyListingView extends StatefulWidget {
  @override
  State<PharmacyListingView> createState() => _PharmacyListingViewState();
}

class _PharmacyListingViewState extends State<PharmacyListingView> {
  late PharmacyListingViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PharmacyListingViewModel>.reactive(
        viewModelBuilder: () => PharmacyListingViewModel(),
        onModelReady: (model) => model.getAllPharmacyList(),
        builder: (context, viewModel, child) {
          _viewModel = viewModel;
          return Scaffold(
            appBar: CommonAppBar(
              title: "Select Pharmacy",
              isClearButtonVisible: true,
              onBackPressed: () => Navigator.pop(context),
              onClearPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, Routes.dashboardView, (route) => false),
            ),
            body: _currentWidget(),
          );
        });
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

  _body() {
    return ListView.builder(
        itemCount: _viewModel.allPharmacyList.length,
        itemBuilder: (context, index) {
          return PharmacyListWidget((_viewModel.allPharmacyList.length-index)-1);
        });
  }

  Widget PharmacyListWidget(int index) {
    return Container(
      margin: EdgeInsets.all(10),
      // padding: EdgeInsets.all(20.0),
      child: Card(
        elevation: 2,
        shadowColor: Colors.white,
        child: Container(
          height: 150,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: Image.asset(
                            "images/pharmacy/dummy_medical.png",
                            fit: BoxFit.cover,
                          ).image),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          var map = Map();
                          map['pharmacyResponse'] =
                              _viewModel.allPharmacyList[index];
                          locator<NavigationService>().navigateTo(
                              Routes.pharmacyDetailView,
                              arguments: map);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text("View Details",
                              style: bodyTextStyle.copyWith(
                                  color: baseColor,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),
                horizontalSpaceMedium,
                Flexible(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 7,
                              child: Text(
                                '${_viewModel.allPharmacyList[index].pharmacyName ?? 'Pharmacy Name'}',
                                style: largeTextStyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          Flexible(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                'Open',
                                style: bodyTextStyle.copyWith(
                                  color: baseColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      verticalSpaceSmall,
                      Text(
                        '${_viewModel.allPharmacyList[index].pharmacyAdd ?? 'Address'}',
                        style: bodyTextStyle.copyWith(color: Colors.black87),
                      ),
                      verticalSpaceTiny,
                      Text(
                        "Open From ${_viewModel.allPharmacyList[index].pharmacyOpenTime ?? 'NA'}AM to ${_viewModel.allPharmacyList[index].pharmacyCloseTime ?? 'NA'}PM ",
                        style: bodyTextStyle.copyWith(color: Colors.black87),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            var map = Map();
                            map['pharmacyResponse'] =
                                _viewModel.allPharmacyList[index];
                            locator<NavigationService>().navigateTo(
                                Routes.addPrescriptionView,
                                arguments: map);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10, right: 10),
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "Book",
                                style:
                                    bodyTextStyle.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
