import 'dart:convert';

import 'package:ego/ForgotPassword/ForgotPasswordModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ego/Api.dart';

class ForgotPasswordController {
  static final ForgotPasswordController _this = ForgotPasswordController._();
  ForgotPasswordController._();
  factory ForgotPasswordController() => _this;

  late Function setForgotPasswordStateHandler;

  void setForgotPasswordState(Function handler) {
    setForgotPasswordStateHandler = handler;
  }

  void triggerForgotPasswordState() {
    setForgotPasswordStateHandler();
  }

  void dispose() {
    ForgotPasswordModel.email.text = "";
    ForgotPasswordModel.newPassword.text = "";
    ForgotPasswordModel.confirmPassword.text = "";
  }

  Future<bool> validateEmail() async {
    bool valid = true;
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (ForgotPasswordModel.email.text.isEmpty) {
      ForgotPasswordModel.emailErrorMessage = "Email is required";
      valid = false;
    } else if (!emailRegExp.hasMatch(ForgotPasswordModel.email.text)) {
      ForgotPasswordModel.emailErrorMessage = "Invalid Email";
      valid = false;
    } else {
      final response = await http.post(
        Uri.parse('${Api.endpoint}/validate_email'),
        body: {
          'email': ForgotPasswordModel.email.text.toLowerCase(),
        },
      );
      if (response.statusCode == 200) {
        ForgotPasswordModel.emailErrorMessage = "";
      } else {
        ForgotPasswordModel.emailErrorMessage = "Email doesn't exist";
        valid = false;
      }
    }

    triggerForgotPasswordState();
    return Future(() => valid);
  }

  Future<bool> sendEmail() async {
    bool success = false;
    final response = await http.post(
      Uri.parse('${Api.endpoint}/send_email'),
      body: {
        'email': ForgotPasswordModel.email.text.toLowerCase(),
      },
    );

    if (response.statusCode == 200) {
      success = true;
      return Future(() => success);
    } else {
      print("Could not send email");
      return Future(() => success);
    }
  }

  Future<bool> validateCode() async {
    bool success = false;
    final response = await http.post(
      Uri.parse('${Api.endpoint}/send_email'),
      body: {
        'code': ForgotPasswordModel.verificationCode.text,
      },
    );
    if (response.statusCode == 200) {
      return Future(() => success);
    } else {
      success = false;
      final data = jsonDecode(response.body);
      ForgotPasswordModel.emailErrorMessage = data['message'];
      return Future(() => success);
    }
  }

  TextEditingController get email => ForgotPasswordModel.email;
  TextEditingController get newPassword => ForgotPasswordModel.newPassword;
  TextEditingController get verificationCode =>
      ForgotPasswordModel.verificationCode;
  TextEditingController get confirmPassword =>
      ForgotPasswordModel.confirmPassword;
  CupertinoThemeData get theme => ForgotPasswordModel.theme;
  String get emailErrorMessage => ForgotPasswordModel.emailErrorMessage;
  String get verificationCodeErrorMessage =>
      ForgotPasswordModel.verificationCodeError;
  String get newPasswordError => ForgotPasswordModel.newPasswordError;
  String get confirmPasswordError => ForgotPasswordModel.confirmPasswordError;

  set theme(CupertinoThemeData theme) {
    ForgotPasswordModel.theme = theme;
  }
}
