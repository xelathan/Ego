import 'package:flutter/cupertino.dart';

class ForgotPasswordModel {
  static final email = TextEditingController();
  static final verificationCode = TextEditingController();
  static final newPassword = TextEditingController();
  static final confirmPassword = TextEditingController();
  static late CupertinoThemeData theme;
  static String emailErrorMessage = "";
  static String verificationCodeError = "";
  static String newPasswordError = "";
  static String confirmPasswordError = "";
}
