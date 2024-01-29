import 'package:flutter/material.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/models/appointments/doctor_details_response.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/colors.dart';
import '../../../constants/margins.dart';
import '../../../constants/styles.dart';
import '../../../constants/ui_helpers.dart';
import '../../../models/appointments/appointment_request.dart';
import '../../../viewmodel/appointments/doctor_appointment_booking_slots_viewmodel.dart';
class SymptomViewWidget extends StatefulWidget {
 final DoctorDetailResponse doctorDetailResponse;
 SymptomViewWidget(this.doctorDetailResponse);



  @override
  State<SymptomViewWidget> createState() => _SymptomViewWidgetState();
}

class _SymptomViewWidgetState extends State<SymptomViewWidget> {
  late DoctorAppointmentBookingSlotsViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<DoctorAppointmentBookingSlotsViewModel>.reactive(
        viewModelBuilder:()=>DoctorAppointmentBookingSlotsViewModel(widget.doctorDetailResponse),
        builder: (context , viewModel , child){
          _viewModel = viewModel ;
          return Scaffold(

              backgroundColor: Colors.white,
            appBar: CommonAppBar(
              title: 'Add Symptoms',
              onBackPressed: () {
                Navigator.pop(context);
              },
            ),
            bottomSheet: ButtonContainer(
              buttonText: 'Add',
              onPressed: (){
               if (_formKey.currentState!.validate())
                Navigator.pop(context,[_viewModel.symptomTextController.text,_viewModel.commentTextController.text]);

              },
            ),
            body: Container(
           margin: authMargin,
            child:
                Form(
                    key: _formKey,
          child:
            Column(
              children: [
                verticalSpaceLarge,

                TextFormField(
                  autofocus: true,
                  validator:(value)=>validate(value),
                  controller: _viewModel.symptomTextController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      label: Text('Symptoms',style: bodyTextStyle,),
                      alignLabelWithHint: true,

                      hintText: ' i.e. Fever, Cold, Cough...',
                      hintStyle: bodyTextStyle,
                      border: commonBorderStyle(),
                      focusedBorder: commonBorderStyle(),
                      focusedErrorBorder: commonBorderStyle(),

                  ),
                ),
                verticalSpaceMedium,
                TextFormField(
                  textInputAction: TextInputAction.done,
                  validator: (value)=>validate(value),
                  controller: _viewModel.commentTextController,
                  keyboardType: TextInputType.multiline,
                  minLines: 4,
                  maxLines: 4,
                  decoration: InputDecoration(
                      label: Text('Comments',style: bodyTextStyle,),
                     alignLabelWithHint: true,
                     hintMaxLines: 4,
                      hintText: 'Message...',
                      hintStyle: bodyTextStyle,
                      border: commonBorderStyle(),
                      focusedBorder: commonBorderStyle(),
                      focusedErrorBorder: commonBorderStyle(),
                  ),
                ),
              ],

            )

          ),
            ),
          );
        }
        );
  }

  //for checking empty field
  validate (value) {
  if (value == null || value.isEmpty) {
  return 'Please fill this field';
  }
  return null;
  }


  OutlineInputBorder commonBorderStyle() {
    return OutlineInputBorder(

        borderSide: BorderSide(
          width: 1,
          color: baseColor,
        ),

    );
  }
}
