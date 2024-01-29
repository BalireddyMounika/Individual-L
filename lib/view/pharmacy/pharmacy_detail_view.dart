import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/services/common_service/navigation_service.dart';
import 'package:stacked/stacked.dart';

import '../../constants/styles.dart';
import '../../get_it/locator.dart';
import '../../models/pharmacy/get_all_pharmacy_list.dart';
import '../../route/routes.dart';
import '../../viewmodel/pharmacy/pharmacy_listing_viewmodel.dart';

class PharmacyDetalView extends StatelessWidget {
  GetAllPharmacyListResponse response = GetAllPharmacyListResponse();
  PharmacyDetalView(this.response);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PharmacyListingViewModel>.nonReactive(
        viewModelBuilder: () => PharmacyListingViewModel(),
        builder: (context, vm, child) {
          return Scaffold(
            appBar: CommonAppBar(
              title: "Pharmacy Detail",
              isClearButtonVisible: true,
              onBackPressed: () {
                locator<NavigationService>().goBack();
              },
              onClearPressed: () {
                locator<NavigationService>()
                    .navigateToAndRemoveUntil(Routes.dashboardView);
              },
            ),

            bottomSheet: ButtonContainer(
              buttonText: "Book",
              onPressed: () {
                var map = Map();
                map['pharmacyResponse'] = response;
                locator<NavigationService>()
                    .navigateTo(Routes.addPrescriptionView, arguments: map);
              },
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    verticalSpaceMedium,
                    _upperContainer(),
                    verticalSpaceSmall,
                    Text("",
                        style: mediumTextStyle.copyWith(color: redColor)),
                    verticalSpaceMedium,
                    _detailContainer(),
                    verticalSpaceMassive,
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _upperContainer() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(2),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(blurRadius: 2, color: Colors.grey),
            ],
            // border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: Image.asset(
                    "images/pharmacy/dummy_medical.png",
                    fit: BoxFit.fitWidth,
                  ).image),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        response.pharmacyName ?? "",
                        maxLines: 2,
                        style: largeTextStyle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 1),
                        child: Text(
                          response.pharmacyAdd ?? "",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontFamily: textFamily),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Open From ${response.pharmacyOpenTime} to ${response.pharmacyCloseTime} ",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailContainer() {
    return Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Padding(

            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Container(
              decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
              ),
              child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [

              verticalSpaceSmall,
              _itemContainer(
                  "Authorised First Name", response.authorizedFirstName),
              _itemContainer(
                  "Authorised Last Name", response.authorizedLastName),
              _itemContainer(
                  "Authorised Email Id", response.authorizedEmailId),
              _itemContainer("Authorised Mobile Number",
                  response.authorizedMobileNumber),
              _itemContainer("Authorised License Number",
                  response.authorizedLicenseNumber),
              _itemContainer("Pharmacy Name", response.pharmacyName),
              _itemContainer("Pharmacy Email Id", response.pharmacyEmailId),
              _itemContainer("Pharmacy Registration Number ",
                  response.pharmacyRegistrationNumber),
              _itemContainer("Pharmacy Contact Number",
                  response.pharmacyContactNumber),
              // _itemContainer(
              //     "Pharmacy Open Time", response.pharmacyOpenTime),
              // _itemContainer(
              //     "Pharmacy Close Time", response.pharmacyCloseTime),
             // _itemContainer("Pharmacy Add", response.pharmacyAdd),
            ],
              ),
            ),
          ),
          Positioned(
              top:-20,
              child: Container(
                height: 40,
                width: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: pharmacyHeaderBgColor
                ),
                child: Center(
                  child: Text("Pharmacy Details",
                      style: mediumTextStyle,
                  ),
                ),
              )
          ),
        ]);
  }

  Widget _itemContainer(title, data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 23,left: 18),
            child: Text("$title : ",
                style: bodyTextStyle.copyWith(color: blackColor, fontWeight: FontWeight.w500)),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 23,left: 18),
            child: Text(data,
                style: mediumTextStyle.copyWith(
                    color: Colors.black54,)),
          ),
        )
      ],
    );
  }
}
