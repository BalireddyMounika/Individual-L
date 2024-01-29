import 'dart:io';

import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/get_it/locator.dart';
import 'package:life_eazy/models/prescription/get_prescription_response.dart';
import 'package:life_eazy/services/common_service/common_api/common_api_service.dart';
import 'package:life_eazy/viewmodel/base_viewmodel.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:share_plus/share_plus.dart';

import '../../view/prescription/prescription_pdf_api.dart';

class PrescriptionDetailViewModel extends CustomBaseViewModel {
  File? _pdfFile;
  PdfController? _pdfController;
  PdfController? get pdfController => _pdfController;
  File? get pdfFile => _pdfFile;
  var _commonService = locator<CommonApiService>();
  GetPrescriptionResponse response = GetPrescriptionResponse();
  PrescriptionDetailViewModel(this.response);

  generatePdf() async {
    setState(ViewState.Loading);
    var data = await _commonService
        .getImageByName(response.hcpId?.professional?.signature ?? "");
    var imageData = data.result as Map<String, dynamic>;
    var image = imageData["Image"];
    _pdfFile = await PdfParagraphApi.generate(response, image);
    _pdfController = PdfController(
      document: PdfDocument.openFile(_pdfFile!.path),
    );
    setState(ViewState.Completed);
  }

  share() {
    Share.shareFiles([pdfFile!.path],
        mimeTypes: ['application/pdf'], subject: 'Prescription');
  }
}
