import 'package:flutter/cupertino.dart';

class ForgotPasswordModel {
  static final phoneNumber = TextEditingController();
  static final verificationCodeList =
      List.generate(6, (_) => TextEditingController());
  static final verificationCodeFocusList = List.generate(6, (_) => FocusNode());
  static final newPassword = TextEditingController();
  static final confirmPassword = TextEditingController();
  static late CupertinoThemeData theme;
  static String phoneErrorMessage = "";
  static String verificationCodeError = "";
  static String newPasswordError = "";
  static String confirmPasswordError = "";
}
