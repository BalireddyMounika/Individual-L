import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/services/common_service/common_api/common_api_service.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/common_service/snackbar_service.dart';
import 'package:life_eazy/services/pharmacy/pharmacy_service.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';
import 'package:open_file/open_file.dart';

import '../../common_widgets/popup_dialog.dart';
import '../../constants/strings.dart';
import '../../enums/profile_image_state.dart';
import '../../enums/snackbar_types.dart';
import '../../enums/viewstate.dart';
import '../../get_it/locator.dart';
import '../../models/generic_response.dart';
import '../../models/pharmacy/get_all_pharmacy_list.dart';
import '../../models/pharmacy/pharmacy_order_request.dart';
import '../../route/routes.dart';

class AddPrescriptionViewModel extends CustomBaseViewModel {
  var _snackBarService = locator<SnackBarService>();
  var _pharmacyService = locator<PharmacyService>();
  var _commonService = locator<CommonApiService>();
  var _dialogService = locator<DialogService>();
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController mobileNumberTextController = TextEditingController();
  TextEditingController deliveryAddressTextController = TextEditingController();
  TextEditingController deliveryDateTextController = TextEditingController();
  TextEditingController prescribedByTextController  = TextEditingController();
  String document = "";
  List<String?> selectedFilesName = [];
  bool isFilesSelect = false;
  String deliveryDate = "";

  Future<GenericResponse> postPharmacyOrder(
      GetAllPharmacyListResponse pharmacyResponse) async {
    var response = GenericResponse();
    try {
      setState(ViewState.Loading);

      var request = new PharmacyOrdersRequest(
        userId: SessionManager.getUser.id,
        professionalId: pharmacyResponse.professionalId,
        userAddress: deliveryAddressTextController.text,
        username: userNameTextController.text,
        userPhoneNumber: mobileNumberTextController.text,
        userSecondaryPhoneNumber:
            int.parse(SessionManager.getUser.mobileNumber ?? "0"),
        pharmacyId: pharmacyResponse.id,
        chronicIllnessQualifier: 'yes',
        uploadDocument: document,
        deliveredDate: deliveryDate,
        deliveredTime: '08:00:00',
        itemQuantity: 0,
        orderStatus: 'pending',
        transactionId: 'string',
        paymentStatus: 'pending',
        prescribedBy: prescribedByTextController.text,
        total: 0,
      );
      var data = await _pharmacyService.postPharmacyOrders(request);

      if (data.statusCode == 200) {
        _dialogService.showDialog(
            DialogType.SuccessDialog, message, "Order Successfully Created", Routes.pharmacyOrderView, done,isStackedCleared: true);
        setState(ViewState.Completed);
      } else {
        setState(ViewState.Completed);
        _snackBarService.showSnackBar(
          title: data.message ?? somethingWentWrong,
        );
      }
    } catch (e) {
      _snackBarService.showSnackBar(
        snackbarType: SnackbarType.error,
        title: somethingWentWrong,
      );
      setState(ViewState.Completed);
    }

    return response;
  }

  Future addUserProfileImage(File file) async {
    try {
       setProfileState(ProfileImageState.Loading);
      var response = await _commonService.postImage(file);
      if (response.hasError == false) {
        var data = response.result as Map<String, dynamic>;
        document = data["Image"];
        setProfileState(ProfileImageState.Completed);

      } else {

        setProfileState(ProfileImageState.Error);
      }
    } catch (e) {
      setProfileState(ProfileImageState.Error);
    }
  }

  Future updateLocation( var data)async{
    if(data!=null) {
      var s = data;
      var country = "";
      var state = "";
      var city = "";
      var address = "";
      var length = s!.split(',').length;
      for (int i = length; i >= 0; i--) {
        country = s!.split(',')[length - 1];
        if (length > 1)
          state = s!.split(',')[length - 2];
        if (length > 2)
          city = s!.split(',')[length - 3];

        if (i < length - 3)
          address = s!.split(',')[i] + "," + address;
      }


     deliveryAddressTextController.text =  address;


      // data = data.split(',').first;

    }
    notifyListeners();
  }

  void pickFile()async{
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'jpg', 'png', 'pdf'],
    );
    if (result != null){
      // File file = File(result.files.single.path ?? '');
      // document = file.path ;
      selectedFilesName = result.names;
      isFilesSelect = true ;
      notifyListeners();
    }
  }



}
