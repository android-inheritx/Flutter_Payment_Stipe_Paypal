import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe_payments/utils/constants/app_constants.dart';
import 'package:flutter_stripe_payments/utils/strings.dart';

class Dialogs {
  /// Show info dialogs with OK button
  static showInfoDialog(BuildContext context, String message,
      {Function onPressed, bool isCancelable = true}) async {
    String btnText = Strings.OK;
    String title = AppConstants.APP_NAME;

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
            onPressed: onPressed ??
                    () {
                  Navigator.pop(context);
                },
            child: Text(btnText)),
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: isCancelable,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// Show dialogs with three option buttons
  static showDialogWithTwoOptions(
      BuildContext context, String message, String positiveButtonText,
      {VoidCallback positiveButtonCallBack, bool isCancelable = true}) async {
    String btnText = Strings.CANCEL;
    String title = AppConstants.APP_NAME;

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
            onPressed: positiveButtonCallBack, child: Text(positiveButtonText)),
        CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(btnText)),
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: isCancelable,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
