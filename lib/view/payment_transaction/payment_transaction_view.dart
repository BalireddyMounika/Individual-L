import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:life_eazy/common_widgets/common_appbar.dart';
import 'package:life_eazy/common_widgets/empty_list_widget.dart';
import 'package:life_eazy/common_widgets/loader.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/margins.dart';
import 'package:life_eazy/constants/strings.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/constants/ui_helpers.dart';
import 'package:life_eazy/enums/viewstate.dart';
import 'package:life_eazy/models/paymentt_transactions/payment_transaction_response.dart';
import 'package:life_eazy/route/routes.dart';
import 'package:life_eazy/tools/date_formatting.dart';
import 'package:life_eazy/viewmodel/transaction/payment_transaction_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PaymentTransactionView extends StatelessWidget {
  late PaymentTransactionViewModel _viewModel;
  late BuildContext _context;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentTransactionViewModel>.reactive(
        onModelReady: (model) => model.getPaymentTransactionList(),
        builder: (context, viewModel, child) {
          _viewModel = viewModel;
          _context = context;

          return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: CommonAppBar(
                title: transactionHistory,
                isClearButtonVisible: true,
                onBackPressed: () {
                  Navigator.pop(context);
                },
                onClearPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.dashboardView, (route) => false);
                },
              ),
              body: _currentWidget());
        },
        viewModelBuilder: () => PaymentTransactionViewModel());
  }

  Widget _body() {
    return Container(
      margin: dashBoardMargin,
      child: ListView.builder(
          itemCount: _viewModel.paymentTransactionHistoryList.length,
          itemBuilder: (context, index) {
            var data = _viewModel.paymentTransactionHistoryList[
                _viewModel.paymentTransactionHistoryList.length - (index + 1)];
            return _transactionList(data);
          }),
    );
  }

  Widget _transactionList(PaymentTransactionResponse data) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: EdgeInsets.all(15.0),
      color: whiteColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.transactionFor?.toUpperCase() ?? "",
                style: bodyTextStyle.copyWith(color: baseColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("ID:",
                      style: mediumTextStyle.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Text((data.maskTransactionId ?? ""),
                      style: mediumTextStyle.copyWith(
                        color: blackColor,
                      )),
                ],
              ),
            ],
          ),
          verticalSpaceMedium,
          Container(
            height: 60,
            width: MediaQuery.of(_context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Transaction date",
                    style: bodyTextStyle.copyWith(
                      color: Colors.grey,
                    )),
                SizedBox(height: 5),
                Text(("${formatDate(data.date ?? "")}"),
                    style: mediumTextStyle.copyWith(
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
          ),
          verticalSpaceMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(("Rs ${data.amount.toString() ?? ""}"),
                  style: mediumTextStyle.copyWith(
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                  )),
              Text("Success",
                  style: mediumTextStyle.copyWith(
                    color: redColor,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _listContainerItem(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Text(
              title,
              style: bodyTextStyle.copyWith(color: darkColor),
            )),
        Expanded(
            flex: 1,
            child: Text(data,
                textAlign: TextAlign.end,
                style: mediumTextStyle.copyWith(color: Colors.black))),
      ],
    );
  }

  Widget _listContainer(PaymentTransactionResponse data) {
    return Container(
        child: Card(
      elevation: standardCardElevation,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _listContainerItem(transactionId, data.maskTransactionId ?? ""),
            // _listContainerItem('MaskTr' ,data.maskTransactionId??""),
            SizedBox(
              height: 10,
            ),
            //_listContainerItem(dateOfBooking, data.date??""),
            _listContainerItem(dateOfBooking, "${formatDate(data.date ?? "")}"),
            SizedBox(
              height: 10,
            ),
            _listContainerItem(transactionStatus, "Success"),
            SizedBox(
              height: 10,
            ),
            _listContainerItem(amount, "Rs ${data.amount.toString() ?? ""}"),
            SizedBox(
              height: 10,
            ),
            _listContainerItem(appointmentType, data.appointmentType ?? ""),
          ],
        ),
      ),
    ));
  }

  Widget _currentWidget() {
    switch (_viewModel.state) {
      case ViewState.Loading:
        return Loader(
          loadingMessage: "Fetching Payment Transactions",
          loadingMsgColor: Colors.black,
        );

      case ViewState.Completed:
        return _body();
      case ViewState.Empty:
        return EmptyListWidget("Nothing Found");
      case ViewState.Error:
        return Center(
            child: Text(
          somethingWentWrong,
          style: mediumTextStyle,
        ));

      default:
        return _body();
    }
  }
}
