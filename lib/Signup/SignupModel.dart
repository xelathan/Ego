import 'package:flutter/cupertino.dart';

class SignupModel {
  static final TextEditingController firstName = TextEditingController();
  static final TextEditingController lastName = TextEditingController();
  static final TextEditingController email = TextEditingController();
  static final TextEditingController phone = TextEditingController();
  static final TextEditingController password = TextEditingController();
  static final TextEditingController confirmPassword = TextEditingController();
  static final FocusNode firstNameFocus = FocusNode();
  static final FocusNode lastNameFocus = FocusNode();
  static final FocusNode emailFocus = FocusNode();
  static final FocusNode phoneFocus = FocusNode();
  static final FocusNode passwordFocus = FocusNode();
  static final FocusNode confirmPasswordFocus = FocusNode();
  static String errorMessage = "";
  static late CupertinoThemeData theme;
}
