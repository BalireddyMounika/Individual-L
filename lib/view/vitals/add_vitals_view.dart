import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_eazy/common_widgets/button_container.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/models/vitals/get_vital_response.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/viewmodel/vitals/vitals_viewmodel.dart';
import 'package:stacked/stacked.dart';
class AddVitalsView extends StatefulWidget {
 GetVitalResponse  _vitalResponse;
 bool isEdit = false;
 List<VitalsOptionModel> vitalOptionList;
 AddVitalsView(this._vitalResponse,this.isEdit , this.vitalOptionList);




    @override
  _vitalsState createState() => _vitalsState();
}

class _vitalsState extends State<AddVitalsView> {
  final _formKey = GlobalKey<FormState>();
   BuildContext? _context;
late VitalsViewModel _viewModel;
  @override
  Widget build(BuildContext context) {
     return ViewModelBuilder<VitalsViewModel>.reactive(
       // onModelReady: (model) => model.getVitalByUserId(),
        builder: (context, viewModel, child) {
          _viewModel = viewModel;
          _context = context;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CommonAppBar(
              title: "Add Vitals",
              onBackPressed: () {
                Navigator.pop(context);
              },
              onClearPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.dashboardView, (route) => false);
              },
            ),
            body: _currentWidget(),
            bottomSheet: ButtonContainer(
                buttonText: _viewModel.isEdit ? edit : add,
              // buttonText: "Edit",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                   _formKey.currentState!.save();
                   _viewModel.getVitalByUserId();
                  //    _viewModel.getVitalByUserId();
                    // _viewModel.isEdit?
                    // _viewModel.postVitalInfo();
                  // Scaffold.of(context).showSnackBar(new SnackBar(content: Text("successfully added") )
                }
            ),
                // body: _currentWidget(),
            // _viewModel.vitalResponse.height.toString();
          );
        },

    viewModelBuilder: () => widget.isEdit? VitalsViewModel.edit(widget._vitalResponse, true) :VitalsViewModel());
  }



  Widget _body() {
    return Stack(
        children:[
        SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: ListView.builder(
              itemCount: widget.vitalOptionList.length ,
              itemBuilder:(context , index){
                return Container(
                  child: Text('hhhhhh'),
                );
              }
          )
        ),
      ),

    //    ),
    ]
    );
  }


  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(loadingMessage: _viewModel.loadingMsg,);

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
  Widget _height() {
    return Container(
        height: 57,
        width: 230,
      margin: EdgeInsets.only(left: 10,right: 10),
      child:TextFormField(
         keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      initialValue: _viewModel.getvitalResponse.height.toString(),
      onFieldSubmitted: (v) {
        FocusScope.of(context!).nearestScope;
      },
      onSaved: (value) {
          _viewModel.postvitalRequest.height = int.parse(value??"0");
      },
      validator: (value) {
          if (value!.isEmpty) {
            return "can't be Empty";
          }
          return null;
        },
      style: mediumTextStyle,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        labelText: Height,
        contentPadding:
        EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      ),
      )
    );
  }
  Widget _weight() {
    return Container(
        height: 57,
        width: 230,
        margin: EdgeInsets.only(right: 10,left: 10),
        child:TextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          initialValue: _viewModel.getvitalResponse.weight.toString(),
          onFieldSubmitted: (v) {
            FocusScope.of(context!).nearestScope;
          },
          onSaved: (value) {
            _viewModel.postvitalRequest.weight = int.parse(value??"0");
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            labelText: Weight,
            contentPadding:
            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        )
    );
  }
  Widget _bmi() {
    return Container(
        height: 57,
        width: 230,
        margin: EdgeInsets.only(left: 10,right: 10),
        child:TextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          initialValue: _viewModel.getvitalResponse.bmi.toString(),
          onFieldSubmitted: (v) {
            FocusScope.of(context!).nearestScope;
          },
          onSaved: (value) {
            _viewModel.postvitalRequest.bmi = int.parse(value??"0");
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            labelText: Bmi,
            contentPadding:
            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        )
    );
  }
  Widget _temperature() {
    return Container(
        height: 57,
        width: 230,
        margin: EdgeInsets.only(left: 10,right: 10),
        child:TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: _viewModel.getvitalResponse.temperature.toString(),
          onFieldSubmitted: (v) {
            FocusScope.of(context!).nearestScope;
          },
          onSaved: (value) {
             _viewModel.postvitalRequest.temperature = value??"0";
             // "${_viewModel.vitalList.toString()??""}";
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,

          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            labelText: Temperature,
            contentPadding:
            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        )
    );
  }
  Widget _bp() {
    return Container(
        height: 57,
        width: 230,
        margin: EdgeInsets.only(left: 10,right: 10),
        child:TextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          initialValue: _viewModel.getvitalResponse.bp.toString(),
          onFieldSubmitted: (v) {
            FocusScope.of(context!).nearestScope;
          },
          onSaved: (value) {
             _viewModel.postvitalRequest.bp = int.parse(value??"0");

          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            labelText: Bp,
            contentPadding:
            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        )
    );
  }
  Widget _pulse() {
    return Container(
        height: 57,
        width: 230,
        margin: EdgeInsets.only(left: 10,right: 10),
        child:TextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          initialValue: _viewModel.getvitalResponse.pulse.toString(),
          onFieldSubmitted: (v) {
            FocusScope.of(context!).nearestScope;
          },
          onSaved: (value) {
            _viewModel.postvitalRequest.pulse = int.parse(value??"0");
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            labelText: pulse,
            contentPadding:
            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        )
    );
  }
  Widget _heartrate() {
    return Container(
        height: 57,
        width: 230,
        margin: EdgeInsets.only(left: 10,right: 10),
        child:TextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) {
            FocusScope.of(context!).nearestScope;
          },
          onSaved: (value) {
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            labelText: heartrate,
            contentPadding:
            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        )
    );
  }
  Widget _sp() {
    return Container(
        height: 57,
        width: 230,
        margin: EdgeInsets.only(left: 10,right: 10),
        child:TextFormField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          initialValue: _viewModel.getvitalResponse.spo2.toString(),
          onFieldSubmitted: (v) {
            FocusScope.of(context!).nearestScope;
          },
          onSaved: (value) {
            _viewModel.postvitalRequest.spo2 = int.parse(value??"0");

          },
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            labelText: spo2,
            contentPadding:
            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        )
    );
  }
  Widget _blood() {
    return Container(
        height: 57,
        width: 230,
        margin: EdgeInsets.only(left: 10,right: 10),
        child:TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (v) {
            FocusScope.of(context!).nearestScope;
          },
          onSaved: (value) {},
          validator: (value) {
            if (value!.isEmpty) {
              return "can't be Empty";
            }
            return null;
          },
          style: mediumTextStyle,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            labelText: bloodsugar,
            contentPadding:
            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          ),
        )
    );
  }
}


