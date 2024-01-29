import 'dart:io';

import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/prescription/get_prescription_response.dart';
import 'package:life_eazy/net/session_manager.dart';
import 'package:life_eazy/services/common_service/common_api/common_api_service.dart';
import 'package:life_eazy/services/prescription/prescription_service.dart';
import 'package:life_eazy/view/prescription/prescription_pdf_api.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:share_plus/share_plus.dart';

import '../base_viewmodel.dart';

class PrescriptionViewModel extends CustomBaseViewModel {
  var _prescriptionService = locator<PrescriptionService>();
  var prescriptionData = GetPrescriptionResponse();
  List<GetPrescriptionResponse> _prescriptionList = [];
  var _commonService = locator<CommonApiService>();
  List<GetPrescriptionResponse> get prescriptionList => _prescriptionList;
  String loadingMsg = "";
  int appointmentId = 0;
  PrescriptionViewModel(this.appointmentId);

  File? _pdfFile;
  PdfController? _pdfController;
  PdfController? get pdfController => _pdfController;
  File? get pdfFile => _pdfFile;
  GetPrescriptionResponse response = GetPrescriptionResponse();

  generatePdf() async {
    // setState(ViewState.Loading);
    var data = await _commonService.getImageByName(
        _prescriptionList.first.hcpId?.professional?.signature ?? "");
    var imageData = data.result as Map<String, dynamic>;
    var image = imageData["Image"];
    _pdfFile = await PdfParagraphApi.generate(_prescriptionList.first, image);
    _pdfController = PdfController(
      document: PdfDocument.openFile(_pdfFile!.path),
    );
    setState(ViewState.Completed);
  }

  share() {
    Share.shareFiles([pdfFile!.path],
        mimeTypes: ['application/pdf'], subject: 'Prescription');
  }

  Future getPrescriptionInfo() async {
    try {
      loadingMsg = "Fetching Prescription";
      setState(ViewState.Loading);

      var response = await _prescriptionService
          .getPrescriptionInfo(SessionManager.getUser.id ?? 0);

      if (response.hasError == false ?? false) {
        setState(ViewState.Error);
      } else {
        var data = response.result as List;

        data.forEach((element) {
          _prescriptionList.add(GetPrescriptionResponse.fromMap(element));
        });

        if (prescriptionList.length >= 1)
          setState(ViewState.Completed);
        else
          setState(ViewState.Empty);
      }
    } catch (e) {
      setState(ViewState.Error);
    }
  }

  Future getPrescriptionInfoByAppointmentId() async {
    try {
      loadingMsg = "Fetching Prescription";
      setState(ViewState.Loading);

      var response = await _prescriptionService
          .getPrescriptionInfoByAppointmentId(appointmentId ?? 0);

      if (response.hasError == true ?? false) {
        setState(ViewState.Error);
      } else {
        var data = response.result as List;

        data.forEach((element) {
          _prescriptionList.add(GetPrescriptionResponse.fromMap(element));
        });

        if (prescriptionList.length >= 1) {
          generatePdf();
        } else
          setState(ViewState.Empty);
      }
    } catch (e) {
      setState(ViewState.Empty);
    }
  }
}
