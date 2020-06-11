import 'package:flutter_stripe_payments/utils/strings.dart';
import 'constants/app_constants.dart';

mixin InputValidator {
  static const int PASS_TYPE_PASSWORD = 0;
  static const int PASS_TYPE_OLD_PASSWORD = 1;
  static const int PASS_TYPE_NEW_PASSWORD = 2;

  static String validateEmail(String value) {
    Pattern pattern = AppConstants.EMAIL_PATTERN;
    RegExp regex = new RegExp(pattern);

    if (value.isEmpty) {
      return Strings.EMAIL_CANNOT_BE_BLANK;
    } else if (!regex.hasMatch(value)) {
      return Strings.INVALID_EMAIL;
    }
    return null;
  }

  static String validatePassword(String value) {
    if (value.trim().isEmpty) {
      return Strings.PASSWORD_CANNOT_BE_BLANK;
    }
    return null;
  }

  static String validateText(String value) {
    if (value.trim().isEmpty) {
      return Strings.CAN_NOT_BLANK;
    }
    return null;
  }

}
