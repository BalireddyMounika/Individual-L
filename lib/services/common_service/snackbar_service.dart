import 'package:flutter/material.dart';
import 'package:life_eazy/constants/colors.dart';
import 'package:life_eazy/constants/styles.dart';
import 'package:life_eazy/enums/snackbar_types.dart';
import 'package:life_eazy/main.dart';

class SnackBarService {
  void showSnackBar({String? title, SnackbarType? snackbarType,int duration =0}) {
    final SnackBar snackBar = SnackBar(
      content: Text(title ?? "",
          style: mediumTextStyle.copyWith(color: Colors.white)),
      backgroundColor: getColor(snackbarType ?? SnackbarType.simple),
      duration: new Duration(seconds: duration == 0? 3:duration),
    );
    // globalStateKey.currentState?.showSnackBar(snackBar);
  }

  Color getColor(SnackbarType snackbarType) {
    switch (snackbarType) {
      case SnackbarType.success:
        return successColor;
      case SnackbarType.error:
        return errorColor;
      case SnackbarType.info:
        return greyColor;
      case SnackbarType.simple:
        return greyColor;
      default:
        return greenColor;
    }
  }
}
