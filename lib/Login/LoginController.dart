import 'dart:convert';
import 'package:ego/Api.dart';
import 'package:ego/ForgotPassword/ForgotPasswordPage.dart';
import 'package:ego/Signup/SignupPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './LoginModel.dart';
import 'package:flutter/cupertino.dart';

class LoginPageController {
  static final LoginPageController _this = LoginPageController._();
  LoginPageController._();
  factory LoginPageController() => _this;

  late Function setLoginStateHandler;

  void setLoginState(Function handler) {
    setLoginStateHandler = handler;
  }

  void triggerLoginState() {
    setLoginStateHandler();
  }

  void toSignUp(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => SignupPage()),
    );
  }

  void toForgotPassword(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => ForgotPasswordPage()),
    );
  }

  void dispose() {
    LoginModel.email.text = "";
    LoginModel.password.text = "";
    LoginModel.errorMessage = "";
  }

  Future<bool> login() async {
    final response = await http.post(
      Uri.parse('${Api.endpoint}/login'),
      body: {
        'email': LoginModel.email.text.toLowerCase(),
        'password': LoginModel.password.text,
      },
    );
    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final responseData = jsonDecode(response.body);
      Api.token = responseData['token'];
      Api.refreshToken = responseData['refresh_token'];
      await prefs.setString('token', Api.token);
      await prefs.setString('refreshToken', Api.refreshToken);
      dispose();
      return true;
    } else {
      final responseData = jsonDecode(response.body);
      responseData['message'] == 'Incorrect password'
          ? LoginModel.errorMessage = "Incorrect Password"
          : responseData['message'] == "Email does not exist"
              ? LoginModel.errorMessage = "Email does not exist"
              : null;
      triggerLoginState();
      return false;
    }
  }

  bool validateLogin() {
    bool valid = true;
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (LoginModel.email.text.isEmpty) {
      LoginModel.errorMessage = "Email is required";
      valid = false;
    } else if (!emailRegExp.hasMatch(LoginModel.email.text)) {
      LoginModel.errorMessage = "Invalid Email";
      valid = false;
    } else {
      if (LoginModel.password.text.isEmpty) {
        LoginModel.errorMessage = "Password is required";
        valid = false;
      } else if (LoginModel.password.text.length < 8) {
        LoginModel.errorMessage = "Password must be at least 8 characters";
        valid = false;
      } else {
        LoginModel.errorMessage = "";
      }
    }

    triggerLoginState();
    return valid;
  }

  TextEditingController get email => LoginModel.email;
  TextEditingController get password => LoginModel.password;
  bool get correctCredentials => LoginModel.correctCredentials;
  CupertinoThemeData get theme => LoginModel.theme;
  String get errorMessage => LoginModel.errorMessage;

  set theme(CupertinoThemeData theme) {
    LoginModel.theme = theme;
  }
}
