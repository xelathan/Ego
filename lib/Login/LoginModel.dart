import 'package:flutter/cupertino.dart';

class LoginModel {
  static final email = TextEditingController();
  static final password = TextEditingController();
  static String emailErrorMessage = "";
  static String passwordErrorMessage = "";
  static bool correctCredentials = true;
  static late CupertinoThemeData theme;
}
