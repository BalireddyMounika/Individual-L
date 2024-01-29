import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/route/routes.dart';

import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../models/immunization/getImmuinisationResponse.dart';
import '../../viewmodel/Immunization/immunization_viewmodel.dart';
import '../common_web_view.dart';

class ImmunizationDetailView extends StatelessWidget {
  GetImmunizationResponse response = new GetImmunizationResponse();
  ImmunizationDetailView(this.response);
  late ImmunizationViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          title: "Immunization Detail",
          isClearButtonVisible: true,
          onBackPressed: () {
            if (Navigator.canPop(context))
              Navigator.pop(context);
            else
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.dashboardView, (route) => false);
          },
          onClearPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.dashboardView, (route) => false);
          },
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 120,
                              width: 130,
                              margin: EdgeInsets.only(bottom: 5, left: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: baseColor,
                                shape: BoxShape.rectangle,
                                border: Border(),
                                image: DecorationImage(
                                  image: Image.network(
                                          "https://images.pexels.com/photos/2820884/pexels-photo-2820884.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500")
                                      .image,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  verticalSpaceMedium,
                                  Text("Vaccine Name",
                                      style: mediumTextStyle.copyWith(
                                          color: immunizationVaccineNameColor,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    response.vaccine ?? '-',
                                    style: bodyTextStyle.copyWith(
                                        color: blackColor,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 2,
                                  ),
                                  verticalSpaceMedium,
                                  Text("Date",
                                      style: bodyTextStyle.copyWith(
                                          color: immunizationVaccineNameColor,
                                          fontWeight: FontWeight.w500)),
                                  Text(response.immunizationId?.first.dateOfImmunization ?? '-',
                                      style: bodyTextStyle.copyWith(
                                          color: blackColor,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                _listContainer(
                                    "Person Type ", response.personType),
                                _listContainer("Vaccine", response.vaccine),
                                _listContainer(
                                    "When To Give", response.whentogive),
                                _listContainer("Dose", response.dose),
                                _listContainer("Route", response.route),
                                _listContainer("Site", response.site),
                                //child: _listContainer("Reference Link", response.referenceDocument),
                                SizedBox(
                                  height: 35,
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 5, left: 18),
                                  child: Text("Reference Link:",
                                      style: bodyTextStyle.copyWith(
                                          color: blackColor,
                                          fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => CommonWebView(
                                                    "http://nhm.gov.in/New_Updates_2018/NHM_Components/Immunization/report/National_%20Immunization_Schedule.pdf",
                                                    "Created PDF",
                                                  )));
                                    },
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Text(
                                            "National Immunization Schedule by NHM - India",
                                            style: bodyTextStyle.copyWith(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            )),
                                      ),
                                    ))
                              ]),
                        ),
                      ),
                    ),
                    Positioned(
                        top: -10,
                        child: Container(
                          height: 40,
                          width: 180,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: pharmacyHeaderBgColor),
                          child: Center(
                            child: Text("Vaccination Details",
                                style: mediumTextStyle.copyWith(
                                  color: whiteColor,
                                )),
                          ),
                        )),
                  ],
                )
              ]),
        ));
  }

  Widget _listContainer(title, data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 30, left: 18),
            child: Text("$title : ",
                style: bodyTextStyle.copyWith(
                    color: blackColor, fontWeight: FontWeight.w500)),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(data,
                style: mediumTextStyle.copyWith(
                  color: Colors.black54,
                )),
          ),
        )
      ],
    );
  }
}
