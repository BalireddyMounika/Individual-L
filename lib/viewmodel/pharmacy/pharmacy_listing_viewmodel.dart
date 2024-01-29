import 'package:life_eazy/common_widgets/popup_dialog.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/pharmacy/get_all_pharmacy_list.dart';
import 'package:life_eazy/services/common_service/dialog_services.dart';
import 'package:life_eazy/services/pharmacy/pharmacy_service.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';

import '../../constants/strings.dart';

class PharmacyListingViewModel extends CustomBaseViewModel {
  var _pharmacyService = locator<PharmacyService>();
  var _dialogService = locator<DialogService>();

  List<GetAllPharmacyListResponse> _allPharmacyList = [];
  List<GetAllPharmacyListResponse> get allPharmacyList => _allPharmacyList;
  GetAllPharmacyListResponse response = GetAllPharmacyListResponse();
  PharmacyListingViewModel();
  PharmacyListingViewModel.viewDetails(this.response);

  Future getAllPharmacyList() async {
    try {
      setState(ViewState.Loading);
      var response = await _pharmacyService.getAllPharmacyList();
      if (response.hasError ?? false) {
        _dialogService.showDialog(
            DialogType.ErrorDialog, message, response.message, "", done);
      } else {
        var data = response.result as List;
        data.forEach((element) {
          _allPharmacyList.add(GetAllPharmacyListResponse.fromMap(element));
        });
      }
      if (_allPharmacyList.isNotEmpty)
        setState(ViewState.Completed);
      else
        setState(ViewState.Empty);
    } catch (e) {
      _dialogService.showDialog(
          DialogType.ErrorDialog, message, somethingWentWrong, "", done);
      setState(ViewState.Completed);
    }
  }
}
