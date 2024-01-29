import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/network_image_widget.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/viewmodel/appointments/doctor_details_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DoctorDetailView extends StatefulWidget {
  final int doctorId;

  DoctorDetailView(this.doctorId);

  @override
  State<DoctorDetailView> createState() => _DoctorDetailViewState();
}

class _DoctorDetailViewState extends State<DoctorDetailView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DoctorDetailsViewModel>.reactive(
      onViewModelReady: (model) =>
          model.getDoctorsDetails(doctorId: widget.doctorId),
      viewModelBuilder: () => DoctorDetailsViewModel(),
      builder: (BuildContext context, DoctorDetailsViewModel viewModel,
          Widget? child) {
        return Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 57,
              color: baseColor,
              child: Center(
                child: Text(
                  'Book Now',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: whiteColor),
                ),
              ),
            ),
          ),
          appBar: AppBar(
            title: Text('Doctor Details'),
          ),
          body: Column(
            children: [
              Container(
                color: baseColor.withOpacity(0.5),
                height: 200,
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: ClipOval(
                      child: NetworkImageWidget(
                        imageName: viewModel
                                .doctorDetailResponse.profile?.profilePicture ??
                            '',
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${viewModel.doctorDetailResponse.firstname} ${viewModel.doctorDetailResponse.lastname}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: greyColor,
                          size: 20,
                        ),
                        Text(
                          '${viewModel.doctorDetailResponse.profile?.address ?? '__'}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: baseColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        child: Text(
                          '${viewModel.doctorDetailResponse.professional?.specialization ?? ''}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Professional Details',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: baseColor),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        detailsWidget(
                            name: 'Professional Id',
                            value:
                                '${viewModel.doctorDetailResponse.professional?.mciNumber}'),
                        detailsWidget(
                            name: 'Specialization',
                            value:
                                '${viewModel.doctorDetailResponse.professional?.specialization}'),
                        detailsWidget(
                            name: 'Experience',
                            value:
                                '${viewModel.doctorDetailResponse.professional?.professionalExperienceInYears}'),
                        detailsWidget(
                            name: 'Area of Focus',
                            value:
                                '${viewModel.doctorDetailResponse.professional?.areaFocusOn}'),
                        detailsWidget(
                            name: 'MCI No',
                            value:
                                '${viewModel.doctorDetailResponse.professional?.mciNumber}'),
                        detailsWidget(
                            name: 'MCI State Council',
                            value:
                                '${viewModel.doctorDetailResponse.professional?.mciStateCouncil}'),
                      ],
                    ),
                    SizedBox(height: 25),
                    Text(
                      'Education Details',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: baseColor),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        detailsWidget(
                            name: 'College',
                            value:
                                '${viewModel.doctorDetailResponse.education?.collegeUniversity}'),
                        detailsWidget(
                            name: 'Degree',
                            value:
                                '${viewModel.doctorDetailResponse.professional?.specialization}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  detailsWidget({required String name, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$name :',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: greyColor),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
